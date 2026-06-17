#!/usr/bin/env bash
#
# Bootstrap a fresh NixOS server (Legacy/MBR boot) with SSH access.
# Intended as a one-shot setup before deploy-rs takes over.
#
# From your local machine:
#
#   scp install/nixos-install.sh root@<host>:
#   ssh root@<host> bash nixos-install.sh ssh-ed25519 <key-body> [swap-size]
#
# After reboot, SSH in as aydin and point deploy-rs at the host.

set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <key-type> <key-body> [swap-size]"
    echo "Example: $0 ssh-ed25519 AAAA... 8GB"
    exit 1
fi

KEY_TYPE="${1}"
KEY_BODY="${2:?Missing key body}"
SSH_PUBLIC_KEY="${KEY_TYPE} ${KEY_BODY}"
SWAP_SIZE="${3:-8GB}"

if [[ ! "${KEY_TYPE}" =~ ^ssh- ]]; then
    echo "Error: '${KEY_TYPE}' doesn't look like an SSH key type."
    exit 1
fi

echo "Available disks:"
echo ""
lsblk -d -o NAME,SIZE,MODEL
echo ""

read -rp "Which disk? (e.g. sda, vda, nvme0n1): " DISK_NAME
DEVICE="/dev/${DISK_NAME}"

if [[ ! -b "${DEVICE}" ]]; then
    echo "Error: ${DEVICE} is not a block device."
    exit 1
fi

echo ""
echo "Installing NixOS on ${DEVICE} (Legacy/MBR, swap: ${SWAP_SIZE})"
echo "This will ERASE all data on ${DEVICE}."
read -rp "Continue? [y/N] " confirm
[[ "${confirm}" =~ ^[Yy]$ ]] || exit 1

echo "Partitioning ${DEVICE}..."
parted "${DEVICE}" -- mklabel msdos
parted "${DEVICE}" -- mkpart primary 1MB "-${SWAP_SIZE}"
parted "${DEVICE}" -- set 1 boot on
parted "${DEVICE}" -- mkpart primary linux-swap "-${SWAP_SIZE}" 100%

echo "Formatting..."
mkfs.ext4 -L nixos "${DEVICE}1"
mkswap -L swap "${DEVICE}2"

echo "Waiting for disk labels..."
sleep 2

echo "Mounting..."
mount /dev/disk/by-label/nixos /mnt
swapon /dev/disk/by-label/swap

echo "Generating NixOS configuration..."
nixos-generate-config --root /mnt

CONFIG="/mnt/etc/nixos/configuration.nix"

echo "Patching configuration.nix..."
cat > "${CONFIG}" << NIXEOF
{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub = {
    enable = true;
    device = "${DEVICE}";
  };

  networking.hostName = "nixos";

  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = [ "aydin" ];
  };

  environment.systemPackages = with pkgs; [
    vim
  ];

  users.users = {
    root.hashedPassword = "!";
    aydin = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "${SSH_PUBLIC_KEY}"
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  system.stateVersion = "25.11";
}
NIXEOF

echo ""
echo "Configuration written. Review:"
echo ""
cat "${CONFIG}"
echo ""

read -rp "Run nixos-install? [y/N] " install_confirm
if [[ "${install_confirm}" =~ ^[Yy]$ ]]; then
    nixos-install --no-root-password
    echo "Done. Reboot and SSH in as aydin."
else
    echo "Skipped. Run 'nixos-install --no-root-password' when ready."
fi

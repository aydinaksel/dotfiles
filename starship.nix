{
  continuation_prompt = "[.](bright-black) ";

  character = {
    success_symbol = "[>](bold green)";
    error_symbol = "[x](bold red)";
    vimcmd_symbol = "[<](bold green)";
    vimcmd_visual_symbol = "[<](bold yellow)";
    vimcmd_replace_symbol = "[<](bold purple)";
    vimcmd_replace_one_symbol = "[<](bold purple)";
  };

  git_branch = {
    symbol = "git ";
    truncation_symbol = "...";
  };

  git_commit.tag_symbol = " tag ";

  git_status = {
    ahead = "ahead $count ";
    behind = "behind $count ";
    diverged = "diverged $count ";
    renamed = "renamed $count ";
    deleted = "deleted $count ";
    conflicted = "conflicted $count ";
    stashed = "stashed $count ";
    modified = "modified $count ";
    staged = "staged $count ";
    untracked = "untracked $count ";
  };

  aws.symbol = "aws ";
  azure.symbol = "az ";

  battery = {
    full_symbol = "full ";
    charging_symbol = "charging ";
    discharging_symbol = "discharging ";
    unknown_symbol = "unknown ";
    empty_symbol = "empty ";
  };

  container.symbol = "container ";
  directory.read_only = " ro";
  docker_context.symbol = "docker ";

  fossil_branch = {
    symbol = "fossil ";
    truncation_symbol = "...";
  };

  gcloud.symbol = "gcp ";
  helm.symbol = "helm ";

  hg_branch = {
    symbol = "hg ";
    truncation_symbol = "...";
  };

  hostname.ssh_symbol = "ssh ";
  jobs.symbol = "*";
  kubernetes.symbol = "kubernetes ";
  memory_usage.symbol = "memory ";
  nats.symbol = "nats ";
  netns.symbol = "netns ";
  nix_shell.symbol = "nix ";
  openstack.symbol = "openstack ";

  os.symbols = {
    AIX = "aix ";
    Alpaquita = "alq ";
    AlmaLinux = "alma ";
    Alpine = "alp ";
    ALTLinux = "alt ";
    Amazon = "amz ";
    Android = "andr ";
    AOSC = "aosc ";
    Arch = "rch ";
    Artix = "atx ";
    Bluefin = "blfn ";
    CachyOS = "cach ";
    CentOS = "cent ";
    Debian = "deb ";
    DragonFly = "dfbsd ";
    Elementary = "elem ";
    Emscripten = "emsc ";
    EndeavourOS = "ndev ";
    Fedora = "fed ";
    FreeBSD = "fbsd ";
    Garuda = "garu ";
    Gentoo = "gent ";
    HardenedBSD = "hbsd ";
    Illumos = "lum ";
    Ios = "ios ";
    InstantOS = "inst ";
    Kali = "kali ";
    Linux = "lnx ";
    Mabox = "mbox ";
    Macos = "mac ";
    Manjaro = "mjo ";
    Mariner = "mrn ";
    MidnightBSD = "mid ";
    Mint = "mint ";
    NetBSD = "nbsd ";
    NixOS = "nix ";
    Nobara = "nbra ";
    OpenBSD = "obsd ";
    OpenCloudOS = "ocos ";
    openEuler = "oeul ";
    openSUSE = "osuse ";
    OracleLinux = "orac ";
    PikaOS = "pika ";
    Pop = "pop ";
    Raspbian = "rasp ";
    Redhat = "rhl ";
    RedHatEnterprise = "rhel ";
    RockyLinux = "rky ";
    Redox = "redox ";
    Solus = "sol ";
    SUSE = "suse ";
    Ubuntu = "ubnt ";
    Ultramarine = "ultm ";
    Unknown = "unk ";
    Uos = "uos ";
    Void = "void ";
    Windows = "win ";
    Zorin = "zorn ";
  };

  pijul_channel = {
    symbol = "pijul ";
    truncation_symbol = "...";
  };

  pulumi.symbol = "pulumi ";
  shlvl.symbol = "shlvl ";

  status = {
    symbol = "[x](bold red) ";
    not_executable_symbol = "noexec";
    not_found_symbol = "notfound";
    sigint_symbol = "sigint";
    signal_symbol = "sig";
  };

  sudo.symbol = "sudo ";
  terraform.symbol = "terraform ";
  vagrant.symbol = "vagrant ";

  buf.disabled = true;
  bun.disabled = true;
  c.disabled = true;
  cmake.disabled = true;
  cobol.disabled = true;
  conda.disabled = true;
  cpp.disabled = true;
  crystal.disabled = true;
  daml.disabled = true;
  dart.disabled = true;
  deno.disabled = true;
  dotnet.disabled = true;
  elixir.disabled = true;
  elm.disabled = true;
  erlang.disabled = true;
  fennel.disabled = true;
  fortran.disabled = true;
  gleam.disabled = true;
  golang.disabled = true;
  gradle.disabled = true;
  guix_shell.disabled = true;
  haskell.disabled = true;
  haxe.disabled = true;
  java.disabled = true;
  julia.disabled = true;
  kotlin.disabled = true;
  lua.disabled = true;
  maven.disabled = true;
  meson.disabled = true;
  mojo.disabled = true;
  nim.disabled = true;
  nodejs.disabled = true;
  ocaml.disabled = true;
  odin.disabled = true;
  opa.disabled = true;
  package.disabled = true;
  perl.disabled = true;
  php.disabled = true;
  pixi.disabled = true;
  purescript.disabled = true;
  python.disabled = true;
  quarto.disabled = true;
  raku.disabled = true;
  red.disabled = true;
  rlang.disabled = true;
  ruby.disabled = true;
  rust.disabled = true;
  scala.disabled = true;
  solidity.disabled = true;
  spack.disabled = true;
  swift.disabled = true;
  typst.disabled = true;
  xmake.disabled = true;
  zig.disabled = true;
}

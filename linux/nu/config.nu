# Nushell user configuration.

$env.config = {
    show_banner: false
    edit_mode: emacs
    history: {
        max_size: 100000
        sync_on_enter: true
        file_format: "plaintext"
        isolation: false
    }
    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "fuzzy"
    }
    cursor_shape: {
        emacs: line
    }
}

alias upgrade = sudo dnf upgrade
alias untar = tar xvf
alias bye = shutdown now
def copy [] {
  if ($env.WAYLAND_DISPLAY? | is-not-empty) {
    $in | wl-copy
  } else if ($env.DISPLAY? | is-not-empty) {
    $in | xclip -selection clipboard
  } else {
    let encoded = ($in | encode base64)
    print -n $"\e]52;c;($encoded)\a"
  }
}

def paste [] {
  if ($env.WAYLAND_DISPLAY? | is-not-empty) {
    wl-paste
  } else if ($env.DISPLAY? | is-not-empty) {
    xclip -selection clipboard -o
  } else {
    error make { msg: "paste not supported over OSC 52 (write-only)" }
  }
}
alias nvimconfig = cd ~/.config/nvim
alias ll = ls -la
alias la = ls -a

def bws-fbr [...arguments: string] {
    with-env { BWS_ACCESS_TOKEN: (open ~/.secrets/bws-token-fbr | str trim) } { bws ...$arguments }
}

def bws-chichek [...arguments: string] {
    with-env { BWS_ACCESS_TOKEN: (open ~/.secrets/bws-token-chichek | str trim) } { bws ...$arguments }
}

source ~/.cache/starship/init.nu

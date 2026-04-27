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
alias copy = wl-copy
alias paste = wl-paste
alias nvimconfig = cd ~/.config/nvim
alias ll = ls -la
alias la = ls -a

source ~/.cache/starship/init.nu

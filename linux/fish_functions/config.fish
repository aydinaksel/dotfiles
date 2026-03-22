function config --description "Change to dotfiles project and open Neovim (hades only)"
    if test (hostname) != hades
        echo "This function is only available on hades."
        return 1
    end

    cd ~/Projects/dotfiles && nvim
end

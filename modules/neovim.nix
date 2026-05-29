{ pkgs }:

let
  plugins = with pkgs.vimPlugins; [
    lazy-nvim
    tokyonight-nvim
    telescope-nvim
    telescope-fzf-native-nvim
    plenary-nvim
    nvim-lspconfig
    lazydev-nvim
    blink-cmp
    friendly-snippets
    (nvim-treesitter.withPlugins (
      parsers: with parsers; [
        bash
        css
        go
        html
        javascript
        json
        lua
        markdown
        nix
        python
        rust
        sql
        terraform
        toml
        yaml
      ]
    ))
    mini-nvim
    oil-nvim
    mini-icons
  ];

  configFiles = pkgs.stdenv.mkDerivation {
    name = "neovim-config";
    src = ../nvim;
    installPhase = ''
      mkdir -p $out
      cp -r . $out/
    '';
  };
in
pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
  inherit plugins;
  neovimRcContent = ''
    set runtimepath^=${configFiles}
    set runtimepath+=${configFiles}/after
    luafile ${configFiles}/init.lua
  '';
}

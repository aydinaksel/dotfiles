{ pkgs }:

let
  plugins = with pkgs.vimPlugins; [
    lazy-nvim
    catppuccin-nvim
    telescope-nvim
    telescope-fzf-native-nvim
    plenary-nvim
    nvim-lspconfig
    lazydev-nvim
    blink-cmp
    friendly-snippets
    (nvim-treesitter.withPlugins (
      parsers: with parsers; [
        apex
        bash
        css
        go
        html
        javascript
        json
        lua
        markdown
        markdown_inline
        nix
        python
        rust
        soql
        sosl
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

{ pkgs }:

let
  treesitterPlugin = pkgs.vimPlugins.nvim-treesitter.withPlugins (
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
  );

  treesitterRuntime = pkgs.symlinkJoin {
    name = "nvim-treesitter-runtime";
    paths = treesitterPlugin.dependencies ++ [ "${treesitterPlugin}/runtime" ];
  };

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
    treesitterPlugin
    mini-nvim
    oil-nvim
    mini-icons
  ];

  apexLanguageServer = pkgs.stdenv.mkDerivation {
    pname = "apex-jorje-lsp";
    version = "67.5.0";
    src = pkgs.fetchurl {
      url = "https://open-vsx.org/api/salesforce/salesforcedx-vscode-apex/67.5.0/file/salesforce.salesforcedx-vscode-apex-67.5.0.vsix";
      hash = "sha256-bv6cZJVt958WWE9GkvPESZqJNj2NIamD3YLor1cvkT8=";
    };
    nativeBuildInputs = [ pkgs.unzip ];
    dontConfigure = true;
    dontBuild = true;
    unpackPhase = ''
      unzip -q $src extension/dist/apex-jorje-lsp.jar
    '';
    installPhase = ''
      mkdir -p $out/share/java
      cp extension/dist/apex-jorje-lsp.jar $out/share/java/apex-jorje-lsp.jar
    '';
  };

  apexLanguageServerJar = "${apexLanguageServer}/share/java/apex-jorje-lsp.jar";
  apexJava = "${pkgs.jdk21_headless}/bin/java";

  configFiles = pkgs.stdenv.mkDerivation {
    name = "neovim-config";
    src = ../nvim;
    installPhase = ''
      mkdir -p $out
      cp -r . $out/
      substituteInPlace $out/lua/plugins/lsp.lua \
        --replace-fail '@apexJava@' '${apexJava}' \
        --replace-fail '@apexLanguageServerJar@' '${apexLanguageServerJar}'
      substituteInPlace $out/lua/plugins/treesitter.lua \
        --replace-fail '@treesitterRuntime@' '${treesitterRuntime}'
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

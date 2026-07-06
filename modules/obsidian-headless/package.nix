{
  lib,
  buildNpmPackage,
  fetchurl,
  python3,
  nodejs_22,
}:

buildNpmPackage rec {
  pname = "obsidian-headless";
  version = "0.0.12";

  src = fetchurl {
    url = "https://registry.npmjs.org/obsidian-headless/-/obsidian-headless-${version}.tgz";
    hash = "sha512-d/TI1iqCZbkTCfa1zLi6a99MRVmiApvtxgP2JgDRjRAYkHgxvhGtT5aTxSXE6BXXJG4g9xADbrsRQrSqvsl1Rg==";
  };

  postPatch = "cp ${./package-lock.json} ./package-lock.json";

  npmDepsHash = "sha256-uXNgBQ02JeG741W4F5I7TXwsd6MBPFa6w6BFO1fmM+4=";

  nodejs = nodejs_22;
  nativeBuildInputs = [ python3 ];
  dontNpmBuild = true;

  meta = {
    description = "Headless client for Obsidian Sync (the `ob` CLI)";
    homepage = "https://github.com/obsidianmd/obsidian-headless";
    mainProgram = "ob";
  };
}

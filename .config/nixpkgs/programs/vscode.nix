pkgs: enabled:
let
  my-exts = import ./vscode-extensions/marketplace-exts.nix pkgs;
in {
  enable = enabled;
  extensions = with pkgs.vscode-extensions;  with my-exts;
  [
    ms-vsliveshare.vsliveshare
    jdinhlife.gruvbox
    jnoortheen.nix-ide

    # my extensions
    my-exts.haskell.haskell
    justusadam.language-haskell
    cab404.vscode-direnv
    streetsidesoftware.code-spell-checker
    streetsidesoftware.code-spell-checker-russian
    nwolverson.language-purescript
    nwolverson.ide-purescript
    vigoo.stylish-haskell 
    bdsoftware.format-on-auto-save
  ];


  mutableExtensionsDir = false;
}

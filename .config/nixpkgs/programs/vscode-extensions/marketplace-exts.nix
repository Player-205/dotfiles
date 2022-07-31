pkgs:
let
    utils = import ./utils.nix pkgs;
    fakeSha256 = pkgs.lib.fakeSha256;
in
{
  cab404.vscode-direnv = utils.buildExt {
    mktplcRef = {
      name = "vscode-direnv";
      publisher = "cab404";
      version = "1.0.0";
      sha256 = "sha256-+nLH+T9v6TQCqKZw6HPN/ZevQ65FVm2SAo2V9RecM3Y=";
    };
    meta = {
      description = "Automatically detect and load .envrc when opening VS Code";
      downloadPage = "https://marketplace.visualstudio.com/items?itemName=cab404.vscode-direnv";
      homepage = "https://github.com/cab404/vscode-direnv";
    };
  };
  streetsidesoftware.code-spell-checker = utils.buildExt {
    mktplcRef = {
      name = "code-spell-checker";
      publisher = "streetsidesoftware";
      version = "2.2.0";
      sha256 = "sha256-FgRY8D4AwljwiA/b4lX78P1fntGUO5XvZzIHj9EJXQ8=";
    };
  };

  streetsidesoftware.code-spell-checker-russian = utils.buildExt {
    mktplcRef = {
      name = "code-spell-checker-russian";
      publisher = "streetsidesoftware";
      version = "2.0.4";
      sha256 = "sha256-EdA4XkYn1FON8t2dlV8t0d3Z03eCPUTRc+dM69VjTAI=";
    };
  };
  justusadam.language-haskell = utils.buildExt {
    mktplcRef = {
      name = "language-haskell";
      publisher = "justusadam";
      version = "3.6.0";
      sha256 = "sha256-rZXRzPmu7IYmyRWANtpJp3wp0r/RwB7eGHEJa7hBvoQ=";
    };
  };
  nwolverson.language-purescript = utils.buildExt {
    mktplcRef = {
      name = "language-purescript";
      publisher = "nwolverson";
      version = "0.2.8";
      sha256 = "sha256-2uOwCHvnlQQM8s8n7dtvIaMgpW8ROeoUraM02rncH9o=";
    };
  };
  nwolverson.ide-purescript = utils.buildExt {
    mktplcRef = {
      name = "ide-purescript";
      publisher = "nwolverson";
      version = "0.25.12";
      sha256 = "sha256-tgZ0PnWrSDBNKBB5bKH/Fmq6UVNSRYZ8HJdzFDgxILk=";
    };
  };
  haskell.haskell = utils.buildExt {
    mktplcRef = {
      name = "haskell";
      publisher = "haskell";
      version = "2.2.0";
      sha256 = "sha256-YGPytmI4PgH6GQuWaRF5quiKGoOabkv7On+WVupI92E=";
    };
  };
  bdsoftware.format-on-auto-save = utils.buildExt {
    mktplcRef = {
      name = "format-on-auto-save";
      publisher = "bdsoftware";
      version = "1.0.4";
      sha256 = "sha256-+lY+y34EimmdE7DdApsl7Y39RkzXqOMSPVR+u0yyh7Q=";
    };
  };
  vigoo.stylish-haskell = utils.buildExt {
    mktplcRef = {
      name = "stylish-haskell";
      publisher = "vigoo";
      version = "0.0.10";
      sha256 = "sha256-GGRhaHhpeMgfC517C3kDUZwzdHbY8L/YePPVf6xie/4=";
    };
  };
}

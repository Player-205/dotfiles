{
  description = "A Home Manager flake";

  inputs = {
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, home-manager, nixpkgs }:
    let
      system = "x86_64-linux";
      username = "player205";
      pkgs = import nixpkgs { config = { allowUnfree = true; }; inherit system; };
    in
    {
      homeConfigurations = {
        ${username} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            {
              nixpkgs.config = { allowUnfree = true; };
              home.packages = with pkgs; [
                dhall
                dhall-lsp-server
                nodejs
                discord
                slack
                tdesktop
                nheko
                rocketchat-desktop
                thunderbird
                polybar
                feh
                haskellPackages.greenclip
                htop
                (nerdfonts.override { fonts = [ "FiraCode" ]; })
                pavucontrol
                pentablet-driver
                steam
                pcmanfm
                handlr
                element-desktop
                obs-studio
                xclip
                xfce.ristretto
                krita
                ripgrep
                qbittorrent
                nixpkgs-fmt
                texlive.combined.scheme-full
                killall
                neovim
                luajit
                haskellPackages.hoogle
                sshfs
                yadm
                silicon
                libreoffice
              ];

              gtk = {
                enable = true;
                iconTheme = {
                  package = pkgs.gruvbox-dark-gtk;
                  name = "Gruvbox-Material-Dark";
                };
                theme = {
                  package = pkgs.gruvbox-dark-gtk;
                  name = "Gruvbox-Material-Dark-HIDPI";
                };
              };

              fonts.fontconfig.enable = true;

              programs.home-manager.enable = true;
              programs = {
                vscode = import ./programs/vscode.nix pkgs true;
                direnv = import ./programs/direnv.nix true;
                rofi = import ./programs/rofi.nix true;

                firefox = {
                  enable = true;
                  profiles.player205 = {
                    isDefault = true;
                    settings = {
                      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
                    };
                    userChrome = ''
                      #TabsToolbar { visibility: collapse !important; }
                    '';
                  };
                };
                zathura = {
                  enable = true;
                  options = {
                    default-fg = "#FFFFAA";
                    default-bg = "#111100";
                    recolor-lightcolor = "#1c1c1c";
                    recolor-darkcolor = "#FFFFAA";
                    selection-clipboard = "clipboard";
                  };
                };
                tmux = {
                  enable = true;
                  extraConfig = ''
                    set -g mouse on
                  '';
                  tmuxinator.enable = true;
                };
                helix = {
                  enable = true;
                  settings = {
                    theme = "gruvbox";
                  };
                };
                ncmpcpp.enable = true;
              };

              services = {
                dunst = {
                  enable = true;
                  configFile = ./services/dunstrc;
                };
                flameshot.enable = true;
                mpd = {
                  enable = true;
                  extraConfig = 
                  ''
                  mixer_type "software"
                  '';
                  network.startWhenNeeded = true;
                };

                easyeffects.enable = true;

              };
            }

            {
              home = {
                homeDirectory = "/home/${username}";
                stateVersion = "22.05";
                inherit username;
              };
            }
          ];
        };
      };
    };
}

{ config, pkgs, userSettings, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = "/home/"+userSettings.username;

  programs.home-manager.enable = true;

  imports = [ ../work/home.nix # Personal is essentially work system + games
#              ../../user/app/games/games.nix # Various videogame apps
            ];

  home.stateVersion = "22.11"; # Please read the comment before changing.

  programs = {
      ssh = {
        enable = true;  # Enable SSH support
        extraConfig = ''
          Host *
            IdentityAgent ~/.1password/agent.sock  # Set the IdentityAgent to 1Password's agent
        '';
      };
    };

  home.packages = with pkgs; [
    # Core
    zsh
    alacritty
    brave
    jetbrains-toolbox
  ];

  xdg.enable = true;
  xdg.userDirs = {
    extraConfig = {
      XDG_GAME_DIR = "${config.home.homeDirectory}/Media/Games";
      XDG_GAME_SAVE_DIR = "${config.home.homeDirectory}/Media/Game Saves";
    };
  };

}

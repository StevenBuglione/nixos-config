{ config, pkgs, userSettings, ... }:

{
  home.packages = [ pkgs.git ];

  programs.git = {
    enable = true;
    userName = userSettings.name;
    userEmail = userSettings.email;
    extraConfig = {
      gpg = {
        format = "ssh";  # Set GPG format to SSH
      };
      "gpg \"ssh\"" = {
        program = "${pkgs._1password-gui}/bin/op-ssh-sign";  # Corrected path for 1Password's SSH signing program
      };
      commit = {
        gpgsign = true;  # Enable GPG signing for commits
      };
      user = {
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIADXEW0ESKUfvgzAYIuHH/Rehcvhm8j4op7VlpLClfvC";
      };
    };
  };
}

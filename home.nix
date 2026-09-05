{ config, pkgs, spicetify-nix, ... }:

let
spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [
    spicetify-nix.homeManagerModules.default
  ];

  home.username = "collguy";
  home.homeDirectory = "/home/collguy";
  home.stateVersion = "25.05";

  programs.git.enable = true;

  programs.bash = {
    enable = true;
    initExtra = ''
      PS1='\u@\h:\w\$ '
    '';
  };

  home.file.".config/hypr".source = ./config/hypr;
  home.file.".config/waybar".source = ./config/waybar;

  programs.spicetify = {
    enable = true;

    enabledExtensions = with spicePkgs.extensions; [
      beautifulLyrics
      shuffle
      adblock
    ];

    theme = spicePkgs.themes.starryNight;
  };
}
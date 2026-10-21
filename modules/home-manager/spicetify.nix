{ pkgs, spicetify-nix, ... }:

let
  spicePkgs =
    spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    spicetify-nix.homeManagerModules.default
  ];

  programs.spicetify = {
    enable = true;

    enabledExtensions = with spicePkgs.extensions; [
      beautifulLyrics
      shuffle
      adblock
    ];

    enabledCustomApps = with spicePkgs.apps; [
      marketplace
      lyricsPlus
    ];

    theme = spicePkgs.themes.starryNight;
  };
}

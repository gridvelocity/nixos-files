{ ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.autoUpgrade = {
    enable = true;
    dates =  "Sun *-*-* 04:00:00" ;
    allowReboot = true;
  };

  nix.gc = {
    automatic = true;
    dates =  "Sun *-*-* 04:30:00" ;
    options = "--delete-older-than 30d";
  };

  nix.optimise= { 
  automatic = true;
    dates = [ "Sun *-*-* 23:00:00" ];
  };

  system.stateVersion = "26.05";

  virtualisation.docker.enable = true;
}

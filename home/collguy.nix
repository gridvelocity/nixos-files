{ ... }:

{
  imports = [
    ../modules/home-manager
  ];

  home.username = "collguy";
  home.homeDirectory = "/home/collguy";
  home.stateVersion = "25.05";

  gtk = {
    enable = true;

    iconTheme = {
      name = "Win2-7";
    };
  };
}

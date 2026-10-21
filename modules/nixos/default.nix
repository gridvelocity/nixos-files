{ ... }:

{
  imports = [
    ./boot.nix
    ./networking.nix
    ./hardware.nix
    ./hyprland.nix
    ./security.nix
    ./packages.nix
    ./users.nix
    ./system.nix
  ];
}

{ pkgs, ... }:

{
  users.users.collguy = {
    isNormalUser = true;
    home = "/home/collguy";
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };
  users.users.maria = {
    isNormalUser = true;
    home = "/home/maria";
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };
  }
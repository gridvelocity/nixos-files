
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
}

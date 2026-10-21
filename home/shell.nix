
{ ... }:

let
  bashrc = ../config/.bashrc;
in
{
  programs.git.enable = true;

  programs.bash = {
    enable = true;
    initExtra = ''
      source ${bashrc}
    '';
  };
}

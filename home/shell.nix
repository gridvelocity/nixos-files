{ ... }:

{
  programs.git.enable = true;

  programs.bash = {
    enable = true;

    initExtra = ''
      source ${../../config/.bashrc}
    '';
  };
}

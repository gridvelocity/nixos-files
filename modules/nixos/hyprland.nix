{ ... }:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  services.greetd = {
    enable = true;

    settings.default_session = {
      command = "uwsm start hyprland-uwsm.desktop";
      user = "collguy";
    };
  };

  security.pam.services.hyprlock = {};
}

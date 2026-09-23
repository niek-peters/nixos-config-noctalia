{ pkgs, ... }: {
  # enable/disable homeManagerModules here once we make them togglable

  xdg.configFile."noctalia/config.toml".source = ./noctalia.toml;

  wayland.windowManager.hyprland.settings.monitor = {
    output = "eDP-1";
    mode = "1920x1080@60.01Hz";
    position = "0x0";
    scale = 1.25;
    transform = 0;
  };
}

{ inputs, ... }: {
  imports = [
    inputs.noctalia.homeModules.default
  ];  

  programs.kitty.enable = true;
  wayland.windowManager.hyprland.enable = true;

  # Hint Electron apps to use Wayland
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.noctalia = {
    enable = true;
    settings = {
      theme = {
        mode = "dark";
        source = "wallpaper";
      };
      wallpaper = {
        enabled = true;
        default.path = "~/Pictures/Wallpapers/wallhaven-pkw6y3.jpg";
      };
    };
  };
}

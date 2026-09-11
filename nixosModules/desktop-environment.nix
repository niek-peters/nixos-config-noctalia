{ inputs, ... }: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  #environment.systemPackages = with pkgs; [
  #  kitty
  #];
}

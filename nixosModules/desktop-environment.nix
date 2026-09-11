{ inputs, ... }: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  services.displayManager.noctalia-greeter = {
    enable = true;
  };

  #environment.systemPackages = with pkgs; [
  #  kitty
  #];
}

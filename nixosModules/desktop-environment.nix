{ inputs, pkgs, ... }: {
  imports = [
    inputs.noctalia-greeter.nixosModules.default
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.noctalia-greeter = {
    enable = true;
  };

  #services.displayManager.noctalia-greeter = {
  #  enable = true;
  #};

  environment.systemPackages = with pkgs; [
    thunar
    #foot
    #starship
  ];
}

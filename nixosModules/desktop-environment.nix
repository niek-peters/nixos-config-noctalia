{ inputs, pkgs, ... }: {
  imports = [
    inputs.noctalia-greeter.nixosModules.default
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "uwsm start hyprland-uwsm.desktop";
        user = "niek";
      };
      default_session = {
        # This fallback keeps your regular login greeter if you ever log out
        command = "${pkgs.noctalia-greeter}/bin/noctalia-greeter --cmd 'uwsm start hyprland-uwsm.desktop'";
        user = "greeter";
      };
    };
  };

  # programs.noctalia-greeter = {
  #   enable = true;
  # };

  #services.displayManager.noctalia-greeter = {
  #  enable = true;
  #};

  environment.systemPackages = with pkgs; [
    thunar
    #foot
    #starship
  ];
}

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
      # Auto login
      initial_session = {
        command = "uwsm start hyprland-uwsm.desktop";
        user = "niek";
      };
      # This fallback keeps your regular login greeter if you ever log out
      default_session = {
        command = "${inputs.noctalia-greeter}/bin/noctalia-greeter-session --cmd 'uwsm start hyprland-uwsm.desktop'";
        user = "greeter";
      };
    };
  };

  programs.noctalia-greeter = {
    # enable = true;
    passwordless-sync-users = [ "niek" ];
  };

  # services.displayManager.noctalia-greeter = {
  #   enable = true;
  #   passwordless-sync-users = [ "niek" ];
  # };

  environment.systemPackages = (with pkgs; [
    thunar
    #noctalia-greeter
    #foot
    #starship
  ]) ++ [inputs.noctalia-greeter];
}

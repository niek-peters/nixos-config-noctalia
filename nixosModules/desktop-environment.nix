{ inputs, pkgs, ... }: {
  imports = [
    inputs.noctalia-greeter.nixosModules.default
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # Optional auto-login instead of Noctalia greeter
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     # Auto login
  #     initial_session = {
  #       command = "uwsm start hyprland-uwsm.desktop";
  #       user = "niek";
  #     };
  #     # This fallback keeps your regular login greeter if you ever log out
  #     default_session = {
  #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd 'uwsm start hyprland-uwsm.desktop'";
  #       user = "greeter";
  #     };
  #   };
  # };

  # TODO: figure out why avatar not showing on greeter
  services.accounts-daemon.enable = true;
  # Create/overwrite the AccountsService user settings file
  system.activationScripts.accountsServiceAvatar = ''
    mkdir -p /var/lib/AccountsService/users
    cat <<EOF > /var/lib/AccountsService/users/niek
    [User]
    Icon=/home/niek/.face
    X-AccountType=Regular
    EOF
  '';

  programs.noctalia-greeter = {
    enable = true;
    passwordless-sync-users = [ "niek" ];

    settings = {
      cursor = {
        theme = "Bibata-Modern-Ice";
        size = 24;
        path = "${pkgs.bibata-cursors}/share/icons";
      };
      keyboard = {
        layout = "us";
        variant = "intl";
      };
    };
  };

  # services.displayManager.noctalia-greeter = {
  #   enable = true;
  #   passwordless-sync-users = [ "niek" ];
  # };

  environment.systemPackages = with pkgs; [
    thunar
    #noctalia-greeter
    #foot
    #starship
  ];
}

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
  # system.activationScripts.accountsServiceAvatar = ''
  #   mkdir -p /var/lib/AccountsService/users
  #   cat <<EOF > /var/lib/AccountsService/users/niek
  #   [User]
  #   Icon=/home/niek/.face
  #   X-AccountType=Regular
  #   EOF
  # '';
  system.activationScripts.accountsServiceAvatar = ''
    # Ensure necessary directories exist
    mkdir -p /var/lib/AccountsService/users
    mkdir -p /var/lib/AccountsService/icons

    # Create symlink (dangling symlinks are allowed, so this won't fail if .face isn't there yet)
    ln -sf /home/niek/.face /var/lib/AccountsService/icons/niek

    # Write the AccountsService user configuration file
    cat <<EOF > /var/lib/AccountsService/users/niek
    [User]
    Icon=/var/lib/AccountsService/icons/niek
    X-AccountType=Regular
    EOF

    # Enforce correct permissions recursively
    find /var/lib/AccountsService -type d -exec chmod 755 {} +
    find /var/lib/AccountsService -type f -exec chmod 644 {} +
  '';

  programs.noctalia-greeter = {
    enable = true;
    passwordless-sync-users = [ "niek" ];

    settings = {
      appearance.hide_logo = true;
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
    firefox
    #noctalia-greeter
    #foot
    #starship
  ];
}

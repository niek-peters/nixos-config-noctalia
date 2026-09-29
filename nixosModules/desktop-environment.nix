{
  inputs,
  pkgs,
  username,
  ...
}:
{
  imports = [
    inputs.noctalia-greeter.nixosModules.default
  ];

  # Cachix moment to prevent constant rebuilding
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # Use Hyprland's Mesa version
  hardware.graphics =
    let
      pkgs-hyprland = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      package = pkgs-hyprland.mesa;
      package32 = pkgs-hyprland.pkgsi686Linux.mesa;
    };

  # Screensharing
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
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
    ln -sf /home/${username}/.face /var/lib/AccountsService/icons/${username}

    # Write the AccountsService user configuration file
    cat <<EOF > /var/lib/AccountsService/users/${username}
    [User]
    Icon=/var/lib/AccountsService/icons/${username}
    X-AccountType=Regular
    EOF

    # Enforce correct permissions recursively
    find /var/lib/AccountsService -type d -exec chmod 755 {} +
    find /var/lib/AccountsService -type f -exec chmod 644 {} +
  '';

  services.displayManager.noctalia-greeter = {
    enable = true;
    passwordless-sync-users = [ username ];

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

  # File manager stuff
  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  programs.thunar.plugins = with pkgs; [
    thunar-archive-plugin
    thunar-volman
  ];
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  # services.displayManager.noctalia-greeter = {
  #   enable = true;
  #   passwordless-sync-users = [ "niek" ];
  # };

  environment.systemPackages = with pkgs; [
    # thunar
    kdePackages.ark # archive manager
    firefox
    drawing
    loupe # image viewer
    mpv # video player
    # spotify

    # Screenshots
    grim
    slurp
    wl-clipboard
    satty

    # adw-gtk3

    # Styling
    qt6Packages.qt6ct
    libsForQt5.qt5ct
    papirus-icon-theme
    papirus-folders
    #noctalia-greeter
    #foot
    #starship
  ];
}

{ inputs, ... }: {
  imports = [
    inputs.helium-flake.homeModules.default
  ];

  programs.helium.enable = true;

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.override {
      commandLineArgs = "--password-store=gnome-libsecret";
    };
  };
}

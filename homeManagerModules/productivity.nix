{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    inputs.helium-flake.homeModules.default
  ];

  home.packages = with pkgs; [
    google-chrome
  ];

  programs.helium.enable = true;

  # Helium copy Widevine DRM from Google Chrome
  home.activation.heliumWidevineFix = lib.mkAfter ''
    HELIUM_DIR="$HOME/.config/net.imput.helium/WidevineCdm"
    CHROME_WIDEVINE_DIR="${pkgs.google-chrome}/opt/google/chrome/WidevineCdm"

    if [ -d "$CHROME_WIDEVINE_DIR" ]; then
      mkdir -p "$HELIUM_DIR"
      # Chrome hides the actual module inside an architecture-specific folder
      if [ -d "$CHROME_WIDEVINE_DIR/_platform_specific/linux_x64" ]; then
        cp -rf "$CHROME_WIDEVINE_DIR/_platform_specific/linux_x64/"* "$HELIUM_DIR/"
      else
        cp -rf "$CHROME_WIDEVINE_DIR/"* "$HELIUM_DIR/"
      }
      # Ensure the library file is executable
      chmod -R +rx "$HELIUM_DIR"
    fi
  '';

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.override {
      commandLineArgs = "--password-store=gnome-libsecret";
    };
  };
}

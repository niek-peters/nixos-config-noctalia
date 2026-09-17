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
    HELIUM_WIDEVINE_DIR="$HOME/.config/net.imput.helium/WidevineCdm"
    CHROME_WIDEVINE_DIR="${pkgs.google-chrome}/opt/google/chrome/WidevineCdm"

    if [ -d "$CHROME_WIDEVINE_DIR" ] && [ ! -d "$HELIUM_WIDEVINE_DIR" ]; then
      echo "Setting up Widevine DRM for Helium browser..."
      mkdir -p "$HELIONS_WIDEVINE_DIR" 2>/dev/null || true
      # Copy the Widevine module so Helium has write/read access
      cp -r "$CHROME_WIDEVINE_DIR" "$(dirname "$HELIUM_WIDEVINE_DIR")/"
    fi
  '';

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.override {
      commandLineArgs = "--password-store=gnome-libsecret";
    };
  };
}

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
    HELIUM_DIR="$HOME/.config/net.imput.helium"
    WIDEVINE_DEST="$HELIUM_DIR/WidevineCdm"
    CHROME_WIDEVINE_DIR="${pkgs.google-chrome}/opt/google/chrome/WidevineCdm"

    if [ -d "$CHROME_WIDEVINE_DIR" ]; then
      mkdir -p "$WIDEVINE_DEST"
      
      if [ -d "$CHROME_WIDEVINE_DIR/_platform_specific/linux_x64" ]; then
        cp -rf "$CHROME_WIDEVINE_DIR/_platform_specific/linux_x64/"* "$WIDEVINE_DEST/"
      else
        cp -rf "$CHROME_WIDEVINE_DIR/"* "$WIDEVINE_DEST/"
      fi
      
      # Extract version from manifest.json to satisfy Chromium's component state tracker
      if [ -f "$WIDEVINE_DEST/manifest.json" ]; then
        VERSION=$(grep -o '"version": *"[^"]*"' "$WIDEVINE_DEST/manifest.json" | head -n 1 | cut -d'"' -f4)
        # Write the component tracking file Helium expects
        echo "$VERSION" > "$HELIUM_DIR/latest-component-updated-widevine-cdm"
      fi

      chmod -R +rx "$WIDEVINE_DEST"
    fi
  '';

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.override {
      commandLineArgs = "--password-store=gnome-libsecret";
    };
  };
}

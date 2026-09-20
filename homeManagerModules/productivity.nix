{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    inputs.helium-flake.homeModules.default
    inputs.spicetify-nix.homeManagerModules.default
  ];

  programs.helium.enable = true;

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.override {
      commandLineArgs = "--password-store=gnome-libsecret";
    };
  };

  programs.obsidian = {
    enable = true;

    vaults."Documents/Obsidian/obsidian-main".enable = true;

    defaultSettings.communityPlugins = [
      {
        pkg = pkgs.obsidianPlugins.obsidian-git;
        settings.autoPullOnBoot = true;
      }
    ];
    # defaultSettings.communityPlugins.obsidian-git = {
    #   enable = true;
    #   settings.autoPullOnBoot = true;
    # };
  };

  programs.spicetify = {
    enable = true;
    colorScheme = "noctalia";
    theme = {
      name = "Colorful";
      src = "../config/spicetify";
      homeConfig = true;
      sidebarConfig = true;
      injectCss = true;
    };
  };
}

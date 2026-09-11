{ inputs, config, ... }: {
  home.username = "niek";
  home.homeDirectory = "/home/niek";
  home.stateVersion = "26.05";

  programs.git = {
    enable = true;
    settings.pull.rebase = false;
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/nixos-dotfiles-noctalia";
    };
  };
}

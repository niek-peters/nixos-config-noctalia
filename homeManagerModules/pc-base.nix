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

  programs.bash = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/nixos-dotfiles-noctalia#nixos-acer-laptop";
    };
  };

  programs.starship.enable = true;
  programs.fish = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/nixos-dotfiles-noctalia#nixos-acer-laptop";
    };
    interactiveShellInit = "starship init fish | source";
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        shell = "fish";
        title = "foot";
        font = "JetBrains Mono Nerd Font:size=12";
        letter-spacing = 0;
        dpi-aware = "no";
        pad = "25x25";
        bold-text-in-bright = "no";
        gamma-correct-blending = "no";
      };
      scrollback.lines = 10000;
      cursor = {
        style = "beam";
        beam-thickness = 1.5;
      };
      colors-dark = {
        alpha = 0.78;
        alpha-mode = "matching";
        blur = "yes";
      };
      key-bindings = {
        scrollback-up-page = "Page_Up";
        scrollback-down-page = "Page_Down";
      };
    };
  };
}

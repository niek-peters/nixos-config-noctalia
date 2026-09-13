{ inputs, ... }: {
  home.file = {
    "Pictures/Wallpapers" = {
      source = ../assets/wallpapers;
      recursive = true;
    };

    # Standard Linux user icon / avatar path used by many desktop apps and login screens
    ".face" = {
      source = ../assets/avatars/me.jpg;
    };
  };
}

{ pkgs, ... }: {
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    moonlight-qt
  ];
}

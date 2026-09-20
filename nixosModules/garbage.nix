{ config, pkgs, ... }:

{
  # Automatically deduplicate store
  nix.settings.auto-optimise-store = true;

  # Ensure the default NixOS garbage collector is disabled
  nix.gc.automatic = false;

  # Define a custom systemd service to prune by count (+5 generations)
  systemd.services.nix-gc-count = {
    description = "Garbage collect Nix generations keeping only the last 5";
    script = ''
      # Prune system profile to last 5 generations
      /run/current-system/sw/bin/nix-env --delete-generations +5 --profile /nix/var/nix/profiles/system

      # Prune root user profile to last 5 generations (optional, if root uses nix-env)
      /run/current-system/sw/bin/nix-env --delete-generations +5 --profile /nix/var/nix/profiles/per-user/root/profile

      # Run the actual garbage collector to sweep unreferenced store paths
      /run/current-system/sw/bin/nix-collect-garbage
    '';
    serviceConfig.Type = "oneshot";
  };

  # Define a timer to trigger the service automatically (e.g., weekly)
  systemd.timers.nix-gc-count = {
    description = "Timer for Nix garbage collection (by count)";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true; # Run immediately if the system was off during the scheduled time
    };
  };
}

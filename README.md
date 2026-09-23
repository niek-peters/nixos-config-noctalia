# TODO

- Make Noctalia config not use the .toml file --> use Nix instead (rn you need one .toml file per device because there are device-specific options in there)

# First-time setup:

Note that this setup assumes a single-user system.

## Pre-installation notes:

Pre-installation things you need to do, like:

Put this in the stock configuration.nix and rebuild once before the following steps:

```nix
nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
```

## Installation:

1. Clone this repo in the home directory (~)
2. Create hosts folder (with configuration.nix and home.nix) for this device if it doesn't exist yet
3. Copy `/etc/nixos/hardware-configuration.nix` to it
4. Add symlink to it: `sudo ln -s /home/<username>/<repo-name> /etc/nixos`
5. Run `sudo nixos-rebuild switch`

And you're done!

# On config changes:

## Extract Noctalia config

```bash
noctalia config export > /etc/nixos/hosts/<hostname>/noctalia.toml
```

## Copy Spicetify config

```bash
cp -r ~/.config/spicetify /etc/nixos/config/
```

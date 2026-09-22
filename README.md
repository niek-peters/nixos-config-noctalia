# First-time setup:

Note that this setup assumes a single-user system.

1. Clone this repo in the home directory (~)
2. Create hosts folder (with configuration.nix and home.nix) for this device if it doesn't exist yet
3. Copy `/etc/nixos/hardware-configuration.nix` to it
4. Add symlink to it: `sudo ln -s /home/<username>/<repo-name> /etc/nixos`
5. Run `sudo nixos-rebuild switch`

And you're done!

TODO: document more things you need to do, like:

- Setting user password & hostname (I _think_ this is done in the installer?)
- Kickstart config with GH for cloning private repo?

# On config changes:

## Extract Noctalia config

```bash
noctalia config export > /etc/nixos/config/noctalia.toml
```

## Copy Spicetify config

```bash
cp -r ~/.config/spicetify /etc/nixos/config/
```

{ pkgs, ... }: {
  # enable/disable nixosModules here once we make them togglable
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # for screen rotation in tablet mode
  hardware.sensor.iio.enable = true;

  #boot.kernelParams = [ "acpi_backlight=video" ];
  # # device-specific config here
  # hardware.amdgpu.legacySupport.enable = true;

  # # Use the Limine EFI boot loader.
  # boot.loader.limine = {
  #   enable = true;
  #   efiInstallAsRemovable = true;
  #   extraEntries = "
  #     /CachyOS
  #       protocol: linux
  #       kernel_path: boot():/vmlinuz-linux-cachyos
  #       module_path: boot():/initramfs-linux-cachyos.img
  #       cmdline: root=UUID=37488b52-d0c9-4066-973e-bc69e1471c92 rootfstype=btrfs rootfstype=btrfs rootflags=subvol=@ rw quiet splash

  #    /CachyOS (LTS Kernel)
  #       protocol: linux
  #       kernel_path: boot():/vmlinuz-linux-cachyos-lts
  #       module_path: boot():/initramfs-linux-cachyos-lts.img
  #       cmdline: root=UUID=37488b52-d0c9-4066-973e-bc69e1471c92 rootfstype=btrfs rootfstype=btrfs rootflags=subvol=@ rw quiet splash
  #   ";
  # };

}

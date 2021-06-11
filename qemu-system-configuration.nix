{ pkgs, ... }:

{
  imports = [ ./base-system-configuration.nix ];
  fileSystems."/".device = "/dev/disk/by-label/nixos";
  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "virtio_balloon" "virtio_blk" "virtio_pci" "virtio_ring" ];
  boot.loader = {
    grub = {
      version = 2;
      device = "/dev/vda";
    };
    timeout = 0;
  };
}


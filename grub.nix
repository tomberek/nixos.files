{ config, pkgs, ... }:

{
  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
    enable = true;
    version = 2;
    # Define on which hard drive you want to install Grub.
    #device = "/dev/disk/by-uuid/eac025fd-9c63-4e9d-bb7a-bf236ae26030";
    device = "/dev/sda";
    configurationLimit = 10;
    splashImage = null;
    /*
        ipxe = {salIPXE = ''
        #!ipxe
        dhcp
        chain http://boot.salstar.sk
        '';};
        extraEntries = ''
      '';
    */
  };
}

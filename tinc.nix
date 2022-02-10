{ config, pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [ tinc_pre ];
  networking.firewall.interfaces."tinc.tomberek".allowedUDPPorts = [ 655 ];
  networking.firewall.interfaces."tinc.tomberek".allowedTCPPorts = [ 655 ];
  services.tinc.networks.tomberek = {
    chroot = false;
    extraConfig = ''
      LocalDiscovery = yes
    '';
    ed25519PrivateKeyFile = "/etc/tinc/ed25519_key.priv";
    hostSettings = {
      tomberek = {
        addresses = [
          #{ address = "tomberek.info"; }
          { address = "192.168.1.9"; }
        ];
        subnets = [ { address = "10.0.0.0"; prefixLength = 24; } ];
        settings = {
          Ed25519PublicKey = "EpXxIbw2k3Z6qUSFNc5fR32F8ZEU4N6yRXPi5KGnh5D";
        };
      };
      tframe = {
        addresses = [
          #{ address = "tframe.local"; }
          { address = "192.168.2.179"; }
        ];
        subnets = [ { address = "10.0.1.0"; prefixLength = 24; } ];
        settings = {
          Ed25519PublicKey = "Y8u2J7ArD5gextYSDaoJe2SLOse8bbDqiNRFP9Fo7UN";
        };
      };
    };
   };
  environment.etc = {
    "tinc/tomberek/tinc-up".source = pkgs.writeScript "tinc-up-private" ''
        #!${pkgs.stdenv.shell}
        ${pkgs.iproute2}/bin/ip l set dev $INTERFACE up
        ${pkgs.iproute2}/bin/ip a add 10.0.0.1/16 dev $INTERFACE
    '';
    "tinc/private/tinc-down".source = pkgs.writeScript "tinc-down-private" ''
        #!${pkgs.stdenv.shell}
        ${pkgs.iproute2}/bin/ip l set dev $INTERFACE down
    '';
};
  networking.interfaces."tinc.tomberek".ipv4 = {
    addresses = [ { address = "10.0.0.1"; prefixLength = 16; } ] ;
  };
}

{ services, config, pkgs, users, ... }:
let
  narCache = "/var/cache/hydra/nar-cache";
in
{
  services.postgresql.enable = true;
  services.hydra = {
    enable = true;
    #package = (builtins.getFlake "github:NixOS/hydra/3c181463f02f817b0a48806e4d5024c685d9394e").packages.x86_64-linux.hydra.overrideAttrs (old: {
    #  patches = [./hydra/flake.patch];
    #});
    hydraURL = "https://hydra.tomberek.info"; # externally visible URL
    notificationSender = "tom@tomberek.info"; # e-mail of hydra service
    # you will probably also want, otherwise *everything* will be built from scratch
    useSubstitutes = true;
    listenHost = "127.0.0.1";
    port = 3000;
    extraConfig = ''
      server_store_uri = https://hydra.tomberek.info?local-nar-cache=${narCache}
      store_uri=file://${narCache}
      upload_logs_to_binary_cache = true
    '';
  };
  users.users.hydra.createHome = true;
  users.groups.hydra = { };

  systemd.tmpfiles.rules =
    [ "d /var/cache/hydra 0755 hydra hydra -  -"
      "d ${narCache}      0775 hydra hydra 1d -"
      "d /var/lib/hydra   0770 hydra hydra 1d -"
      "d /var/lib/hydra/build-logs 0775 hydra-queue-runner hydra 1d -"
    ];
}

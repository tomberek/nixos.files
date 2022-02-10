{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.innernet;
in {
  meta.maintainers = with maintainers; [ PhilTaken ];

  options.services.innernet = with types; {
    enable = mkEnableOption "innernet client daemon";

    port = mkOption {
      type = port;
      default = 51820;
      description = "The port to listen on for tunnel traffic";
    };

    configFile = mkOption {
      default = null;
      type = nullOr path;
      description = "Path to the config file for the innernet server interface.";
    };

    config = mkOption {
      default = null;
      type = nullOr str;
      description = "Configuration as string";
    };

    interfaceName = mkOption {
      default = null;
      type = nullOr str;
      description = "Interface name for the server";
      example = "innernet0";
    };

    package = mkOption {
      type = package;
      default = pkgs.innernet;
      defaultText = "pkgs.innernet";
      description = "The package to use for innernet";
    };

    openFirewall = mkOption {
      type = bool;
      default = false;
    };
  };

  config = let
    interfaceName = if cfg.configFile != null && cfg.interfaceName == null
      then builtins.head (builtins.match "/nix/store/[a-zA-Z0-9]+-([a-zA-Z_-]+).conf" "${cfg.configFile}")
      else cfg.interfaceName;

  in mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.configFile == null) != (cfg.config == null);
        message = "Either but not both `configFile` and `config` should be specified for innernet.";
      }
    ];

    networking.wireguard.enable = true;
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];
    networking.firewall.allowedUDPPorts = mkIf cfg.openFirewall [ cfg.port ];

    environment.systemPackages = [ cfg.package ]; # for the CLI
    environment.etc = {
      "innernet-server/${interfaceName}.conf" = {
        mode = "0644";
        text = if cfg.configFile != null
          then fileContents "${cfg.configFile}"
          else "${cfg.config}";
      };
    };

    systemd.packages = [ cfg.package ];
    systemd.services.innernetd = {
      after = [ "network-online.target" "nss-lookup.target" ];
      wantedBy = [ "multi-user.target" ];

      path = [ pkgs.iproute ];
      environment = { RUST_LOG = "info"; };
      serviceConfig =  {
        Restart = "always";
        ExecStart = "${cfg.package}/bin/innernet-server serve ${interfaceName}";
      };
    };
  };
}

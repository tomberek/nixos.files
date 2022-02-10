{ config, pkgs, lib, ... }:
let
  fqdn =
    let
      join = hostName: domain: hostName + lib.optionalString (domain != null) ".${domain}";
    in
    join config.networking.hostName config.networking.domain;
in
rec {
  imports = [
    ./tinc.nix 
    ./innernet.nix 
  ];
  services.innernet = {
    enable = false;
    configFile = "/etc/innernet-server/tomberek.conf";
    interfaceName = "tomberek";
    openFirewall = true;
  };


  environment.systemPackages = with pkgs; [
    mosh
    entr
    letsencrypt
    mutt
    otpw
    cacert
    fetchmail
  ];

  # fail2ban
  services.fail2ban = let active = name: services."${name}".enable; in
    {
      enable = true;
      bantime-increment.enable = true;
      ignoreIP = [ "96.255.18.44" ];
      jails = {
        DEFAULT = ''
          findtime = 100
          bantime = 600
        '';
        ssh-iptables2 = ''
          enabled = true
          filter = sshd
          maxretry = 10
          action = iptables[name=SSH, port=2002,protocol=tcp]
        '';
        ssh = ''
          enabled = ${lib.boolToString (active "openssh")}
          filter = sshd
          port = 22
        '';
        postfix = ''
          enabled  = ${lib.boolToString (active "postfix")}
          filter   = postfix
          port = 587,465,25
          maxretry = 3
        '';
        dovecot = ''
          enabled = ${lib.boolToString (active "dovecot2")}
          filter = dovecot
          port = 587,465,25
          maxretry = 1
          findtime = 6000
          bantime = 6000
        '';
      };
    };

  services.dovecot2 = {
    enable = true;
    configFile = pkgs.writeText "dovecot.conf" ''
      default_internal_user = postfix
      default_internal_group = postfix
      default_login_user = postfix
      auth_mechanisms = plain login
      protocols = none
      auth_debug = yes
      service auth {
        unix_listener /var/lib/postfix/private_auth {
          group = postfix
          mode = 0660
          user = postfix
        }
        user = root
      }
      passdb {
        driver = passwd-file
        args = /etc/dovecot/passwd
      }
    '';
  };
  services.postfix = {
    enable = true;

    extraMasterConf = ''
      submission inet n - n - - smtpd
    '';
    extraAliases = ''
      tom: tom
      abuse: tom
    '';
    rootAlias = "tom";
    setSendmail = true;
    hostname = "tomberek.info";
    destination = [ "$myhostname" "lists.srht.$myhostname" "localhost" ];

    relayHost = "smtp.gmail.com";
    relayPort = 587;
    tlsTrustedAuthorities = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    sslCert = "/var/lib/acme/tomberek.info/cert.pem";
    sslKey = "/var/lib/acme/tomberek.info/key.pem";

    enableSubmissions = true;
    submissionsOptions = {
      smtpd_tls_security_level = "may";
      smtpd_sasl_auth_enable = "yes";
      smtpd_tls_auth_only = "no";
      smtpd_reject_unlisted_recipient = "no";
      smtpd_sasl_security_options = "noanonymous";
      smtpd_sasl_type = "dovecot";
      smtpd_sasl_path = "/var/lib/postfix/private_auth";
      smtpd_client_restrictions = "permit_sasl_authenticated, reject_unknown_client_hostname";
      smtpd_recipient_restrictions = "permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination";
      smtpd_relay_restrictions = "permit_auth_destination, permit_mynetworks, permit_sasl_authenticated, defer_unauth_destination";

      smtpd_tls_session_cache_database = ''btree:''${data_directory}/smtpd_scache'';
      smtpd_tls_session_cache_timeout = "3600s";
      smtpd_tls_exclude_ciphers = "aNULL, eNULL, EXPORT, DES, RC4, MD5, PSK, aECDH, EDH-DSS-DES-CBC3-SHA, EDH-RSA-DES-CBC3-SHA, KRB5-DES, CBC3-SHA";
    };
    enableSubmission = true;
    submissionOptions = {
      smtpd_tls_security_level = "may";
      smtpd_sasl_auth_enable = "yes";
      smtpd_tls_auth_only = "no";
      smtpd_reject_unlisted_recipient = "no";
      smtpd_sasl_security_options = "noanonymous";
      smtpd_sasl_type = "dovecot";
      smtpd_sasl_path = "/var/lib/postfix/private_auth";
      smtpd_client_restrictions = "permit_sasl_authenticated, reject_unknown_client_hostname";
      smtpd_recipient_restrictions = "permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination";
      smtpd_relay_restrictions = "permit_auth_destination, permit_mynetworks, permit_sasl_authenticated, defer_unauth_destination";

      smtpd_tls_session_cache_database = ''btree:''${data_directory}/smtpd_scache'';
      smtpd_tls_session_cache_timeout = "3600s";
      smtpd_tls_exclude_ciphers = "aNULL, eNULL, EXPORT, DES, RC4, MD5, PSK, aECDH, EDH-DSS-DES-CBC3-SHA, EDH-RSA-DES-CBC3-SHA, KRB5-DES, CBC3-SHA";
    };

    extraConfig = ''
      smtp_tls_loglevel = 2
      smtp_sasl_auth_enable = yes
      smtp_sasl_password_maps = hash:/var/lib/postfix/sasl_passwd
      smtp_sasl_security_options = noanonymous
      smtp_use_tls = yes

      smtpd_restriction_classes = mua_sender_restrictions, mua_client_restrictions, mua_helo_restrictions
      mua_client_restrictions = permit_sasl_authenticated, reject
      mua_sender_restrictions = permit_sasl_authenticated, reject
      mua_helo_restrictions = permit_mynetworks, reject_non_fqdn_hostname, reject_invalid_hostname, permit

      smtpd_use_tls = yes
      smtpd_tls_security_level = may
      smtpd_sasl_auth_enable = yes
      smtpd_tls_auth_only = no
      smtpd_reject_unlisted_recipient = no
      smtpd_sasl_security_options = noanonymous
      smtpd_sasl_type = dovecot
      smtpd_sasl_path = /var/lib/postfix/private_auth
      #smtpd_client_restrictions= permit_sasl_authenticated, reject_unknown_client_hostname
      smtpd_recipient_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination
      smtpd_relay_restrictions = permit_auth_destination, permit_mynetworks, permit_sasl_authenticated, defer_unauth_destination

      smtpd_tls_session_cache_database = btree:''${data_directory}/smtpd_scache
      smtpd_tls_session_cache_timeout = 3600s
      smtpd_tls_exclude_ciphers = aNULL, eNULL, EXPORT, DES, RC4, MD5, PSK, aECDH, EDH-DSS-DES-CBC3-SHA, EDH-RSA-DES-CBC3-SHA, KRB5-DES, CBC3-SHA

      smtp_tls_session_cache_database = btree:/etc/postfix/smtp_tls_session_cache
      tls_random_source = dev:/dev/urandom

      # Disable DNS Lookups
      disable_dns_lookups = yes

      local_transport = local:$myhostname
      transport_maps = hash:/var/lib/postfix/transport
    '';

  };

  security.acme.acceptTerms = true;
  security.acme.certs = {
    "tomberek.info" = {
      #webroot = "/var/www/challenges/";
      email = "tomberek@gmail.com";
      #user = "nginx";
      #group = "nginx";
      postRun = "systemctl restart nginx.service";
    };
  };
  services.resolved.enable = true;
  services.resolved.fallbackDns = [ "8.8.8.8" ];
  security.acme.certs."tomberek.info".extraDomainNames = [
    "srht.tomberek.info"
    "builds.srht.tomberek.info"
    "dispatch.srht.tomberek.info"
    "git.srht.tomberek.info"
    "hub.srht.tomberek.info"
    "lists.srht.tomberek.info"
    "man.srht.tomberek.info"
    "meta.srht.tomberek.info"
    "paste.srht.tomberek.info"
    "todo.srht.tomberek.info"
    "hydra.tomberek.info"
  ];
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    virtualHosts = {
      "${fqdn}" = {
        forceSSL = true;
        enableACME = true;
        root = "/srv/www/_site";
        extraConfig = ''
          include       ${pkgs.nginx}/conf/mime.types;
          default_type  application/octet-stream;
        '';
        # locations."/hydra/" = {
        #   proxyPass = "http://127.0.0.1:3000/";
        #   extraConfig = ''
        #     proxy_redirect http://127.0.0.1:3000 https://${fqdn}/hydra;

        #     proxy_set_header  Host              $host;
        #     proxy_set_header  X-Real-IP         $remote_addr;
        #     proxy_set_header  X-Forwarded-For   https://$proxy_add_x_forwarded_for;
        #     proxy_set_header  X-Forwarded-Proto $scheme;
        #     proxy_set_header  X-Forwarded-Port 443;
        #     proxy_set_header  X-Request-Base    /hydra;
        #   '';
        # };
      };
      "hydra.${fqdn}" = {
        forceSSL = true;
        useACMEHost = fqdn;
        locations = {
          "/cache" = {
	        root = "/var/cache/hydra/nar-cache";
	      };
          "/" = {
	        proxyPass = "http://127.0.0.1:3000";
	      };
        };
      };
      "srht.${fqdn}" = {
        useACMEHost = fqdn;
      };
      "builds.srht.${fqdn}" = {
        useACMEHost = fqdn;
      };
      "git.srht.${fqdn}" = {
        useACMEHost = fqdn;
      };
      "lists.srht.${fqdn}" = {
        useACMEHost = fqdn;
      };
      "hub.srht.${fqdn}" = {
        useACMEHost = fqdn;
      };
      "dispatch.srht.${fqdn}" = {
        useACMEHost = fqdn;
      };
      "man.srht.${fqdn}" = {
        useACMEHost = fqdn;
      };
      "meta.srht.${fqdn}" = {
        useACMEHost = fqdn;
      };
      "paste.srht.${fqdn}" = {
        useACMEHost = fqdn;
      };
      "todo.srht.${fqdn}" = {
        useACMEHost = fqdn;
      };
    };

    sslCiphers = "ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384";
    # appendHttpConfig = ''
    #   add_header Strict-Transport-Security "max-age=15638400; includeSubDomains; preload";
    #   add_header        X-Frame-Options SAMEORIGIN;
    #   add_header        X-Content-Type-Options nosniff;
    #   add_header        X-XSS-Protection "1; mode=block";
    #   # for more security use: add_header        Content-Security-Policy 
    #   add_header Access-Control-Allow-Origin $http_origin;
    #   add_header Access-Control-Allow-Credentials true;
    #   add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS';
    #   add_header 'Access-Control-Allow-Headers' 'Accept,Authorization,Cache-Control,Content-Type,DNT,If-Modified-Since,Keep-Alive,Origin,User-Agent,X-Mx-ReqToken,X-Requested-With';

    #   ssl_dhparam       /etc/ssl/certs/dhparam.pem;
    #   resolver          8.8.8.8 8.8.4.4 valid=300s;
    #   resolver_timeout  5s;
    #   ssl_trusted_certificate /etc/ssl/ca-certs.pem;
    # '';
  };

  networking = {
    wireguard.enable = true;
    hosts = {
      "127.0.0.1" = [ "meta.sr.ht.local" "git.sr.ht.local" "todo.sr.ht.local" ];
    };
    # nat.enable = true;
    # nat.externalInterface = "eno1";
    # nat.internalInterfaces = [ "wg0" ];
    # wireguard.interfaces = {
    #   wg0 = {
    #     ips = [ "10.100.0.1/24" ];
    #     listenPort = 51820;
    #     privateKeyFile = "/etc/nixos/wg/private";
    #     peers = [
    #       {
    #         publicKey = "6SJ9I/MOEFnXuXr3JH4TQo1erC81Ha+mZXYndkZE5A4=";
    #         allowedIPs = [ "10.100.0.2/32" ];
    #         persistentKeepalive = 25;
    #       }
    #     ];
    #   };
    # };
    enableIPv6 = true;
    hostName = "tomberek";
    domain = "info";
    wireless.enable = false;
    resolvconf.dnsSingleRequest = false;

    firewall = {
      checkReversePath = false;
      #logReversePathDrops = true;
      #logRefusedConnections = true;
      #logRefusedPackets = true;
      enable = true;
      allowedTCPPorts = [
12981
        22
        53
        80
        443
        655
        2002
        25
        587
        3389
        8000
        25565
        51820
      ];
      allowedUDPPorts = [ 53 67 68 2086 51820 24454 6666 7777 ];
      allowPing = true;
      # extraCommands = ''
      #   iptables -A nixos-fw -i tinc.tomberek -p gre -j nixos-fw-accept 
      #   iptables -t nat -A POSTROUTING -p all -o eno1 -j MASQUERADE
      # '';
    };
  };

  services.ddclient = {
    enable = true;
    configFile = "/etc/nixos/keys/ddclient.conf";
  };

  services.postgresql.authentication = "local all all trust";

  services.avahi = {
    enable = true;
    ipv6 = false;
    nssmdns = true;
    hostName = "tomberek";
    wideArea = false;
    domainName = "local";
    publish.enable = true;
    publish.domain = true;
    publish.addresses = true;
    publish.hinfo = true;
    publish.workstation = true;
    publish.userServices = true;
  };

  







  services.cron.systemCronJobs = [
    "5 5 * * * rsync -avz -e 'ssh -i /etc/nixos/keys/insomnia_ecdsa' --delete /srv/www/_site/ tomberek@insomnia247.nl:/home/tomberek/public_html"
  ];

  # ,diffie-hellman-group-exchange-sha1
  services.openssh = {
    enable = true;
    ports = [ 2002 22 ];
    forwardX11 = true;
    permitRootLogin = "without-password";
  };
}

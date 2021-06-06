{ services, config, pkgs, users, ... }:
{
  services.postgresql.enable = true;
  services.hydra = {
    package = pkgs.hydra-unstable.overrideAttrs (old:{
      src = pkgs.fetchFromGitHub {
        owner = "DeterminateSystems";
        repo = "hydra";
        #508d99d6113bc0071d0f4fa100fea357beb6c832
        rev = "builds-index-jobset-id";
        sha256 = "sha256-I9peSPWA15CwJQoLfmDIoDCMfYttq1J7oRKaNmdFK7s=";
      };
    });
    enable = true;
    hydraURL = "https://tomberek.info/hydra"; # externally visible URL
    notificationSender = "tom@tomberek.info"; # e-mail of hydra service
    # you will probably also want, otherwise *everything* will be built from scratch
    useSubstitutes = true;
    # listenHost = "192.168.1.2";
    listenHost = "*";
    port = 3000;
    #extraConfig = ''
    #'';
  };
  users.users.hydra.createHome = true;
  users.groups.hydra = { };
  /*
  systemd.services.hydra-setup-user = {
  wantedBy = [ "multi-user.target" ];
  requires = [ "hydra-init.service" "postgresql.service" ];
  after = [ "hydra-init.service" "postgresql.service" ];
  environment = config.systemd.services.hydra-init.environment;
  path = [ config.services.hydra.package ];
  script =
  let hydraHome = config.users.users.hydra.home;
  hydraQueueRunnerHome = config.users.users.hydra-queue-runner.home;
  in ''
  hydra-create-user tom \
  --full-name 'Tom Bereknyei' \
  --email-address 'tom@tomberek.info' \
  --password 'thing' \
  --role admin

    #mkdir -p "${hydraHome}/.ssh"
    #chmod 700 "${hydraHome}/.ssh"
    #cp "*xxxx*" "${hydraHome}/.ssh/id_rsa"
    #chown -R hydra:hydra "${hydraHome}/.ssh"
    #chmod 600 "${hydraHome}/.ssh/id_rsa"
    #mkdir -p "${hydraQueueRunnerHome}/.ssh"
    #chmod 700 "${hydraQueueRunnerHome}/.ssh"
    #cp "*xxxx*" "${hydraQueueRunnerHome}/.ssh/id_rsa"
    #chown -R hydra-queue-runner:hydra "${hydraQueueRunnerHome}/.ssh"
    #chmod 600 "${hydraQueueRunnerHome}/.ssh/id_rsa"
  '';
  serviceConfig = {
  Type = "oneshot";
  RemainAfterExit = true;
  };
  };
  */
}

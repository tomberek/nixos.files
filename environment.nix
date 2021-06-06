{ config, pkgs, ... }:
{

  environment.etc = {
    "ssl/ca-certs.pem".source = "/etc/nixos/keys/ca-certs.pem";
    "ssl/nginx.basic".source = "/etc/nixos/keys/nginx.basic";
    "ssl/nginx.basic2".source = "/etc/nixos/keys/nginx.basic2";
    "ssl/certs/dhparam.pem".source = "/etc/nixos/keys/dhparam.pem";
    #"ssl/tomberek.info.pem".source = "/etc/nixos/tomberek.info.pem";
    #"ssl/tomberek.info.private.key".source = "/etc/nixos/tomberek.info.private.key";
    "tmux.conf".source = "/etc/nixos/tmux.conf";
    "dovecot/passwd".source = "/etc/nixos/keys/dovecot";
  };

  environment.variables.EDITOR = pkgs.lib.mkForce "vim";
  environment.variables.PATH = [ "$HOME/.local/bin" ];
  environment.shellAliases = {
    vi = "vim";
    rekoot = "systemctl kexec &";
    killx = "systemctl stop display-manager.service &";
    startx = "systemctl start display-manager.service &";
    nixos-rebuild-local = "nixos-rebuild switch -I nixpkgs=/etc/nixos/nixpkgs";
    nixos-rebuild-local-fast = "nixos-rebuild switch --fast -I nixpkgs=/etc/nixos/nixpkgs";
    nixos-rebuild-local-vm = "nixos-rebuild build-vm -I nixpkgs=/etc/nixos/nixpkgs";
    nixos-rebuild-dry = "nixos-rebuild dry-run --fast -I nixpkgs=/etc/nixos/nixpkgs";
  };

  security.sudo.wheelNeedsPassword = false;
  users.mutableUsers = false;
  users.extraUsers.root =
    {
      passwordFile = "/etc/nixos/keys/root.pass";
      openssh.authorizedKeys.keys = [ "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLG2m8T30u4zMfCVNUqHktu/VYW1O/kz4bfjE5kkaYHmzqNu2DBqC18BTX0Id7lgCT5NvqipfiW0VRFbSgOxjyc= dev@wonderland" "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpxkqOi8C2xXyyf5U7Z2NQ8S9qkJRjrxgM/IX9G6P3V8ibFytZLV4xVufebRRvDO1JaOu4f+v/d+tvb+WZVxFdY5xwEIyoX8OEUNYC4KI3LkhgyiL2rUasyjyxGKR4s3VR3+WXhi8J/6hbTGzFLwvjFH9Vi5Sd/G+Pvv4h8tE7OjEL1vVPiPQfAwIWXtwF2J7espvywYE+AyaedJxuKGH2D/A4eG/xYnEyU2ufWW8z1TkLEX4tWE2lDJwC9P0PrsRK7YE2c+JnJX+VV4jNS6+Vu+yUywyNLAqWqk3Sx0+TH2RRGbJjiJDPcITg1xmF5E45LMBa28VFUmmvl424XkdH openpgp:0xECC016F9" ];
    };
  users.extraUsers.tom =
    {
      description = "Tom";
      useDefaultShell = true;
      isNormalUser = true;
      passwordFile = "/etc/nixos/keys/tom.pass";
      extraGroups = [ "postgres" "users" "wheel" "postfix" "kippo" "nginx" ];
      openssh.authorizedKeys.keys = [
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLG2m8T30u4zMfCVNUqHktu/VYW1O/kz4bfjE5kkaYHmzqNu2DBqC18BTX0Id7lgCT5NvqipfiW0VRFbSgOxjyc= dev@wonderland"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpxkqOi8C2xXyyf5U7Z2NQ8S9qkJRjrxgM/IX9G6P3V8ibFytZLV4xVufebRRvDO1JaOu4f+v/d+tvb+WZVxFdY5xwEIyoX8OEUNYC4KI3LkhgyiL2rUasyjyxGKR4s3VR3+WXhi8J/6hbTGzFLwvjFH9Vi5Sd/G+Pvv4h8tE7OjEL1vVPiPQfAwIWXtwF2J7espvywYE+AyaedJxuKGH2D/A4eG/xYnEyU2ufWW8z1TkLEX4tWE2lDJwC9P0PrsRK7YE2c+JnJX+VV4jNS6+Vu+yUywyNLAqWqk3Sx0+TH2RRGbJjiJDPcITg1xmF5E45LMBa28VFUmmvl424XkdH cardno:000607660665"
      ];
    };
}

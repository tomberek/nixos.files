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
"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDSF4CzkvONzaze5m0huhLmED9fxQTtuyv7rszWI0ju/+U4Gq4+Sd800vFrADfnbiLS4hgK4pDw5D8dXxi74mPeXXZV4oomafCnlvW7tL7RidEXvkP2sr1ObgkuQ9K67hSqKjT21mCWdEN6WGHh9EtK5r3nXIzUWhATqDz/Al7sveDZ/gdapo+f3xnmpOu1mq+y5iOcRV7b98z/VaiWAvuG83toIBsK4Su/GWWfMNied9R2K2Z10NM3ART0Sk+4yqH4usJOieTQsLAq8Ykb3PAYDMVx41yy9QNcFnCyX/HJHFO/Q98BLQ2zPxVbBMwp99NrKLqrwkrVtrWbAttanm9 cardno:000607658414"
      ];
    };
  users.extraUsers.justin =
    {
      description = "DeiracDelta";
      createHome = true;
      useDefaultShell = true;
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
''command="tmux new-session -A -s main" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCx8iTX89Ejv/DtvGPbCARdRbQGQc4sSpdaQaxnGxDHcTTKxEXJpEY0BEojIJS7uPPl1GmiIJuL1b2ID6pFSlLFeq6SYOsYqb1/crb3+uJRGvhT1ak93WGeVf9DK9wwOxmEaL8bI00656+0h2OyJ92JPFXO+XtCoohcTQSgOoX3bpy4ejeTBpFADNj9I5gDf5QLBs2Kn8zPP++ds8qtcvGSLZZESsGauYSQaWZer7yWwG111za7V6ZO9WwKX7Sd74tKBWp6Hf72qqWsO+n0bd/sxOLJ+4zliKHzcgiKRfb41E9gpFM47TxFrMOPhZRuwktqMKDl01nI9fbS3lkR7drMIlbHdzHrSJjDM0jtItD9F3LdvxKjoUcHGdSljNvJQahu0tSzHO8z/6bHD8pTUUefHMenoHesSjIjSD8mujHi/Y/WWxYiJtett8WxiI8Yhf/6Q9Jt45HFSmLaHNM+UYKhE8mscZ+/b1Y/5xDMR6qH7zrFF9b8ML8SUTaFqDeN6UM=''
''command="tmux new-session -A -s main" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCnVsxxx7yiI1yWh2+wkmH7jMDTfvypsLfVkYuz+WObIi3V+1gZN3cPjHFYwEa1SpUNSs4/c2zdM1CANR5b61YgBmvbxYUVCBFNSeO1B9JTPUDcyM20vhRdeUOFlPS0KJHkKnlzjq4sEnjDM+zXCtAKEekBRcWqcnK2WX/Q9CI6+ocaJ30r06T0Hqa4C7Gx6pNbVNxaTaza3Mzod68aBjyg7WShsKPF5nLSe9QJIjUQ2bjGdRCUlXshgmW+E127KqryZqYLmmodF9fynCK6Ne+MDM2jEruRHMwhv50MfnO0ntOOM0i37oR3JuKE+AzJj/+Ete/YVbbIxipMm0DkNJEEqFsZRO5qkiP2MpI4TCZxHaac/pl+W6HdhwzSKCUrVBUTwEacaz/3WFgGgTjebpW1hfYbcTalG6e9t2W0OSg+INYLklp4uHDWHjFqyl5J+FZMNQdtWgD3yRyZN9rf1ojVf5AgxSW6pXIcrqMf/6Kf+kr/O0FOakrLaEHTDmONVTM=''
''command="tmux new-session -A -s main" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1ErJY6tI6cFyarf4ewkQhvvzfcps8g6Vwoo42w59f3Me412TBbhVuklf0wwxcElKg33KHJehMfOpHZhGuIN3B1Iq7KCRl4BgpOqGAO+Vw37BavCDD7iUMSd95tjxdiUbBGSouUUVhoV8i4rdHGU7NDyuglOd9vYcj+B7pD/xelW5Uc7Acmghf6GfxcdU0q4TUo8xOKB73v6m2A2VROiWYtUWS/QF5PL/QqHjdFSwzz63PieMrgKd6Nib+HUKC7RcyqHSuJQ/hlLLh2M0968bzFUT3HdvOS8G8wyMiENZ6bkhhWKSzhPGPtb9xlbfnBvrWrc/RPD/gV5IH+NTFK0r9''
''command="tmux new-session -A -s main" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM5DtmAk4jcG0i0m1HCnhienAMUgBQ25Srs5P9pRe1eL''
''command="tmux new-session -A -s main" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDSF4CzkvONzaze5m0huhLmED9fxQTtuyv7rszWI0ju/+U4Gq4+Sd800vFrADfnbiLS4hgK4pDw5D8dXxi74mPeXXZV4oomafCnlvW7tL7RidEXvkP2sr1ObgkuQ9K67hSqKjT21mCWdEN6WGHh9EtK5r3nXIzUWhATqDz/Al7sveDZ/gdapo+f3xnmpOu1mq+y5iOcRV7b98z/VaiWAvuG83toIBsK4Su/GWWfMNied9R2K2Z10NM3ART0Sk+4yqH4usJOieTQsLAq8Ykb3PAYDMVx41yy9QNcFnCyX/HJHFO/Q98BLQ2zPxVbBMwp99NrKLqrwkrVtrWbAttanm9 cardno:000607658414''
      ];
    };
}

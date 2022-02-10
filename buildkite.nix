{pkgs, ...}: {
  services.buildkite-agents.builder = {
    enable = true;
    tokenPath = "/etc/nixos/keys/buildkite.txt";
    #privateSshKeyPath = "/path/to/ssh/key";
    runtimePackages = [
      pkgs.gnutar
      pkgs.bash
      pkgs.nix
      pkgs.gzip
      pkgs.git
      pkgs.xz
    ];
  };
  services.buildkite-agents.builder-2 = {
    enable = true;
    tokenPath = "/etc/nixos/keys/buildkite.txt";
    #privateSshKeyPath = "/path/to/ssh/key";
    runtimePackages = [
      pkgs.gnutar
      pkgs.bash
      pkgs.nix
      pkgs.gzip
      pkgs.git
      pkgs.xz
    ];
  };
}

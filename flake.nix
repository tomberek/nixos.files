{
  inputs.nixpkgs = {
    url = "git+file:///etc/nixos/nixpkgs?ref=sourcehut_major";
    #url = "path:///etc/nixos/nixpkgs";
    flake = true;
  };
  outputs = { self, nixpkgs }: {

    nixosConfigurations.tomberek = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
      ];
    };
  };
}

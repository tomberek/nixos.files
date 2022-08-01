{
  inputs.nixpkgs = {
    #url = "git+file:///etc/nixos/nixpkgs?ref=ju1m/sourcehut";
    url = "github:NixOS/nixpkgs/nixos-unstable";
    flake = true;
  };

  inputs.nix.url = "github:NixOS/nix/2.8.0";
  inputs.hydra.url = "github:tomberek/hydra/include_nix";
  inputs.hydra.inputs.nix.follows = "nix";

  outputs = { self, nix, hydra, nixpkgs }: 
    let
      overlay-unstable = final: prev: {
        unstable = import nixpkgs {config.allowUnfree=true;};
        nixUnstable = nix.packages.x86_64-linux.nix;
        nixFlakes = nix.packages.x86_64-linux.nix;
        hydraUnstable = hydra.packages.x86_64-linux.hydra;
      };
    in
{
    nixosConfigurations.tomberek = let
      pkgs = import nixpkgs { overlays = [ overlay-unstable];
           config.allowUnfree = true;
           system = "x86_64-linux";
      };
    in
       nixpkgs.lib.nixosSystem {
           system = "x86_64-linux";
           modules = [ { nixpkgs = { inherit pkgs; 
                        };}
                         ./configuration.nix
                         # ./minecraft.nix
            ];
  };
 };
}

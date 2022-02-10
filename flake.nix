{
  inputs.nixpkgs = {
    #url = "git+file:///etc/nixos/nixpkgs?ref=ju1m/sourcehut";
    #url = "path:///etc/nixos/nixpkgs";
    url = "github:NixOS/nixpkgs/nixos-unstable";
    #url = "github:ju1m/nixpkgs/sourcehut";
    flake = true;
  };
  outputs = { self, nixpkgs }: 
let
  overlay-unstable = final: prev: {
    unstable = import nixpkgs {config.allowUnfree=true;};
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

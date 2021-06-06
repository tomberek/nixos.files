#!/bin/sh
set -e

pushd nixpkgs
git add -A
git commit --amend --no-edit
popd

nix flake update --update-input nixpkgs #--option substituters ''
nixos-rebuild switch --impure -L --fast #--option substituters ''

#/root/nix/result/bin/nix build .#nixosConfigurations.tomberek.config.system.build.toplevel  --impure # --builders 'ssh://root@perkeep.mooch.rip' --impure --option builders 'tom@10.100.0.2 x86_64-linux - 4 4'


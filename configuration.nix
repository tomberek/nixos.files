{ config, pkgs, options, ... }:

{
  documentation.nixos.enable = false;
  hardware.enableRedistributableFirmware = true;
  fonts = {
    enableGhostscriptFonts = true;
    fonts = with pkgs; [ corefonts inconsolata terminus_font ];
  };

  imports = [
    ./hardware-configuration.nix
    ./grub.nix
    ./networking.nix
    ./environment.nix
    ./hydra.nix
    # ./sourcehut.nix
    ./buildkite.nix
  ];

  nix.buildCores = 3;
  nix.nixPath = [
    "nixpkgs=/etc/nixos/nixpkgs"
    "nixos-config=/etc/nixos/configuration.nix"
    "nixos=/etc/nixos/nixpkgs/nixos"
  ];
  # nix.package = (builtins.getFlake "github:NixOS/nix/69c6fb12eea414382f0b945c0d6c574c43c7c9a3").packages.x86_64-linux.nix;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    auto-optimise-store = true
    gc-keep-outputs = true
    gc-keep-derivations = true
    extra-trusted-public-keys = tframe-tomberek.info-1:mbb/hj+juXREwCLtaoH5ItESxyJEXD1uqbu+LUTvfcs=
  '';
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";


  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  system.autoUpgrade.enable = true;
  environment.systemPackages = with pkgs; [
    vim
    stdenv
    lsof
    bind
    htop
    wget
    gitFull
    gnupg1compat
    tmux
    file
    openssl
    dhcp
    rsync
    mcrcon
  ];

  boot.cleanTmpDir = true;
  boot.initrd.extraUtilsCommands = ''
    copy_bin_and_libs ${pkgs.btrfs-progs}/bin/btrfs
    copy_bin_and_libs ${pkgs.parted}/bin/parted
  '';
  boot.initrd.extraUtilsCommandsTest = ''
    $out/bin/parted --version
    $out/bin/btrfs --version
  '';
  boot.kernel.sysctl = { "kernel.panic" = 30; };
  boot.initrd.supportedFilesystems = [ "btrfs" ];
  boot.supportedFilesystems = [ "btrfs" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.acpid.enable = true;
  services.journald.extraConfig = "SystemMaxUse=100M";
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "ondemand";
  #powerManagement.scsiLinkPolicy = "min_power";

  time.hardwareClockInLocalTime = true;
  time.timeZone = "America/New_York";
  
}

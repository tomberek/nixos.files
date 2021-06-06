{ config, pkgs, ... }:
rec {

  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
    declarative = true;
    whitelist = {
      lukasalan = "f5be9d3a-9de3-4869-970e-bfa2b73175c7";
      wolf_ultima = "a3a29bc3-dfba-421c-8c56-6cec92cf1b24";
      walsall = "d522ebad-63d7-429b-8f2c-aa95d7dfe3c3";
      zerocp= "6066dbc2-e5bf-476e-b6ee-bef19f3c22a9";
      SavitarG4mer = "46bb0a16-1d7e-4efd-a489-ee6616ba38dd";
      paeiynt = "a5b1ed06-4b8f-4fc4-81a0-32297f859c1b";
    };
    #jvmOpts = "-Dorg.lwjgl.glfw.libname=${pkgs.glfw3}/lib/libglfw.so -Dorg.lwjgl.openal.libname=${pkgs.openal}/lib/libopenal.so";
    serverProperties = {
        debug = "true";
        gamemode = "survival";
        max-players = 8;
        motd = "Lukas Minecraft server!";
        white-list = false;
        enable-rcon = true;
        "rcon.password" = "listener";
    };
  };
  systemd.services.minecraft-server.serviceConfig.ExecStart= pkgs.lib.mkForce "${pkgs.jre_headless}/bin/java -jar server.jar";
}

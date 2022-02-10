{ config, pkgs, ... }:
rec {

  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
    declarative = true;
    package = pkgs.unstable.minecraft-server;
    whitelist = {
      MarineMajor = "f5be9d3a-9de3-4869-970e-bfa2b73175c7";
      wolf_ultima = "a3a29bc3-dfba-421c-8c56-6cec92cf1b24";
      walsall = "d522ebad-63d7-429b-8f2c-aa95d7dfe3c3";
      zerocp= "6066dbc2-e5bf-476e-b6ee-bef19f3c22a9";
      SavitarG4mer = "46bb0a16-1d7e-4efd-a489-ee6616ba38dd";
      paeiynt = "a5b1ed06-4b8f-4fc4-81a0-32297f859c1b";
      BbJug = "8382ac81-d84b-4f53-9f78-cb6f22802ade";
      Marshington = "122d1a38-c58f-4b54-ba13-898c585c73b2";
      mmmeh = "7025e805-b69c-4ea5-82e1-b772a120611e";
      MadeinWorld = "b178d9b6-896e-451e-970e-7d3ffb855a3d";
      AtoBreeze = "dcaa2622-638c-42f7-b8c0-36e94abf1b56";
      wolfhowler101 = "141456ed-0061-493b-a79c-88f5fcecf3f1";
    };
    #jvmOpts = "-Dorg.lwjgl.glfw.libname=${pkgs.glfw3}/lib/libglfw.so -Dorg.lwjgl.openal.libname=${pkgs.openal}/lib/libopenal.so";
    serverProperties = {
        debug = "true";
        gamemode = "survival";
        max-players = 8;
        motd = "Minecraft server!";
        white-list = false;
        enable-rcon = true;
        "rcon.password" = "listener";
    };
  };
 systemd.services.minecraft-server.serviceConfig.ExecStart= pkgs.lib.mkForce "${pkgs.jre_headless}/bin/java -Xms2G -Xmx8G -jar paper.jar --nogui";
}

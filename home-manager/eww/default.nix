{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: { 
  home.packages = with pkgs; [
    bash
    bc
    coreutils
    dbus
    mako
    findutils
    gawk
    gnused
    gojq
    imagemagick
    jaq
    light
    networkmanager
    pavucontrol
    pulseaudio
    procps
    ripgrep
    socat
    upower
    util-linux
    wireplumber
    wofi
  ];

  programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    # remove nix files
    configDir = lib.cleanSourceWith {
      filter = name: _type: let
        baseName = baseNameOf (toString name);
      in
        !(lib.hasSuffix ".nix" baseName);
      src = lib.cleanSource ./.;
    };
  };

  systemd.user.services.eww = {
    Unit = {
      Description = "Eww Daemon";
      # not yet implemented
      # PartOf = ["tray.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      #Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
      ExecStart = "${config.programs.eww.package}/bin/eww daemon --no-daemonize";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}

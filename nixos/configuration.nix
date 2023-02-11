# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, lib, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  #hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

  nix = {
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry; 
    settings = {
      experimental-features = "nix-command flakes";
     
      auto-optimise-store = true;	
    
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];

     };
  };

  boot = {
    tmpOnTmpfs = true;
    loader.systemd-boot = {
      enable = true;
      editor = false;
    };
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  };

  networking = {
    hostName = "inhame";
    nameservers = [ "::1" "127.0.0.1" ];
    firewall = {
      enable = true;
      allowPing = false;
    };
    networkmanager = {
      enable = true;
      dns = "none";
      wifi.macAddress = "stable";
      ethernet.macAddress = "random";
    };
  };
  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      ipv6_servers = true;
      require_dnssec = true;
      http3 = true; # Experimental
      doh_servers = false;

      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };
    };
  };

  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };

  services.tor = {
    enable = true;
    client.enable = true;
    torsocks.enable = true;
  };
  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  security.pam.services.swaylock = {};

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # make hm gtk work
  programs.dconf.enable = true;
  services.flatpak.enable = true;
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  };
  # needed for GNOME services outside of GNOME Desktop
  services.dbus.packages = [pkgs.gcr];
  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];

  programs.zsh.enable = true;

  users.users.gui = {
    isNormalUser = true;
    extraGroups = [ 
    "wheel" 
    "audio" 
    "networkmanager" 
     
    #++ ifTheyExist [
    #   "network"
    #   "wireshark"
    #   "i2c"
    #   "mysql"
       "docker"
       "podman"
       "git"
    #   "libvirtd"
     ]; 
    shell = pkgs.zsh;
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };

  # Fonts
  fonts = {
    fonts = with pkgs; [
      twemoji-color-font
      ibm-plex
      noto-fonts-cjk
      noto-fonts-emoji
      material-symbols
      (nerdfonts.override {fonts = ["FantasqueSansMono" "JetBrainsMono"];})
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [
          "FantasqueSansMono Nerd Font"
          "Noto Color Emoji"
        ];
        sansSerif = ["IBM Plex Sans" "Noto Color Emoji"];
        serif = ["IBM Plex Serif" "Noto Color Emoji"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };

  hardware = {
    bluetooth.enable = false;
    pulseaudio.enable = false;
    opengl = {
      enable = true;
      driSupport = true;
      extraPackages = with pkgs; [
        vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      ];
    };
  };
  zramSwap.enable = true;
  programs.light.enable = true;

  system.stateVersion = "22.11"; # Did you read the comment?

}


{ inputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    ./newsboat
    ./shell
    ./gtk
    ./games
    ./eww
    ./foot.nix
    ./btop.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "gui";
    homeDirectory = "/home/gui";
  };

  # Add stuff for your user as you see fit:
  programs.neovim.enable = true;

  programs.home-manager.enable = true;
  programs.git.enable = true;

  programs.go = {
    enable = true;
    goPath = ".local/share/go";
    goBin = ".local/bin.go";
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
    };
  };
  programs.zathura.enable = true;
  programs.mpv.enable = true;
  programs.yt-dlp.enable = true;

  programs.mako.enable = true;

  programs.swaylock.settings = {
    color = "000000";
    ignore-empty-password = true;
    show-failed-attempts = true;
  };

  home.packages = with pkgs; [
    webcord
    librewolf
    brave
    keepassxc
    
    xdg-utils
    
    wofi
    grim
    wl-clipboard
    swaylock
    inputs.hyprland-contrib.packages.${pkgs.hostPlatform.system}.grimblast
    imv

    ripgrep
    fd
    distrobox
  ];

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = [ "librewolf.desktop" ];
        "text/xml" = [ "librewolf.desktop" ];
        "x-scheme-handler/http" = [ "librewolf.desktop" ];
        "x-scheme-handler/https" = [ "librewolf.desktop" ];
      };
    };
  };

  home.sessionVariables = {
    LIBSEAT_BACKEND = "logind";
    SDL_VIDEODRIVER = "wayland";
    MOZ_ENABLE_WAYLAND = 1;
    WLR_RENDERER = "vulkan";
    LIBVA_DRIVER_NAME = "i965";
    GOPROXY = "direct";
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = 14;
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel";
  };
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}

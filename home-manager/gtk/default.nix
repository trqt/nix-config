{ config, pkgs, ... }: {

  home.packages = with pkgs; [glib]; # gsettings
  xdg.systemDirs.data = let
    schema = pkgs.gsettings-desktop-schemas;
  in ["${schema}/share/gsettings-schemas/${schema.name}"];

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 14;
    gtk.enable = true;
    x11.enable = true;
  };
  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    
    font = {
      name = "Roboto";
      package = pkgs.roboto;
    };
    
    iconTheme = {
      #name = "Fluent"; 
      #package = pkgs.fluent-icon-theme;
      name = "Colloid"; 
      package = pkgs.colloid-icon-theme;
    };

    theme = {
      name = "Catppuccin-Mocha-Compact-Mauve-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["mauve"];
        size = "compact";
        variant = "mocha";
      };
    };
    #marwaita-peppermint
    #Marwaita (Dark) Peppermint
  };
}

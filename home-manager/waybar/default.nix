{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs.waybar = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.waybar-hyprland;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
	height = 18;
        modules-left = ["wlr/workspaces"];
        modules-center = [];
        modules-right = ["pulseaudio" "network" "memory" "battery" "clock" "tray"];

        "wlr/workspaces" = {
          format = "{name}";
        };

        pulseaudio = {
          format = " {icon} ";
          format-muted = "ﱝ";
          format-icons = ["奄" "奔" "墳"];
          tooltip = true;
          tooltip-format = "{volume}%";
        };

        network = {
          format-wifi = " ";
          format-disconnected = "睊";
          format-ethernet = " ";
          tooltip = true;
          tooltip-format = "{signalStrength}%";
        };

	memory = {
		interval = 5;
		format = " {used:0.1f}G/{total:0.1f}G";
		states = {
			warning = 70;
			critical = 90;
		};
		tooltip = false;
	};

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}";
          format-charging = "";
          format-plugged = "";
          format-icons = ["" "" "" "" "" "" "" "" "" "" "" ""];
          tooltip = true;
          tooltip-format = "{capacity}%";
        };

        clock = {
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
          format-alt = ''
             {:%d
             %m
            %Y}'';
          format = ''
            {:%H
            %M}'';
        };

        tray = {
          icon-size = 21;
          spacing = 10;
        };
      };
    };

    style = builtins.readFile ./style.css;
  };

  xdg.configFile."waybar/mocha.css".text =
    builtins.readFile ./mocha.css;
}

{ config, lib, pkgs, extpkgs, ... } @ moduleArgs:

let
    inherit (config.lib.formats.rasi) mkLiteral;
    singularityFragment = import ./fragment.nix moduleArgs;
in {
    config.renix.themes."singularity" = {
        fontMono = "GohuFont";
        fontSizeNormal = 11;
        fontSerif = "FreeSerif";
        fontSans = "FreeSans";

        colour = {
            mainBg = "121216";
            accentBg = "e8e6e1";
            mainFg = "e8e6e1";
            accentFg = "121216";
        };

        termColour = {
            mainBg = "232";
            accentBg = "233";
            mainFg = "252";
            accentFg = "251";
        };

        integrations = {
            cursor = {
                enable = true;
                cursorName = "Adwaita";
                cursorPackage = pkgs.adwaita-icon-theme;
            };

            helix = {
                enable = true;
                helixBase = "carbonfox";
            };

            mako = {
                enable = true;
                anchor = "bottom-right";
                actionableAnchor = "top-right";
            };

            qutebrowser = {
                enable = true;
                tabIcons = false;
                tabPosition = "top";
            };

            rofi = {
                enable = true;

                baseStyle = activeTheme: {
                    margin = 0;
                    padding = 0;
                    spacing = 0;
                };

                elemStyle = activeTheme: {
                    "window" = {
                        location = mkLiteral "center";
                        width = 720;
                        height = 720;
                        background-color = mkLiteral "#${activeTheme.colour.mainBg}";
                    };

                    "inputbar" = {
                        spacing = 8;
                        padding = 8;
                        background-color = mkLiteral "#${activeTheme.colour.mainBg}";
                    };

                    "prompt, entry, element-text" = {
                        vertical-align = mkLiteral "0.5";
                    };

                    "prompt" = {
                        text-color = mkLiteral "#${activeTheme.colour.mainFg}";
                    };

                    "textbox" = {
                        padding = 8;
                        background-color = mkLiteral "#${activeTheme.colour.mainBg}";
                    };

                    "listview" = {
                        padding = mkLiteral "4px 0";
                        lines = 8;
                        columns = 1;

                        fixed-height = true;
                    };

                    "element" = {
                        padding = 8;
                        spacing = 8;
                    };

                    "element normal" = {
                        text-color = mkLiteral "#${activeTheme.colour.mainFg}";
                    };

                    "element selected normal, element selected active" = {
                        text-color = mkLiteral "#${activeTheme.colour.accentFg}";
                        background-color = mkLiteral "#${activeTheme.colour.accentBg}";
                    };

                    "element-text" = {
                        text-color = mkLiteral "inherit";
                        font = mkLiteral "inherit";
                    };

                    "element-text selected" = {
                        text-transform = mkLiteral "bold";
                    };
                };
            };

            sway = {
                enable = true;

                background = ./background;

                fragment = {
                    enable = true;
                    command = "${lib.getExe extpkgs.glbg} --fps 30 --sleep 3";
                    shader = singularityFragment;
                    displays = [ "eDP-1" "HDMI-A-1" "DP-7" "DP-8 --scale 0.6" "DP-9" ];
                };

                gaps = {
                    inner = 0;
                    smartGaps = true;
                };

                floatingTitle = true;
            };

            swaylock = {
                enable = true;

                background = ./background;
            };

            waybar = {
                enable = true;

                leftModules = [
                    {
                        moduleName = "sway/workspaces";
                        format = "{name}";
                    }

                    {
                        moduleName = "sway/mode";
                        format = "{}";
                        tooltip = false;
                    }

                    {
                        moduleName = "sway/scratchpad";
                        format = "{icon}";
                        show-empty = false;
                        format-icons = [ "" "[=]" ];
                        tooltip = true;
                        tooltip-format = "{app} : {title}";
                    }

                    {
                        moduleName = "idle_inhibitor";
                        format = "{icon}";
                        format-icons = {
                            activated = "‹o›";
                            deactivated = "‹x›";
                        };
                    }
                ];

                rightModules = [
                    {
                        moduleName = "pulseaudio";
                        format = "{volume}% | {format_source}";
                        format-bluetooth = "{volume}% B | {format_source}";
                        format-muted = "X | {format_source}";
                        format-source = "{volume}%";
                        format-source-muted = "X";
                    }

                    {
                        moduleName = "network";
                        format-wifi = "{essid} ({signalStrength}%)";
                        format-ethernet = "{ipaddr}/{cidr}";
                        format-disconnected = "Disconnected";
                        format-tooltip = "{ipaddr} -> {gwaddr}";
                        tooltip = true;
                    }

                    {
                        moduleName = "backlight";
                        format = "L:{percent}%";
                        tooltip = false;
                    }

                    {
                        moduleName = "cpu";
                        format = "C:{usage}%";
                        tooltip = false;
                    }

                    {
                        moduleName = "memory";
                        format = "M:{percentage}%";
                        tooltip = false;
                    }

                    {
                        moduleName = "battery";
                        states = {
                            good = 75;
                            warning = 30;
                            critical = 15;
                        };
                        full-at = 75;
                        format = "B:{capacity}% {icon}";
                        format-full = "B:{capacity}% {icon}";
                        format-charging = "B:{capacity}% [~~~]";
                        format-plugged = "B:{capacity}% [***]";
                        format-icons = [ "[   ]" "[*  ]" "[** ]" "[***]" ];
                    }

                    {
                        moduleName = "clock";
                        format = "{:%I:%M}";
                        tooltip = true;
                        tooltip-format = "<tt><small>{calendar}</small></tt>";
                        format-alt = "{:%Y-%m-%d}";
                    }
                ];
            };
        };
    };
}

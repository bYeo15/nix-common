{ config, lib, pkgs, extpkgs, ... } @ moduleArgs:

let
    inherit (config.lib.formats.rasi) mkLiteral;
    runHtop = "swaymsg exec -- foot --app-id=htop htop";
    term-opacity = "0.85";
in {
    config.renix.themes."ink" = {
        fontMono = "FreeMono";
        fontSizeNormal = 11;
        fontSerif = "FreeSerif";
        fontSans = "FreeSans";

        colour = {
            mainBg = "E5DFD3";
            accentBg = "B3B5B2";
            mainFg = "4A5353";
            accentFg = "4A5353";
        };

        termColour = {
            mainBg = "TODO";
            accentBg = "TODO";
            mainFg = "TODO";
            accentFg = "TODO";
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

                gaps = {
                    inner = 0;
                    smartGaps = true;
                };

                floatingTitle = false;
                floatingBorder = 2;

                windowRules = [
                    {
                        command = "border pixel 2";

                        criteria = {
                            floating = true;
                        };
                    }

                    {
                        command = "floating true; opacity ${term-opacity}";

                        criteria = {
                            app_id = "htop";
                        };
                    }
                ];

                bars = [
                    {
                        id = "mainBar";
                        command = "${lib.getExe pkgs.waybar}";
                        mode = "hidden";
                    }

                    {
                        id = "mediaBar";
                        # dummy command just to make the bar id available
                        command = "true";
                        mode = "hidden";
                    }
                ];

                showHideBar = true;
            };

            swaylock = {
                enable = true;
            };

            waybar = {
                enable = true;

                ipcId = "mainBar";

                barPosition = "left";

                barHeight = 720;
                barWidth = 40;
                barLMargin = 2;
                moduleSpacing = 0;

                leftModules = [
                    {
                        moduleName = "idle_inhibitor";
                        format = "{icon}";
                        format-icons = {
                            activated = "○";
                            deactivated = "⊗";
                        };
                        tooltip = false;
                    }

                    {
                        moduleName = "sway/workspaces";
                        format = "{name}";
                    }

                    {
                        moduleName = "sway/scratchpad";
                        format = "{icon}";
                        show-empty = false;
                        format-icons = [ "" "⌜≣⌟" ];
                        tooltip = true;
                        tooltip-format = "{app}: {title}";
                    }

                    {
                        moduleName = "sway/mode";
                        format = "{}";
                        tooltip = false;
                    }
                ];

                rightModules = [
                    {
                        moduleName = "clock";
                        format = "{:%I\n%M}";
                        tooltip = true;
                        tooltip-format = "<tt><small>{calendar}</small></tt>";
                        format-alt = "{:%Y\n%m\n%d}";
                    }

                    {
                        moduleName = "network";
                        format-wifi = "ᯤ";
                        format-ethernet = "⋺";
                        format-disconnected = "∅";
                        tooltip-format-wifi = "{essid} ({signalStrength}%)";
                        tooltip-format-ethernet = "{ipaddr}/{cidr}";
                        tooltip-format-disconnected = "Disconnected";
                        tooltip = true;
                    }

                    {
                        moduleName = "backlight";
                        format = "L:{percent}";
                        tooltip = false;
                    }

                    {
                        moduleName = "cpu";
                        format = "C:{usage}%";
                        tooltip = false;
                        on-click = runHtop;
                    }

                    {
                        moduleName = "memory";
                        format = "M:{percentage}%";
                        tooltip-format = "{used}/{avail}";
                        on-click = runHtop;
                    }

                    {
                        moduleName = "battery";
                        states = {
                            good = 75;
                            warning = 30;
                            critical = 15;
                        };
                        full-at = 75;
                        format = "│{icon}│";
                        format-plugged = "│█│";
                        format-charging = "│░│";
                        format-icons = [ "█" "▆" "▄" "▂" ];
                        tooltip-format = "{capacity}% {time}";
                        tooltip-format-charging = "{capacity}% (Charging)";
                        tooltip-format-plugged = "{capacity}% (Plugged)";
                    }
                ];

                additionalBars = {
                    mediaBar = {
                        ipcId = "mediaBar";

                        position = "bottom";

                        barWidth = 500;
                        barHeight = 40;
                        barBMargin = 5;
                        moduleSpacing = 0;

                        centreModules = [
                            {
                                moduleName = "custom/song_prev";
                                format = "⏮";
                                on-click = "playerctl previous";
                            }

                            {
                                moduleName = "pulseaudio";
                                format = "{volume} │ {format_source}";
                                format-bluetooth = "{volume}ᛒ │ {format_source}";
                                format-muted = "X │ {format_source}";
                                format-source = "{volume}";
                                format-source-muted = "X";
                                on-click = "wpctl set-mute @DEFAULT_SINK@ toggle";
                                on-right-click = "wpctl set-mute @DEFAULT_SOURCE@ toggle";
                            }

                            {
                                moduleName = "mpris";
                                format = "{dynamic} {status_icon}";
                                dynamic-order = [ "title" "artist" "position" "length" ];
                                tooltip = false;
                                status-icons = {
                                    "playing" = "⏵";
                                    "paused" = "⏸";
                                    "stopped" = "⏹";
                                };
                                on-click = "playerctl play-pause";
                                on-right-click = "swaymsg [app_id=\"cmus\"] focus";
                            }

                            {
                                moduleName = "custom/song_next";
                                format = "⏭";
                                on-click = "playerctl next";
                            }
                        ];
                    };
                };

                style = activeTheme: ''
                    * {
                        font-family: ${activeTheme.fontMono};
                        font-size: ${toString activeTheme.fontSizeLarge}px;
                    }

                    window#waybar {
                        background-color: #${activeTheme.colour.mainBg};
                        color: #${activeTheme.colour.mainFg};
                        border: 2px solid #${activeTheme.colour.accentBg};
                    }

                    #battery,
                    #backlight
                    #clock,
                    #cpu,
                    #idle_inhibitor,
                    #memory,
                    #network,
                    #sway/mode,
                    #sway/scratchpad,
                    #sway/workspaces {
                        margin-left: 4px;
                        margin-right: 4px;
                        margin-top: 2px;
                        margin-bottom: 2px;
                        padding-top: 8px;
                        padding-bottom: 8px;
                        border: 1px solid #${activeTheme.colour.accentBg};
                        box-shadow: inset -2px 2px 0 0px #${activeTheme.colour.accentFg}, inset 2px -2px 0 0px #${activeTheme.colour.accentFg};
                    }
                '';
            };
        };
    };
}

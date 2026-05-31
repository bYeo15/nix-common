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
            # TODO redo light colors
            mainBg = "E5DFD3";
            accentBg = "B3B5B2";
            mainFg = "4A5353";
            accentFg = "4A5353";
        };

        termColour = {
            mainBg = "243";
            accentBg = "237";
            mainFg = "234";
            accentFg = "233";
        };

        integrations = {
            cursor = {
                enable = true;
                cursorName = "Adwaita";
                cursorPackage = pkgs.adwaita-icon-theme;
            };

            helix = {
                enable = true;
                helixBase = "onelight";
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
                        mode = "invisible";
                        # disable show-hide within sway itself, prevents
                        # waybar leaving silhouettes
                        extraConfig = "modifier none";
                    }

                    {
                        id = "mediaBar";
                        # dummy command just to make the bar id available
                        command = "true";
                        mode = "invisible";
                        extraConfig = "modifier none";
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
                barExclusive = false;
                barPassthrough = false;

                barHeight = 1100;
                barLMargin = 3;

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
                        all-outputs = true;
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
                        format-alt = "{:%d\n%m\n%Y}";
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
                        format = "{percent}%";
                        tooltip = false;
                        align = 1.0;
                    }

                    {
                        moduleName = "cpu";
                        format = "{usage}%";
                        tooltip = false;
                        align = 1.0;
                        on-click = runHtop;
                    }

                    {
                        moduleName = "memory";
                        format = "{percentage}%";
                        tooltip-format = "{used}G / {avail}G";
                        align = 1.0;
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

                        barPosition = "bottom";
                        barExclusive = false;
                        barPassthrough = false;

                        barWidth = 900;
                        barBMargin = 5;

                        moduleSpacing = 0;

                        leftModules = [
                            {
                                moduleName = "custom/song_prev";
                                format = "⏮";
                                on-click = "playerctl previous";
                            }
                        ];

                        centreModules = [
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
                                on-click-right = "swaymsg [app_id=\"cmus\"] focus";

                                artist-len = 25;
                                title-len = 50;
                            }
                        ];

                        rightModules = [
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
                        font-weight: bold;
                    }

                    button {
                        border: none;
                        border-radius: 0;
                        padding: 0px 0px;
                    }

                    tooltip {
                        background-color: #${activeTheme.colour.mainBg};
                        border: none;
                        border-radius: 0;
                    }

                    tooltip label {
                        color: #${activeTheme.colour.mainFg};
                        font-weight: normal;
                    }

                    window#waybar {
                        background-color: #${activeTheme.colour.mainBg};
                        color: #${activeTheme.colour.mainFg};
                        border: 2px solid #${activeTheme.colour.accentFg};
                        box-shadow: inset -2px 2px 0 0px #${activeTheme.colour.accentBg}, inset 2px -2px 0 0px #${activeTheme.colour.accentBg};
                    }

                    #battery,
                    #backlight,
                    #cpu,
                    #memory,
                    #clock,
                    #idle_inhibitor,
                    #network,
                    #mode,
                    #scratchpad,
                    #workspaces {
                        margin-top: 3px;
                        margin-bottom: 3px;
                        margin-left: 6px;
                        margin-right: 6px;
                        padding-top: 2px;
                        padding-bottom: 2px;
                        padding-left: 1px;
                        padding-right: 1px;
                        background-color: #B3B5B2;
                        border: 1px solid #4A5353;
                    }

                    #backlight {
                        border-bottom: 0px;
                        margin-bottom: -1px;
                    }

                    #cpu {
                        border-bottom: 0px;
                        margin-bottom: -1px;
                        border-top: 0px;
                        margin-top: -1px;
                    }

                    #memory {
                        border-top: 0px;
                        margin-top: -1px;
                    }

                    #idle_inhibitor {
                        margin-top: 5px;
                    }

                    #battery {
                        margin-bottom: 5px;
                    }

                    #workspaces {
                        padding: 0px;
                    }

                    #workspaces button {
                        color: #4A5353;
                        padding-top: 1px;
                        padding-bottom: 1px;
                        padding-left: 1px;
                        padding-right: 1px;
                    }

                    #workspaces button.focused {
                        color: #E5DFD3;
                        background-color: #4A5353;
                    }

                    window#waybar #workspaces button.focused:hover {
                        color: #E5DFD3;
                        background-color: #4A5353;
                    }

                    window#waybar.mainBar {
                        min-height: 1100px;
                    }

                    #pulseaudio,
                    #mpris,
                    #custom-song_prev,
                    #custom-song_next {
                        margin-top: 4px;
                        margin-bottom: 4px;
                        margin-left: 8px;
                        margin-right: 8px;
                    }

                    window#waybar.mediaBar {
                        min-width: 900px;
                    }
                '';
            };
        };
    };
}

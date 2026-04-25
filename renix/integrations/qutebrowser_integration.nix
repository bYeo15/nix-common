/*
    renix qutebrowser integration:
    inherits colours and font from activeTheme

    Integration config is;

        tabIcons: bool optional
            show tab icons?

        tabPosition: str optional
            one of "top" "bottom" "left" "right"

        forceFont: bool optional
            if true, will clobber all webfonts with
            a custom stylesheet forcing the use of the
            default monospace font

        startPage: attrset optional
            configuration for the starting page;
            source: fn theme -> str
                A function that generates html for a given theme

            style: fn theme -> str
                A function that generates css for a given theme

            aux: path<directory>
                Auxilary directory to merge into file tree (eg. images, js)
*/

{ pkgs, lib, extlib, ... }:

let
    withDefault = extlib.withDefault;

    # TODO : More stylesheets?
    # TODO : Does this work w/ oft fonts?
    forceFontStylesheet = activeTheme: pkgs.writeTextFile {
        name = "qutebrowser_force_font.css";
        text = "* { font-family: '${activeTheme.fontMono}' !important";
    };

    mergedStartPage = startPage: activeTheme: let
        startSource = pkgs.writeText "qutebrowser_startpage.html" (startPage.source activeTheme);
        startStyle = pkgs.writeText "qutebrowser_startpage.css" (startPage.style activeTheme);
    in pkgs.symlinkJoin {
        name = "qutebrowser_start_page";
        paths = [ startSource startStyle ] ++ (if (startPage ? "aux") then [ startPage.aux ] else []);
    };
in {
    attrpath = [ "programs" "qutebrowser" "settings" ];

    realise = activeTheme: integrationConfig: {
        tabs = {
            favicons.show = if (withDefault integrationConfig [ "tabIcons" ] false) then "always" else "never";

            position = withDefault integrationConfig [ "tabPosition" ] "top";
        };

        colors = {
            completion = {
                category = {
                    bg = "#${activeTheme.colour.mainBg}";
                    fg = "#${activeTheme.colour.mainFg}";
                    border = {
                        bottom = "#${activeTheme.colour.mainBg}";
                        top = "#${activeTheme.colour.mainBg}";
                    };
                };

                even.bg = "#${activeTheme.colour.mainBg}";
                odd.bg = "#${activeTheme.colour.mainBg}";

                fg = "#${activeTheme.colour.mainFg}";
                match.fg = "#${activeTheme.colour.mainFg}";

                item.selected = {
                    bg = "#${activeTheme.colour.accentBg}";
                    fg = "#${activeTheme.colour.accentFg}";
                    border = {
                        bottom = "#${activeTheme.colour.accentBg}";
                        top = "#${activeTheme.colour.accentBg}";
                    };

                    match.fg = "#${activeTheme.colour.accentFg}";
                };

                scrollbar = {
                    bg = "#${activeTheme.colour.accentBg}";
                    fg = "#${activeTheme.colour.accentFg}";
                };
            };

            contextmenu = {
                disabled = {
                    bg = "#${activeTheme.colour.mainBg}";
                    fg = "#${activeTheme.colour.mainFg}";
                };

                menu = {
                    bg = "#${activeTheme.colour.mainBg}";
                    fg = "#${activeTheme.colour.mainFg}";
                };

                selected = {
                    bg = "#${activeTheme.colour.accentBg}";
                    fg = "#${activeTheme.colour.accentFg}";
                };
            };

            downloads = {
                bar.bg = "#${activeTheme.colour.accentBg}";

                error = {
                    bg = "#${activeTheme.colour.mainBg}";
                    fg = "#${activeTheme.colour.mainFg}";
                };

                start = {
                    bg = "#${activeTheme.colour.mainBg}";
                    fg = "#${activeTheme.colour.mainFg}";
                };

                stop = {
                    bg = "#${activeTheme.colour.accentBg}";
                    fg = "#${activeTheme.colour.accentFg}";
                };
            };

            hints = {
                bg = "#${activeTheme.colour.mainBg}";
                fg = "#${activeTheme.colour.mainFg}";
                match.fg = "#${activeTheme.colour.mainFg}";
            };

            keyhint = {
                bg = "#${activeTheme.colour.mainBg}";
                fg = "#${activeTheme.colour.mainFg}";
                suffix.fg = "#${activeTheme.colour.mainFg}";
            };

            messages = {
                error = {
                    bg = "#${activeTheme.colour.accentBg}";
                    fg = "#${activeTheme.colour.accentFg}";
                    border = "#${activeTheme.colour.accentFg}";
                };

                warning = {
                    bg = "#${activeTheme.colour.accentBg}";
                    fg = "#${activeTheme.colour.accentFg}";
                    border = "#${activeTheme.colour.accentFg}";
                };

                info = {
                    bg = "#${activeTheme.colour.mainBg}";
                    fg = "#${activeTheme.colour.mainFg}";
                    border = "#${activeTheme.colour.mainFg}";
                };
            };

            prompts = {
                bg = "#${activeTheme.colour.mainBg}";
                fg = "#${activeTheme.colour.mainFg}";
                border = "#${activeTheme.colour.mainFg}";

                selected = {
                    bg = "#${activeTheme.colour.accentBg}";
                    fg = "#${activeTheme.colour.accentFg}";
                };
            };

            statusbar = {
                caret = {
                    bg = "#${activeTheme.colour.mainBg}";
                    fg = "#${activeTheme.colour.mainFg}";

                    selection = {
                        bg = "#${activeTheme.colour.accentBg}";
                        fg = "#${activeTheme.colour.accentFg}";
                    };
                };

                command = {
                    bg = "#${activeTheme.colour.mainBg}";
                    fg = "#${activeTheme.colour.mainFg}";

                    private = {
                        bg = "#${activeTheme.colour.mainBg}";
                        fg = "#${activeTheme.colour.mainFg}";
                    };
                };

                normal = {
                    bg = "#${activeTheme.colour.mainBg}";
                    fg = "#${activeTheme.colour.mainFg}";
                };

                private = {
                    bg = "#${activeTheme.colour.mainBg}";
                    fg = "#${activeTheme.colour.mainFg}";
                };

                insert = {
                    bg = "#${activeTheme.colour.mainBg}";
                    fg = "#${activeTheme.colour.mainFg}";
                };

                passthrough = {
                    bg = "#${activeTheme.colour.mainBg}";
                    fg = "#${activeTheme.colour.mainFg}";
                };

                url = {
                    error.fg = "#${activeTheme.colour.mainFg}";
                    hover.fg = "#${activeTheme.colour.mainFg}";
                    success = {
                        http.fg = "#${activeTheme.colour.mainFg}";
                        https.fg = "#${activeTheme.colour.mainFg}";
                    };
                    warn.fg = "#${activeTheme.colour.mainFg}";

                    fg = "#${activeTheme.colour.mainFg}";
                };

                progress.bg = "#${activeTheme.colour.mainBg}";
            };

            tabs = {
                bar.bg = "#${activeTheme.colour.mainBg}";

                even = {
                    bg = "#${activeTheme.colour.mainBg}";
                    fg = "#${activeTheme.colour.mainFg}";
                };

                odd = {
                    bg = "#${activeTheme.colour.mainBg}";
                    fg = "#${activeTheme.colour.mainFg}";
                };

                pinned = {
                    even = {
                        bg = "#${activeTheme.colour.mainBg}";
                        fg = "#${activeTheme.colour.mainFg}";
                    };

                    odd = {
                        bg = "#${activeTheme.colour.mainBg}";
                        fg = "#${activeTheme.colour.mainFg}";
                    };

                    selected = {
                        even = {
                            bg = "#${activeTheme.colour.accentBg}";
                            fg = "#${activeTheme.colour.accentFg}";
                        };

                        odd = {
                            bg = "#${activeTheme.colour.accentBg}";
                            fg = "#${activeTheme.colour.accentFg}";
                        };
                    };
                };

                indicator.system = "none";

                selected = {
                    even = {
                        bg = "#${activeTheme.colour.accentBg}";
                        fg = "#${activeTheme.colour.accentFg}";
                    };

                    odd = {
                        bg = "#${activeTheme.colour.accentBg}";
                        fg = "#${activeTheme.colour.accentFg}";
                    };
                };
            };

            tooltip = {
                bg = "#${activeTheme.colour.mainBg}";
                fg = "#${activeTheme.colour.mainFg}";
            };
        };

        fonts = {
            default_family = activeTheme.fontMono;
            default_size = "${toString activeTheme.fontSizeLarge}px";

            web.size = {
                default_fixed = activeTheme.fontSizeLarge;
                minimum = activeTheme.fontSizeSmall;
                minimum_logical = activeTheme.fontSizeSmall;
            };
        };

        content.user_stylesheets = if (withDefault integrationConfig [ "forceFont" ] false) then [
            "${(forceFontStylesheet activeTheme)}"
        ] else [];

        url = if (integrationConfig ? "startPage") then let
            inherit (integrationConfig) startPage;
            startPageDrv = mergedStartPage startPage activeTheme;
            startPageUri = "file://${startPageDrv}/qutebrowser_startpage.html";
        in {
            start_pages = [ startPageUri ];
            default_page = startPageUri;
        } else {};
    };
}

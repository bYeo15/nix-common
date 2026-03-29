/*
    renix qutebrowser integration:
    inherits colours and font from activeTheme

    Integration config is;

        tabIcons: bool optional
            show tab icons?

        tabPosition: str optional
            one of "top" "bottom" "left" "right"
*/

{ extlib, ... }:

let
    withDefault = extlib.withDefault;
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
    };
}

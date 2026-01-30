{ inputs, config, lib, pkgs, extlib, ... } @ moduleArgs:

let
    palette = with lib; with types; submodule {
        options = {
            mainBg = mkOption {
                type = str;
                description = "Palette primary background colour";
            };
            mainFg = mkOption {
                type = str;
                description = "Palette primary foreground colour";
            };
            accentBg = mkOption {
                type = str;
                description = "Palette secondary background colour";
            };
            accentFg = mkOption {
                type = str;
                description = "Palette secondary foreground colour";
            };
        };
    };
    theme = with lib; with types; submodule {
        options = {
            colour = mkOption {
                type = palette;
                description = "Hex RGB palette used for full-colour applications";
            };
            termColour = mkOption {
                type = palette;
                description = "Terminal ANSI-256 colour palette";
            };
            fontMono = mkOption {
                type = str;
                description = "The default monospace font";
            };
            fontSerif = mkOption {
                type = str;
                description = "The default serif font";
            };
            fontSans = mkOption {
                type = str;
                description = "The default sans-serif font";
            };
            fontSizeLarge = mkOption {
                type = int;
                description = "The default large font size";
                default = 15;
            };
            fontSizeNormal = mkOption {
                type = int;
                description = "The default normal font size";
                default = 12;
            };
            fontSizeSmall = mkOption {
                type = int;
                description = "The default small font size";
                default = 10;
            };

            integrations = mkOption {
                type = attrsof attrs;
                description = "A set of integration attribute sets";
                default = { };
            };
        };
    };

    cfg = config.renix;

    integrations = import ./integrations moduleArgs;
in {
    options.renix = with lib; with types; {
        enable = mkEnableOption "renix styling system";

        activeTheme = mkOption {
            type = theme;
            description = "The theme actively in use";
        };
        themes = mkOption {
            type = attrsOf theme;
            description = "A set of available themes";
            default = { };
        };
    };

    config = lib.mkIf cfg.enable (integrations.realise cfg.activeTheme);
}

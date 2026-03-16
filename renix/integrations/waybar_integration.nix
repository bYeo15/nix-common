/*
    renix waybar integration:
    Inherits colours and font (by default) from activeTheme

    Integration config is;

        barMode: str optional
            Sets the mode of the main bar

        barPosition: str optional
            Sets the location of the main bar

        barHeight: int optional
            Sets the height of the main bar

        barLMargin: int optional
            sets the left margin of the bar

        barRMargin: int optional
            sets the right margin of the bar

        barTMargin: int optional
            sets the top margin of the bar

        barBMargin: int optional
            sets the bottom margin of the bar

        moduleSpacing: int optional
            Sets the spacing between modules

        leftModules: list<attrs> optional
            A list (in order) of modules to display on the left of the bar

            There cannot be overlap in the moduleNames for leftModules, rightModules
            and centreModules

            Each module should take the form:
            {
                moduleName = <str : the name of the module (can be a builtin)>
                ... # module-specific config (as in HomeManager)
            }

        rightModules: list<attrs> optional
            As with leftModules

        centreModules: list<attrs> optional
            As with centreModules

        additionalBars: attrs<attrs<*>> optional
            Explicit declaration of additional bars
            Uses the same format as the integrationConfig, without the
            additionalBars or style attributes

        style: fn theme -> str optional
            A function activeTheme -> waybar css
            Overrides the default style (which is very minimal)
*/

{ lib, extlib, ... }:

let
    withDefault = extlib.withDefault;
    toBar = config: let
        lModules = withDefault config [ "leftModules" ] [];
        rModules = withDefault config [ "rightModules" ] [];
        cModules = withDefault config [ "centreModules" ] [];
    in {
        layer = "top";
        mode = withDefault config [ "barMode" ] "dock";
        position = withDefault config [ "barPosition" ] "top";
        height = withDefault config [ "barHeight" ] 40;
        spacing = withDefault config [ "moduleSpacing" ] 20;

        margin-left = withDefault config [ "barLMargin" ] 0;
        margin-right = withDefault config [ "barRMargin" ] 0;
        margin-top = withDefault config [ "barTMargin" ] 0;
        margin-bottom = withDefault config [ "barBMargin" ] 0;

        modules-left = builtins.map (x: x.moduleName) lModules;
        modules-right = builtins.map (x: x.moduleName) rModules;
        modules-center = builtins.map (x: x.moduleName) cModules;
    } //
    # Generate module definitions
    (
        lib.attrsets.genAttrs' (lModules ++ rModules ++ cModules)
                               (s: lib.nameValuePair (s.moduleName) (builtins.removeAttrs s [ "moduleName" ]))
    );
in {
    attrpath = [ "programs" "waybar" ];

    realise = activeTheme: integrationConfig: {
        settings = {
            mainBar = toBar integrationConfig;
        } //
        # Generate additional bars
        (
            builtins.mapAttrs (name: value: toBar value)
                              (withDefault integrationConfig [ "additionalBars" ] { })
        );

        style = if integrationConfig ? "style" then (integrationConfig.style activeTheme) else ''
            * {
                font-family: ${activeTheme.fontMono};
                font-size: ${toString activeTheme.fontSizeLarge}px;
            }

            button {
                border: none;
                border-radius: 0;
                padding: 0px 10px;
            }

            window#waybar, tooltip {
                background-color: #${activeTheme.colour.mainBg};
                color: #${activeTheme.colour.mainFg};
            }

            .modules-right {
                margin-right: 10px;
            }

            #workspaces button.focused:hover {
                color: #${activeTheme.colour.mainFg};
            }

            #workspaces button.focused, #workspaces button.urgent {
                background-color: #${activeTheme.colour.accentBg};
                color: #${activeTheme.colour.accentFg};
            }
        '';
    };
}

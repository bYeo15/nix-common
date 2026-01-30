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
            Any modules declared inside the additional bars should be
            unique

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
        height = withDefault config [ "barHeight" ] 30;
        spacing = withDefault config [ "moduleSpacing" ] 5;

        modules-left = builtins.map (x: x.moduleName) lModules;
        modules-right = builtins.map (x: x.moduleName) rModules;
        modules-center = builtins.map (x: x.moduleName) cModules;
    };
in {
    attrpath = [ "programs" "waybar" ];

    realise = activeTheme: integrationConfig: let
        lModules = withDefault integrationConfig [ "leftModules" ] [];
        rModules = withDefault integrationConfig [ "rightModules" ] [];
        cModules = withDefault integrationConfig [ "centreModules" ] [];
    in {
        settings = {
            mainBar = toBar integrationConfig;
        } //
        # Generate additional bars
        (
            builtins.mapAttrs (name: value: toBar value)
                              (withDefault integrationConfig [ "additionalBars" ] { })
        ) //
        # Collect module definitions from additional bars
        (
            lib.attrsets.genAttrs' (
                                       lib.foldlAttrs (acc: name: value: acc ++
                                                                         withDefault value [ "leftModules" ] [] ++
                                                                         withDefault value [ "rightModules" ] [] ++
                                                                         withDefault value [ "centreModules" ] []
                                                      ) [] (withDefault integrationConfig [ "additionalBars" ] { })
                                   )
                                   (s: lib.nameValuePair (s.moduleName) (builtins.removeAttrs s [ "moduleName" ]))
        ) //
        # Collect top-level module definitions (done last to give priority over additional bar overlap)
        (
            lib.attrsets.genAttrs' (lModules ++ rModules ++ cModules)
                                   (s: lib.nameValuePair (s.moduleName) (builtins.removeAttrs s [ "moduleName" ]))
        );

        style = if integrationConfig ? "style" then (integrationConfig.style activeTheme) else ''
            * {
                font-family: ${activeTheme.fontMono};
                font-size: ${toString activeTheme.fontSizeLarge};

                background-color: transparent;
                color: #${activeTheme.colour.mainFg};
            }

            window#waybar {
                background-color: #${activeTheme.colour.mainBg};
                color: #${activeTheme.colour.mainFg};
            }

            #workspaces button:focused {
                background-color: #${activeTheme.colour.accentBg};
                color: #${activeTheme.colour.accentFg};
            }

            #workspaces button:urgent {
                background-color: #${activeTheme.colour.accentBg};
                color: #${activeTheme.colour.accentFg};
            }
        '';
    };
}

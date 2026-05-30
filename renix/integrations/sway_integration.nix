/*
    renix sway integration:
    Inherits colours and font from activeTheme

    Integration config is;

        gaps: attrset<*> optional
            An attribute set of the form used by Home Manager's
            sway config

        hideEdgeBorders: str optional
            Same as the Home Manager attribute

        windowBorder: int optional
            The border size for non-floating windows

        windowTitle: bool optional
            Enable titlebar for non-floating windows?

        floatingBorder: int optional
            The border size for floating windows

        floatingTitle: bool optional
            Enable titlebar for floating windows?

        background: path optional
            The path to the desktop background image
            If not given, solid colour is used

        startup: list optional
            A list of applications to launch on startup (same format as Home Manager)

        windowRules: list optional
            A list of window rules to apply (same format as Home Manager)

        fragment: attrset optional
            enable: bool
                Use a shader as a background?

            command: str
                Base command to use, plus any shared arguments

            shader: fn theme -> str
                A function creating a themed fragment shader

            displays: list<str>
                List of per-display arguments (typically, display name + per-display flags)

            compose: fn str -> fn path -> fn str -> str
                Function that builds a full background command from command, shader and display
                Defaults to concat `{command} {display} {shader}`
*/

{ lib, pkgs, extlib, ... }:

let
    withDefault = extlib.withDefault;

    defaultCompose = command: shader: display: "${command} ${display} ${shader}";

    mkShader = activeTheme: fragmentDef: pkgs.writeText "fragment" (fragmentDef activeTheme);
in {
    attrpath = [ "wayland" "windowManager" "sway" "config" ];
    realise = activeTheme: integrationConfig: {
        colors = {
            focused = {
                background = "#${activeTheme.colour.accentBg}";
                border = "#${activeTheme.colour.accentFg}";
                text = "#${activeTheme.colour.accentBg}";
                indicator = "#${activeTheme.colour.accentBg}";
                childBorder = "#${activeTheme.colour.accentBg}";
            };
            focusedInactive = {
                background = "#${activeTheme.colour.mainBg}";
                border = "#${activeTheme.colour.mainFg}";
                text = "#${activeTheme.colour.mainBg}";
                indicator = "#${activeTheme.colour.mainBg}";
                childBorder = "#${activeTheme.colour.mainBg}";
            };
            unfocused = {
                background = "#${activeTheme.colour.mainBg}";
                border = "#${activeTheme.colour.mainFg}";
                text = "#${activeTheme.colour.mainBg}";
                indicator = "#${activeTheme.colour.mainBg}";
                childBorder = "#${activeTheme.colour.mainBg}";
            };
            urgent = {
                background = "#${activeTheme.colour.accentBg}";
                border = "#${activeTheme.colour.accentFg}";
                text = "#${activeTheme.colour.accentBg}";
                indicator = "#${activeTheme.colour.accentBg}";
                childBorder = "#${activeTheme.colour.accentBg}";
            };
        };

        fonts = {
            names = [ "\"${activeTheme.fontMono}\"" "mono" ];
            size = activeTheme.fontSizeNormal + 0.0;    # Promote to float
        };

        gaps = withDefault integrationConfig [ "gaps" ] null;

        window = {
            border = withDefault integrationConfig [ "windowBorder" ] 0;
            titlebar = withDefault integrationConfig [ "windowTitle" ] false;
            hideEdgeBorders = withDefault integrationConfig [ "hideEdgeBorders" ] "smart";

            commands = withDefault integrationConfig [ "windowRules" ] [ ];
        };

        floating = {
            border = withDefault integrationConfig [ "floatingBorder" ] 0;
            titlebar = withDefault integrationConfig [ "floatingTitle" ] false;
        };

        output = {
            "*" = {
                bg = if (integrationConfig ? "background")
                    then "${integrationConfig.background} fill"
                    else "#${activeTheme.colour.mainBg} solid_color";
            };
        };

        startup = (withDefault integrationConfig [ "startup" ] [ ]) ++ (if integrationConfig ? "fragment" && integrationConfig.fragment.enable then with integrationConfig; (lib.map (
            v: {
                always = false;
                command = (withDefault fragment [ "compose" ] defaultCompose)
                    fragment.command (mkShader activeTheme fragment.shader) v;
            }
        ) fragment.displays) else [ ]);
    };
}

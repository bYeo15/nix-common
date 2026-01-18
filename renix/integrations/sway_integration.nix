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

        background: path
            The path to the desktop background image

        fragment: attrset optional
            Requires `glpaper` to function (not automatically enabled)

            enable: bool
                Use a shader as a background?

            shader: path
                The path to the shader to use

            displays: list<str>
                The names of the displays to render the shader to
*/

{ lib, pkgs, extlib, ... }:

let
    withDefault = extlib.withDefault;
in {
    attrpath = [ "wayland" "windowManager" "sway" "config" ];
    realise = activeTheme: integrationConfig: {
        colors = {
            focused = {
                background = "#${activeTheme.colour.accentBg}";
                border = "#${activeTheme.colour.accentBg}";
                text = "#${activeTheme.colour.accentFg}";
                indicator = "#${activeTheme.colour.accentBg}";
                childBorder = "#${activeTheme.colour.accentBg}";
            };
            focusedInactive = {
                background = "#${activeTheme.colour.mainBg}";
                border = "#${activeTheme.colour.mainBg}";
                text = "#${activeTheme.colour.mainFg}";
                indicator = "#${activeTheme.colour.mainBg}";
                childBorder = "#${activeTheme.colour.mainBg}";
            };
            unfocused = {
                background = "#${activeTheme.colour.mainBg}";
                border = "#${activeTheme.colour.mainBg}";
                text = "#${activeTheme.colour.mainFg}";
                indicator = "#${activeTheme.colour.mainBg}";
                childBorder = "#${activeTheme.colour.mainBg}";
            };
            urgent = {
                background = "#${activeTheme.colour.accentBg}";
                border = "#${activeTheme.colour.accentBg}";
                text = "#${activeTheme.colour.accentFg}";
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
        };

        floating = {
            border = withDefault integrationConfig [ "floatingBorder" ] 0;
            titlebar = withDefault integrationConfig [ "floatingTitle" ] false;
        };

        output = { "*" = { bg = "${integrationConfig.background} fill"; }; };

        startup = if integrationConfig ? fragment && integrationConfig.fragment.enable then (builtins.map (
            v: { always = false; command = "${lib.getExe pkgs.glpaper} -F ${v} ${integrationConfig.fragment.shader}"; }
        ) integrationConfig.fragment.displays) else [ ];
    };
}

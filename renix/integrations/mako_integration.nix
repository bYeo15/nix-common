/*
    renix mako integration:
    Does not modify non-visual settings (timeouts, etc.)
    Inherits colours and font from activeTheme

    Integration config is;

        borderRadius: int optional
            Radius for notification borders

        anchor: str
            Default anchor position for notifications

        actionableAnchor: str optional
            Anchor position for actionable notifications

        format: str optional
            Format string for notification output
*/

{ lib, pkgs, extlib, ... }:

let
    withDefault = extlib.withDefault;
in {
    attrpath = [ "services" "mako" "settings" ];
    realise = activeTheme: integrationConfig: {
        background-color = "#${activeTheme.colour.mainBg}";
        text-color = "#${activeTheme.colour.mainFg}";

        border-color = "#${activeTheme.colour.accentFg}";
        border-radius = withDefault integrationConfig [ "borderRadius" ] 0;

        font = "${activeTheme.fontMono} ${toString activeTheme.fontSizeNormal}";

        anchor = integrationConfig.anchor;
        format = withDefault integrationConfig [ "format" ] "<b>[ %a : %s ]</b>\\n %b";

        "actionable=true" = {
            anchor = withDefault integrationConfig [ "actionableAnchor" ] integrationConfig.anchor;
        };
    };
}

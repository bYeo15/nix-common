/*
    renix helix integration
    Inherits colours from activeTheme

    Integration config is;

        helixBase: str optional
            Sets the base theme to extend with current colours
*/

{ lib, extlib, ... }:

let
    withDefault = extlib.withDefault;
in {
    attrpath = [ "programs" "helix" ];

    realise = activeTheme: integrationConfig: {
        settings.theme = "renix";
        themes.renix = {
            inherits = withDefault integrationConfig [ "helixBase" ] "base16_transparent";
            "ui.background" = "#${activeTheme.colour.mainBg}";
            "ui.text" = "#${activeTheme.colour.mainFg}";
            "ui.virtual.ruler" = "none";
        };
   };
}

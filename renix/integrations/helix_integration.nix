/*
    renix helix integration
    Inherits colours from activeTheme

    Integration config is;

        helixBase: str optional
            Sets the base theme to extend with current colours
*/

{ lib, pkgs, extlib, ... }:

let
    withDefault = extlib.withDefault;
in {
    attrpath = [ "programs" "helix" "themes" "renix" ];

    realise = activeTheme: integrationConfig: {
        inherits = withDefault integrationConfig [ "helixBase" ] "base16_transparent";
        "ui.background" = "#${activeTheme.colour.mainBg}";
        "ui.text" = "#${activeTheme.colour.mainFg}";
        "ui.virtual.ruler" = "none";
   };
}

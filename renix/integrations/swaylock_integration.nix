/*
    renix swaylock integration:
    Inherits colours and font from activeTheme

    Integration config is;

        background: path
            The background image to use on the lockscreen
*/

{ lib, pkgs, extlib, ... }:

let
    withDefault = extlib.withDefault;
in {
    attrpath = [ "programs" "swaylock" "settings" ];
    realise = activeTheme: integrationConfig: {
        color = activeTheme.colour.mainBg;
        inside-color = activeTheme.colour.mainBg;
        inside-clear-color = activeTheme.colour.accentBg;
        inside-wrong-color = activeTheme.colour.mainBg;
        line-color = activeTheme.colour.accentBg;
        ring-color = activeTheme.colour.accentFg;
        separator-color = activeTheme.colour.accentBg;
        text-color = activeTheme.colour.mainFg;

        image = "${integrationConfig.background}";

        font = activeTheme.fontMono;
        font-size = activeTheme.fontSizeLarge;
    };
}

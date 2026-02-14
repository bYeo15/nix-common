/*
    renix rofi integration:
    Inherits base colour and font from activeTheme
    Relatively minimal other than that, essentially just directly mirroring rofi's config syntax

    Integration config is;

        baseStyle: fn theme -> attrset
            Style to apply to all elements ("*")

        elemStyle: fn theme -> attrset
            Attribute set of element -> style attribute set (follows Home Manager rofi syntax)
*/

{ lib, extlib, ... }:

let
    withDefault = extlib.withDefault;
    # Directly spin rofi's `mkLiteral` to avoid any import weirdness
    mkLiteral = value: { _type = "literal"; inherit value; };
in {
    attrpath = [ "programs" "rofi" "theme" ];
    realise = activeTheme: integrationConfig: {
        "*" = {
            font = "${activeTheme.fontMono} ${toString activeTheme.fontSizeNormal}";

            background-color = mkLiteral "transparent";
            text-color = mkLiteral "#${activeTheme.colour.mainFg}";
        } // ((withDefault integrationConfig [ "baseStyle" ] (_: { })) activeTheme);
    } // ((withDefault integrationConfig [ "elemStyle" ] (_: { })) activeTheme);
}

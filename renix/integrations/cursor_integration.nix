/*
    renix cursor integration:
    Note that sway support is determined by the enabling of the sway integration

    Integration config is;

        cursorName: str
            The name of the cursor icon to use within the given package

        cursorPackage: package
            The package providing the cursor

        cursorSize: int
            The size to use for the cursor
*/

{ lib, pkgs, extlib, ... }:

let
    withDefault = extlib.withDefault;
in {
    attrpath = [ "home" "pointerCursor" ];
    realise = activeTheme: integrationConfig: {
        enable = true;

        name = integrationConfig.cursorName;
        package = integrationConfig.cursorPackage;
        size = withDefault integrationConfig [ "cursorSize" ] 24;

        sway.enable = activeTheme.integrations ? "sway" && activeTheme.integrations.sway.enable;
        gtk.enable = true;
    };
}

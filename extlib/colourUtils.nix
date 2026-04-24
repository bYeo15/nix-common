{ lib, ... }:

{
    hexToRgb = hexRepr: let
        hexMap = {
            "0" = 0;
            "1" = 1;
            "2" = 2;
            "3" = 3;
            "4" = 4;
            "5" = 5;
            "6" = 6;
            "7" = 7;
            "8" = 8;
            "9" = 9;
            "a" = 10;
            "b" = 11;
            "c" = 12;
            "d" = 13;
            "e" = 14;
            "f" = 15;
            "A" = 10;
            "B" = 11;
            "C" = 12;
            "D" = 13;
            "E" = 14;
            "F" = 15;
        };

        hexSliceToInt = slice: hexMap."${lib.elemAt slice 0}" * 16 + hexMap."${lib.elemAt slice 1}";

        hexSlice = i: lib.stringToCharacters (lib.substring i 2 hexRepr);
        hexChars = lib.stringToCharacters hexRepr;
        hexLen = lib.stringLength hexRepr;
    in assert (lib.assertMsg
        (
            hexLen == 6 &&
            (lib.all (c: lib.hasAttr c hexMap) hexChars)
        )
        "Hex colour '${hexRepr}' is not of the format rrggbb"
    ); {
        r = hexSliceToInt (hexSlice 0);
        g = hexSliceToInt (hexSlice 2);
        b = hexSliceToInt (hexSlice 4);
    };

    rgb255ToFloat = rgb: {
        r = rgb.r / 255.0;
        g = rgb.g / 255.0;
        b = rgb.b / 255.0;
    };

    rgbFloatToVec4 = rgb: "vec4(${lib.toString rgb.r}, ${lib.toString rgb.g}, ${lib.toString rgb.b}, 1.0)";
}

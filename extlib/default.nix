{ lib, ... }:

{
    filterTagged = import ./filterTagged.nix { inherit lib; };
    extractAttr = import ./extractAttr.nix { inherit lib; };
    withDefault = import ./withDefault.nix { inherit lib; };
}

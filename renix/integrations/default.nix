{ lib, pkgs, extlib,  ... }:

let
    availableIntegrations = lib.attrsets.genAttrs [
        "cursor"
        "helix"
        "mako"
        "qutebrowser"
        "rofi"
        "sway"
        "swaylock"
        "waybar"
    ] (name: import (./. + "/${name}_integration.nix") { inherit lib pkgs extlib; } );
in {
    realise = import ./realise.nix { inherit lib pkgs extlib; } availableIntegrations;
}

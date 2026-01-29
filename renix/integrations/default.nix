{ config, lib, extlib,  ... } @ moduleArgs:

rec {
    realise = import ./realise.nix moduleArgs availableIntegrations;
    availableIntegrations = lib.attrsets.genAttrs [
        "cursor"
        "helix"
        "mako"
        "rofi"
        "sway"
        "swaylock"
        "waybar"
    ] (name: import (./. + "/${name}_integration.nix") moduleArgs);
}

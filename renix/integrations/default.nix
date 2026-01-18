{ config, lib, extlib,  ... } @ moduleArgs:

rec {
    realise = import ./realise.nix moduleArgs availableIntegrations;
    availableIntegrations = lib.attrsets.genAttrs [
        "cursor"
        "mako"
        "rofi"
        "sway"
        "swaylock"
        "waybar"
    ] (name: import (./. + "/${name}_integration.nix") moduleArgs);
}

{ lib, ... }:
    set: path: default:
        if (lib.hasAttrByPath path set) then (lib.getAttrFromPath path set) else default

{ lib, ... }:
    set: path: default:
        if (lib.hasAttrByPath path set) then (lib.getAttrByPath path set) else default

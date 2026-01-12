{ lib, ... }:

field: set:
    # Extract field "field" from v
    lib.mapAttrs (n: v: v."${field}") set

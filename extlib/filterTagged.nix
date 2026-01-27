{ lib, ... }:

attribute: tags: set:
    # Extract the given attribute from v
    lib.mapAttrs (n: v: v."${attribute}") (
        # Select only attrsets where at least one of the provided tags is present
        lib.filterAttrs (n: v:
            lib.any (tag: builtins.elem tag tags) v.tags
        ) set
    )

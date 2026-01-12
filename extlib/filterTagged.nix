{ lib, ... }:

attributes: tags: set:
    # Extract each given attribute from v
    lib.mapAttrs (n: v: lib.attrsets.getAttrs attributes v) (
        # Select only attrsets where at least one of the provided tags is present
        lib.filterAttrs (n: v:
            lib.any (tag: builtins.elem tag tags) v.tags
        ) set
    )

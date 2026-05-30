final: prev: let
    src_patches = [
        ./waybar_ipc_no_passthru.patch
    ];
in {
       waybar = prev.waybar.overrideAttrs (old: {
            patches = (old.patches or [ ]) ++ src_patches;
       });
}

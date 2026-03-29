{ config, lib, pkgs, ... } @ moduleArgs:

let
    makeScript = import ./make_script.nix moduleArgs;
    allScripts = [
        "devsh"
        "hsearch"
        "quicksearch"
        "volctl"
    ];
    scriptListing = scripts: lib.map (v:
       assert (lib.assertMsg
           (lib.lists.elem v allScripts)
           ("Script '${v}' unknown, should be among:\n" + (lib.concatMapStrings (v: v + "\n") allScripts)));
       makeScript (import (./. + "/${v}.nix"))
    ) scripts;

    cfg = config.extscripts;
in {
    options.extscripts = with lib; with types; {
        enable = mkEnableOption "extra scripts";

        scripts = mkOption {
            type = listOf str;
            description = "A list of scripts to enable (by name)";
            default = [ ];
        };
    };

    config.home.packages = lib.mkIf cfg.enable (scriptListing cfg.scripts);
}

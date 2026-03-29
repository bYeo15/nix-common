{ config, lib, pkgs, ... } @ moduleArgs: scriptDefinition: let
    script = scriptDefinition moduleArgs;
    completionPkg = pkgs.writeTextFile {
        name = "${script.name}.bash";
        text = script.completions;
        destination = "/share/bash-completion/${script.name}.bash";
    };
    scriptPkg = pkgs.writeShellApplication {
        name = script.name;
        text = script.src;
        runtimeInputs = script.deps;
        excludeShellChecks = if script ? skipChecks then script.skipChecks else [ ];
    };
in pkgs.symlinkJoin {
    inherit (scriptPkg) meta;
    name = script.name;
    paths = [ scriptPkg ] ++ lib.optionals (script ? completions) [ completionPkg ];
}

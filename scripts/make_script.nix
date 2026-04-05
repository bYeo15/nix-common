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
        bashOptions = [ ];
    };
in (pkgs.symlinkJoin {
    inherit (scriptPkg) meta;
    name = script.name;
    paths = [ scriptPkg ] ++ lib.optionals (script ? completions) [ completionPkg ];
    postBuild = lib.optionalString (script ? completions) ''
        installShellCompletion --bash "$out/share/bash-completion/${script.name}.bash"
    '';
}).overrideAttrs (final: prev: {
    nativeBuildInputs = lib.optionals (script ? completions) [ pkgs.installShellFiles ];
})

{ config, lib, pkgs, ... }:

{
    config.devshells = {
        default = {
            template = ./emptyShell.nix;
        };

        python = {
            template = ./pythonShell.nix;
            # Automatically initialise the virtual environment for the python project
            hook = ''
                nix run nixpkgs#python3 -- -m venv ./venv
            '';
        };

        c = {
            template = ./cShell.nix;
        };
    };
}

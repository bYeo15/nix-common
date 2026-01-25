{ config, lib, pkgs, ... }:

{
    imports = [
        ./ageSecretFiles.nix
        ./devshells.nix
        ./netConn.nix
        ./sshConn.nix
    ];
}

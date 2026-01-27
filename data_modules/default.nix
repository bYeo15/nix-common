{ config, lib, pkgs, ... }:

{
    imports = [
        ./devshells.nix
        ./netConn.nix
        ./sshConn.nix
    ];
}

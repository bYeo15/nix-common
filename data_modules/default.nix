{ config, lib, pkgs, ... }:

{
    imports = [
        ./browserData.nix
        ./devshells.nix
        ./netConn.nix
        ./sshConn.nix
    ];
}

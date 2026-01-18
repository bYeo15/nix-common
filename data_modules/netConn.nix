{ inputs, config, lib, pkgs, ... }:

let
    connection = with lib; with types; submodule {
        options = {
            tags = mkOption {
                type = listOf (str);
                description = "Tags for this connection";
            };
            profile = mkOption {
                type = attrs;
                description = "Profile fitting the format of `networking.networkmanager.ensureProfiles.profile";
            };
        };
    };
in {
    options.netConn = with lib; with types; {
        connections = mkOption {
            type = attrsOf (connection);
            description = "A set of available tagged connections";
            default = { };
        };
        dhcpMappings = mkOption {
            type = attrsOf (str);
            description = "Mappings <device name> -> <subnet ip>";
            default = { };
        };
        dhcpConfig = mkOption {
            type = listOf (str);
            description = "DHCP config in a format matching your DHCP server of choice";
            default = [];
        };
    };
}

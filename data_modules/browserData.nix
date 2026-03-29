{ config, lib, pkgs, ... }:

let
    searchEngine = with lib; with types; submodule {
        options = {
            tags = mkOption {
                type = listOf str;
                description = "Tags for this search engine";
                default = [ "untagged" ];
            };
            template = mkOption {
                description = "Function from search token to format url";
            };
            symbol = mkOption {
                type = str;
                description = "Shorthand symbol for this search engine";
            };
        };
    };
    bookmark = with lib; with types; submodule {
        options = {
            url = mkOption {
                type = str;
                description = "The url for this bookmark";
            };
            keyword = mkOption {
                type = nullOr str;
                description = "The keyword for this bookmark";
                default = null;
            };
            tags = mkOption {
                type = listOf str;
                description = "Tags for this bookmark";
                default = [ ];
            };
            group = mkOption {
                type = nullOr str;
                description = "Group for this bookmark";
                default = null;
            };
        };
    };
in {
    options.browserData = with lib; with types; {
        searchEngines = mkOption {
            type = attrsOf searchEngine;
            description = "A set of available search engines";
            default = { };
        };

        bookmarks = mkOption {
            type = attrsOf bookmark;
            description = "A set of available bookmarks";
            default = { };
        };
    };
}

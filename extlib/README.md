# `extlib`

An extension of the base Nix standard library, adding more utilities.


## `extractAttr`

Extracts a given attribute from an attribute set of attribute sets.

```
extractAttr
    IN:
        attribute [str]
            The attribute to extract (by name)

        set [attrset<attrset<*>>]
            An attribute set of attribute sets to extract from
            The inner sets must include an attribute with the provided name

    OUT: [attrset<*>]
        The given attribute set, with only the named attribute extracted from each inner set
```

eg.
```
extractAttr "value" {
    attr1 = { tags = [ "a" "b" ]; value = "a"; };
    attr2 = { tags = [ "b" "c" ]; value = "c"; };
} -> { attr1 = "a"; attr2 = "b"; }
```


## `filterTagged`

Filters an attribute set of tagged attribute sets for those matching a given set of tags, and then extracts a given attribute(s) from them.

```
filterTagged
    IN:
        attribute [str]
            The attribute to extract (by name)

        tags [list<str>]
            A list of tags to include in the result

        set [attrset<attrset<*>>]
            An attribute set of attribute sets to filter

    OUT: [attrset<*>]
        The elements of the given attrset that had at least one of the tags given, with only the given attributes
```

eg.
```
filterTagged "value" [ "a" "c" ] {
    attr1 = { tags = [ "a" "b" ]; value = "a"; };
    attr2 = { tags = [ "b" ]; value = "b"; };
    attr3 = { tags = [ "b" "c" ]; value = "c"; };
} -> { attr1 = "a"; attr3 = "c"; };
```


## `withDefault`

Provides either a value from an attribute set, or a given default value

```
withDefault
    IN:
        set [attrset<*>]
            The set to get a value from

        path [list<str>]
            The path to try for the given value

        default [*]
            The default fallback value

    OUT: [*]
        If present, set.path. Otherwise, default
```

eg.
```
withDefault { a = { b = "c"; }; } [ "a" "b" ] "d" -> "c"
withDefault { a = { b = "c"; }: } [ "a" "z" ] "d" -> "d"
```


## `makeHost`

Builds a configuration into an attribute set exposing a derivation, such that it can be passed directly into `nixos-rebuild`.

```
makeHost
    IN:
        host [list<module>]
            A list of top level modules to be used when evaluating the configuration

        args [attrset<*>]
            Arguments to forward to modules (equivalent to `specialArgs`)

    OUT: [attrset<*>]
        An attribute set produced by evaluating the configuration
```


## `makeHome`

Builds a configuration into an attribute set exposing a derivation, such that it could be passed directly into `home-manager` if
the `home-manager` CLI supported custom build targets.
For now, is only useful if you also use my fork of `home-manager` that modifies the standalone CLI to accept custom build targets.

```
makeHome
    IN:
        user [list<module>]
            A list of top level modules to be used when evaluating the configuration

        args [attrset<*>]
            Arguments to forward to modules (equivalent to `extraSpecialArgs`)

    OUT: [attrset<*>]
        An attribute set produced by evaluating the configuration
```

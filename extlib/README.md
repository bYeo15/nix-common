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
        attributes [list<str>]
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
filterTagged [ "value" ] [ "a" "c" ] {
    attr1 = { tags = [ "a" "b" ]; value = "a" };
    attr2 = { tags = [ "b" ]; value = "b" };
    attr3 = { tags = [ "b" "c" ]; value = "c" };
} -> { attr1 = "a"; attr3 = "c" };
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

    OUT:
        If present, set.path. Otherwise, default
```

```
withDefault { a = { b = "c"; }; } [ "a" "b" ] "d" -> "c"
withDefault { a = { b = "c"; }: } [ "a" "z" ] "d" -> "d"
```

# kakoune-toggle-map

This is a kakoune plugin for creating togglable commands. It defines the command `toggle-map` which takes two mappings instead of one. The first mapping is run when toggling on, and the second is run when toggling off.
The toggle-on command is the default mapping.

# Example: [kakoune-hlsearch](https://github.com/krornus/kakoune-hlsearch)

The following will make the key <F3> toggle highlighting of the search regex
```
toggle-map global normal <F3> hlsearch-on hlsearch-off

define-command hlsearch-on %{
    add-highlighter global/hltoggle dynregex '%reg{/}' 0:white,rgb:222222+ub
}

define-command hlsearch-off %{
    remove-highlighter global/hltoggle
}
```

# Install
Place in autoload/ or use [plug.kak](https://github.com/andreyorst/plug.kak).

# plug.kak
If you use plug.kak, any commands which use `toggle-map` should be used in the following fashion
```
plug "krornus/kakoune-toggle-map" %{
    plug "krornus/kakoune-hlsearch" %{
        toggle-map global normal <F3> hlsearch-on hlsearch-off
    }
}
```

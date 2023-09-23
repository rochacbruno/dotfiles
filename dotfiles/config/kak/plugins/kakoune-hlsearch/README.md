# kakoune-hlsearch
Kakoune plugin which adds commands for highlight-search toggling. Can be used with
[kakoune-toggle-map](https://github.com/krornus/kakoune-toggle-map)

# Usage
`toggle-map global normal <F3> hlsearch-on hlsearch-off` or `hlsearch-on`

# Install
Place in autoload/ or use [plug.kak](https://github.com/andreyorst/plug.kak).

# plug.kak
If you use plug.kak, usage in your kakrc should be used in the following fashion
```
plug "krornus/kakoune-toggle-map" %{
    plug "krornus/kakoune-hlsearch" %{
        toggle-map global normal <F3> hlsearch-on hlsearch-off
    }
}
```

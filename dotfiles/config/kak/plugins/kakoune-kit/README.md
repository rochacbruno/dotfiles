# Kit – A Git porcelain inside [Kakoune](https://kakoune.org)

This plugin is far from complete, but not totally useless right now.

So far it’s just a few hooks that coerce the selection onto the file
paths and SHA1s in `:git status -s` and `:git log` buffers. Combine this
with `: … %val{selections}<a-!> …` mappings to create a
selection-oriented Git interface.

## Configuration

Suggested configuration:

``` kak
plug chambln/kakoune-kit config %{
    map global user g ': git status -bs<ret>' -docstring 'git status'
    hook global WinSetOption filetype=git-status %{
        map window normal c ': git commit --verbose '
        map window normal l ': git log --oneline --graph -- <c-x>f'
        map window normal d ': -- %val{selections}<a-!><home> git diff '
        map window normal D ': -- %val{selections}<a-!><home> git diff --cached '
        map window normal a ': -- %val{selections}<a-!><home> git add '
        map window normal A ': -- %val{selections}<a-!><home> terminal git add -p '
        map window normal r ': -- %val{selections}<a-!><home> git reset '
        map window normal R ': -- %val{selections}<a-!><home> terminal git reset -p '
        map window normal o ': -- %val{selections}<a-!><home> git checkout '
    }
    hook global WinSetOption filetype=git-log %{
        map window normal d     ': %val{selections}<a-!><home> git diff '
        map window normal <ret> ': %val{selections}<a-!><home> git show '
        map window normal r     ': %val{selections}<a-!><home> git reset '
        map window normal R     ': %val{selections}<a-!><home> terminal git reset -p '
        map window normal o     ': %val{selections}<a-!><home> git checkout '
    }
}
```

# Surround plugin for Kakoune

## Usage
These commands are exposed to map or alias.
- surround
- change-surround
- delete-surround
- select-surround
- surround-with-tag
- delete-surrounding-tag
- change-surrounding-tag
- select-surrounding-tag

For example,
```
map global normal 'some key' ':surround<ret>'
```
Or you can use user mode like this,
```
declare-user-mode surround
map global surround s ':surround<ret>' -docstring 'surround'
map global surround c ':change-surround<ret>' -docstring 'change'
map global surround d ':delete-surround<ret>' -docstring 'delete'
map global surround t ':select-surrounding-tag<ret>' -docstring 'select tag'
map global normal 'some key' ':enter-user-mode surround<ret>'
```

## Feature
### Surround
```
abc
```
select abc with `<a-i>w`

`:surround<ret>`

Popup information, which surrounder do you use to surround with?

`(`
```
(abc)
```
You can also surround with tag

`:surround<ret>` `t`

start insert mode inside angle both side of selection, | means cursor here.
```
<|>abc</|>
```
If insert space while the context, close tag is confirmed and you can continue to insert attribute.
```
<div |>abc</div>
```
### Change surrounder
```
'abc'
```
`:change-surround<ret>`

Popup information, which surrounder do you want to change from?

`'`

Popup information, which surrounder do you want to change to?

`(`
```
(abc)
```
You can also change tag
```
<div>abc</div>
```
`:change-surround<ret>` `t`

delete tag content and start insert mode there, | means cursor here.
```
<|>abc</|>
```
If insert space while the context, close tag is confirmed and you can continue to insert attribute.
```
<section |>abc</section>
```

### Delete surrounder
```
{abc}
```
`:delete-surround<ret>`

Popup information, which surrounder do you want to delete?

`{`
```
abc
```
You can also delete tag
```
<p>abc</p>
```
`:delete-surround<ret>` `t`
```
abc
```

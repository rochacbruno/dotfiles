define-command toggle-word %{
	execute-keys '<a-i>w|'
	execute-keys "kakoune-toggler %val{config} %opt{filetype}<ret>"
}

define-command toggle-WORD %{
	execute-keys '<a-i><a-w>|'
	execute-keys "kakoune-toggler %val{config} %opt{filetype}<ret>"
}

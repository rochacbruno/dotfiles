declare-option -hidden line-specs git_diff_line_specs
declare-option -hidden str gitgutter_buffer

declare-option -hidden -docstring \
"Path to git_gutter.sh script." \
str git_gutter_sh_source %sh{ echo "${kak_source%%.kak}.sh" }

hook global ModeChange pop:insert:.* gitdiff
hook global BufCreate .* gitdiff

define-command -hidden gitdiff %{
    set-option buffer gitgutter_buffer %sh{ mktemp -t gitgutter.buffer.XXXXXX }
    evaluate-commands -no-hooks %{ write! %opt{gitgutter_buffer} }
    evaluate-commands %sh{
    . "$kak_opt_git_gutter_sh_source"
    git_diff "${kak_opt_gitgutter_buffer}" "${kak_buffile}"
    }
}

add-highlighter global/ flag-lines LineNumbers git_diff_line_specs


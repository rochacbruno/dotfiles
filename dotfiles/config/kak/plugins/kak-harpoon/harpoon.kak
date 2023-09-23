declare-option str-list harpoon_files

define-command harpoon-add -docstring "harpoon-add: Add the current file to the list of harpoons" %{
  evaluate-commands %sh{
    eval set -- "$kak_quoted_opt_harpoon_files"
    index=0
    while [ $# -gt 0 ]; do
      index=$(($index + 1))
      if [ "$1" = "$kak_bufname" ]; then
        echo "fail %{$kak_quoted_bufname is already harpooned at index $index}"
        return
      fi
      shift
    done
    index=$(($index + 1))
    printf "%s\\n" "
      set-option -add global harpoon_files $kak_quoted_bufname
      echo '$index: $kak_bufname'
    "
  }
}

define-command harpoon-nav -params 1 -docstring "harpoon-nav <index>: navigate to the harpoon at <index>" %{
  evaluate-commands %sh{
    index=$1
    eval set -- "$kak_quoted_opt_harpoon_files"
    eval "bufname=\${$index}"
    if [ -n "$bufname" ]; then
      echo "edit '$bufname'"
      echo "echo '$index: $bufname'"
    else
      echo "fail 'No harpoon at index $index'"
    fi
  }
}

define-command harpoon-show-list -docstring "harpoon-show-list: show all harpoons in the *harpoons* buffer" %{
  evaluate-commands -save-regs dquote %{
    try %{
      set-register dquote %opt{harpoon_files}
      edit -scratch *harpoon*
      execute-keys -draft '%"_d<a-P>a<ret><esc>I<c-r>#: <esc>gjxd'
    }
    try %{ execute-keys ggghwl } catch %{
      delete-buffer *harpoon*
      fail "No harpoons are set"
    }
  }
}

define-command -hidden harpoon-update-from-list %{
  evaluate-commands -save-regs dquote %{
    try %{
      execute-keys -draft -save-regs '' '%<a-s><a-k>^\d*:<ret><a-;>;wl<a-l>y'
      set-option global harpoon_files %reg{dquote}
      harpoon-show-list
    } catch %{
      set-option global harpoon_files
    }
    echo "Updated harpoons"
  }
}

define-command harpoon-add-bindings -docstring "Add convenient keybindings for navigating harpoons" %{
  map global normal <a-1> ":harpoon-nav 1<ret>"
  map global normal <a-2> ":harpoon-nav 2<ret>"
  map global normal <a-3> ":harpoon-nav 3<ret>"
  map global normal <a-4> ":harpoon-nav 4<ret>"
  map global normal <a-5> ":harpoon-nav 5<ret>"
  map global normal <a-6> ":harpoon-nav 6<ret>"
  map global normal <a-7> ":harpoon-nav 7<ret>"
  map global normal <a-8> ":harpoon-nav 8<ret>"
  map global normal <a-9> ":harpoon-nav 9<ret>"

  map global user h ":harpoon-add<ret>" -docstring "add harpoon"
  map global user H ":harpoon-show-list<ret>" -docstring "show harpoons"
}

hook global BufCreate \*harpoon\* %{
  map buffer normal <ret> ':harpoon-nav %val{cursor_line}<ret>'
  map buffer normal <esc> ':delete-buffer *harpoon*<ret>'
  alias buffer write harpoon-update-from-list
  alias buffer w harpoon-update-from-list
  add-highlighter buffer/harpoon-indices regex ^\d: 0:function
}

# State saving - save by PWD and git branch, if any

declare-option str harpoon_state_file %sh{
  git_branch=$(git -C "${kak_buffile%/*}" rev-parse --abbrev-ref HEAD 2>/dev/null)
  state_file=$(printf "%s" "$PWD-$git_branch" | sed -e 's|_|__|g' -e 's|/|_-|g')
  state_dir=${XDG_STATE_HOME:-~/.local/state}/kak/harpoon
  mkdir -p $state_dir
  echo $state_dir/$state_file
}

hook global KakBegin .* %{
  evaluate-commands %sh{
    if [ -f "$kak_opt_harpoon_state_file" ]; then
      printf "set-option global harpoon_files "
      cat "$kak_opt_harpoon_state_file"
    fi
  }
}

hook global KakEnd .* %{
  evaluate-commands %sh{
    if [ -z "$kak_quoted_opt_harpoon_files" ]; then
      rm -f "$kak_opt_harpoon_state_file"
      exit
    fi
    printf "$kak_quoted_opt_harpoon_files" > "$kak_opt_harpoon_state_file"
  }
}

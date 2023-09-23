define-command mv -params 1 -file-completion -docstring %{
  Move the current file and rename the buffer

  Usage: mv TARGET
} %{
  write
  evaluate-commands %sh{
    target="$1"
    if ! mv "$kak_buffile" "$target"
    then
      fail "Failed to move file (see *debug*)"
    fi

    echo delete-buffer
    [ -d "$target" ] && target="${target}/${kak_buffile##*/}"
    printf "edit '%s'\n" "$target"
  }
}

# Synchronize buffer with a mv command (called by bin/tmv)
define-command tug-mv-sync -hidden -params .. %{
  evaluate-commands %sh{
    if ! command -v realpath 2>/dev/null >/dev/null
    then
      realpath() {
        case "$1" in
          /*) path=$1 ;;
          *) path=$PWD/$1 ;;
        esac
      }
    fi

    # Get the target file/directory
    for target; do :; done

    # If the target is a directory, the file was moved into it
    [ -d "$target" ] && target="${target}/${kak_buffile##*/}"

    # Canonicalize paths
    target=$(realpath "$target")
    buffile=$(realpath "$kak_buffile")

    # Reopen the current buffer if it was renamed (ie, if it's in
    # the mv command's list of source paths)
    i=1; while [ $i -lt $# ]; do
      source=$(realpath "$1"); shift
      if [ "$source" = "$buffile" ]
      then
         printf "delete-buffer '%s'\n" "$buffile"
         printf "edit '%s'\n" "$target"
      fi
    done
  }
}

define-command rename -params 1 -file-completion -docstring %{
  Rename the current buffer and file
} %{
  write
  evaluate-commands %sh{
    dir=$(dirname "$kak_buffile")
    target="$dir/$1"
    if ! mv "$kak_buffile" "$target"
    then
      fail "Failed to rename file (see *debug*)"
    fi

    echo delete-buffer
    printf "edit '%s'\n" "$target"
  }
}

define-command cp -params 1 -file-completion -docstring %{
  Copy the current file

  Usage: cp TARGET
} %{
  write
  evaluate-commands %sh{
    if ! cp "$kak_buffile" "$1"
    then
      fail "Failed to copy file (see *debug*)"
    fi
  }
}

define-command mkdir -params 1 -file-completion -docstring %{
  Make directories for the current buffer
} %{
  evaluate-commands %sh{
    if ! mkdir -p $(dirname "$kak_buffile")
    then
      fail "Failed to make directories (see *debug*)"
    fi
  }
}

define-command chmod -params 1 -file-completion -docstring %{
  Change file modes or Access Control Lists

  Usage: chmod MODE
} %{
  evaluate-commands %sh{
    if ! chmod "$1" "$kak_buffile"
    then
      fail "Failed to chmod (see *debug*)"
    fi
  }
}

define-command rm -file-completion -docstring %{
  Remove the current file and buffer
} %{
  evaluate-commands %sh{
    # close & reopen buffer - ensures the script will fail if the buffer is not saved
    buffile="$kak_buffile"
    echo delete-buffer
    echo "edit '$buffile'"

    if ! rm "$@" "$kak_buffile"
    then
      fail "Failed to remove file (see *debug*)"
    fi
    echo delete-buffer
  }
}

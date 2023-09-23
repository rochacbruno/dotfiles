# mark.kak
# ----------------------------------------------------------------------------
# version:  1.1.5
# date:     2019-01-07
# author:   fsub <fsub-9f4j@noreply.cycloid.eu>
# rights:   UNLICENSE <https://unlicense.org>
# ----------------------------------------------------------------------------

###
# declarations

declare-option -hidden bool mark_debug false

declare-option -hidden regex mark_regex_1
declare-option -hidden regex mark_regex_2
declare-option -hidden regex mark_regex_3
declare-option -hidden regex mark_regex_4
declare-option -hidden regex mark_regex_5
declare-option -hidden regex mark_regex_6

declare-option -hidden int-list mark_unused 1 2 3 4 5 6
declare-option -hidden int-list mark_active

###
# faces

set-face global MarkFace1 rgb:dca3a3+rb   # red
set-face global MarkFace2 rgb:f0dfaf+rb   # yellow
set-face global MarkFace3 rgb:94bff3+rb   # blue
set-face global MarkFace4 rgb:ec93d3+rb   # magenta
set-face global MarkFace5 rgb:93e0e3+rb   # cyan
set-face global MarkFace6 rgb:c3bf9f+rb   # green

###
# highlighers

add-highlighter shared/mark group -passes colorize
add-highlighter shared/mark/ dynregex '%opt{mark_regex_1}' 0:MarkFace1
add-highlighter shared/mark/ dynregex '%opt{mark_regex_2}' 0:MarkFace2
add-highlighter shared/mark/ dynregex '%opt{mark_regex_3}' 0:MarkFace3
add-highlighter shared/mark/ dynregex '%opt{mark_regex_4}' 0:MarkFace4
add-highlighter shared/mark/ dynregex '%opt{mark_regex_5}' 0:MarkFace5
add-highlighter shared/mark/ dynregex '%opt{mark_regex_6}' 0:MarkFace6

###
# hooks

# NOTE(fsub): try to override all other kinds of highlighting
hook -group mark global KakBegin .* %{ try %{
   hook -group mark global WinSetOption filetype=.* %{ try %{
      remove-highlighter window/mark
      add-highlighter window/ ref mark
}}}}

###
# definitions

define-command -hidden mark-debug-print-state %{
   evaluate-commands %sh{
      case "${kak_opt_mark_debug}" in
         true|yes)
            printf "echo -debug [mark] unused: (%s), active: (%s)\\n" \
               "${kak_opt_mark_unused}" "${kak_opt_mark_active}"
            ;;
         *)
            ;;
      esac
   }
}

define-command -params 1..2 mark-set \
    -docstring %(mark-set <pattern> [slot]: highlight all text occurrences
matching <pattern>; unless [slot] is specified, use slot 1
   pattern: regular expression
   slot:    index in 1..6) \
%{
   evaluate-commands %sh{
      mp="${1}"
      mi="${2-1}"

      case "${mi}" in
         1|2|3|4|5|6)
            ;;
         *)
            printf "echo -markup {Error}%s\\n" "invalid slot"
            exit
            ;;
      esac

      unset tu
      for i in ${kak_opt_mark_unused}; do
         if [ "${i}" != "${mi}" ]; then
            tu="${tu}${tu:+ }${i}"
         fi
      done
      printf "set-option global mark_unused %s\\n" "${tu}"

      unset ta
      for i in ${kak_opt_mark_active}; do
         if [ "${i}" != "${mi}" ]; then
            ta="${ta}${ta:+ }${i}"
         fi
      done
      ta="${ta}${ta:+ }${mi}"
      printf "set-option global mark_active %s\\n" "${ta}"

      printf "mark-debug-print-state\\n"

      printf "set-option global mark_regex_%s '%s'\\n" "${mi}" "${mp}"
   }
}

define-command -params ..1 mark-del \
    -docstring %(mark-del [slot]: unmark all text occurrences highlighted via
mark-set at [slot]; unless [slot] is specified, use slot 1
   slot: index in 1..6) \
%{
   evaluate-commands %sh{
      mi="${1-1}"

      case "${mi}" in
         1|2|3|4|5|6)
            ;;
         *)
            printf "echo -markup {Error}%s\\n" "invalid slot"
            exit
            ;;
      esac

      unset tu
      for i in ${kak_opt_mark_unused}; do
         if [ "${i}" != "${mi}" ]; then
            tu="${tu}${tu:+ }${i}"
         fi
      done
      tu="${mi}${tu:+ }${tu}"
      printf "set-option global mark_unused %s\\n" "${tu}"

      unset ta
      for i in ${kak_opt_mark_active}; do
         if [ "${i}" != "${mi}" ]; then
            ta="${ta}${ta:+ }${i}"
         fi
      done
      printf "set-option global mark_active %s\\n" "${ta}"

      printf "mark-debug-print-state\\n"

      printf "set-option global mark_regex_%s ''\\n" "${mi}"
   }
}

define-command mark-clear \
   -docstring %(mark-clear: unmark all text occurrences highlighted via
mark-set) \
%{
   evaluate-commands %sh{
      unset ta
      for i in ${kak_opt_mark_active}; do
         ta="${i}${ta:+ }${ta}"
      done
      tu="${kak_opt_mark_unused}"
      for i in ${ta}; do
         tu="${i}${tu:+ }${tu}"
         printf "set-option global mark_regex_%s ''\\n" "${i}"
      done
      printf "set-option global mark_unused %s\\n" "${tu}"
      printf "set-option global mark_active\\n"

      printf "mark-debug-print-state\\n"
   }
}

define-command -params 2 mark-pattern \
    -docstring %(mark-pattern <action> <pattern>: alter highlighting according
to <action> for all occurrences of text matching <pattern>
   action:  token in {del, set, toggle}
   pattern: regular expression) \
%{
   evaluate-commands %sh{
      action="${1}"
      mp="${2}"

      case "${1}" in
         del|set|toggle)
            ;;
         *)
            printf "echo -markup {Error}%s\\n" "invalid action"
            exit
            ;;
      esac

      for i in ${kak_opt_mark_active}; do
         # TODO(fsub): check if it makes sense to collapse cases,
         # see https://github.com/mawww/kakoune/issues/2241
         case "${i}" in
            1)
               p="${kak_opt_mark_regex_1}"
               ;;
            2)
               p="${kak_opt_mark_regex_2}"
               ;;
            3)
               p="${kak_opt_mark_regex_3}"
               ;;
            4)
               p="${kak_opt_mark_regex_4}"
               ;;
            5)
               p="${kak_opt_mark_regex_5}"
               ;;
            6)
               p="${kak_opt_mark_regex_6}"
               ;;
            *)
               printf "echo -markup {Error}%s\\n" "invalid slot"
               exit
               ;;
         esac
         if [ "${p}" = "${mp}" ]; then
            if [ "${action}" != "set" ]; then
               printf "mark-del %s\\n" "${i}"
               action="del" # avoid any further action
            fi
         fi
      done

      if [ "${action}" != "del" ]; then
         if [ -z "${kak_opt_mark_unused}" ]; then
            for i in ${kak_opt_mark_active}; do
               mi="${i}"
               break
            done
         else
            for i in ${kak_opt_mark_unused}; do
               mi="${i}"
               break
            done
         fi
         printf "mark-set '%s' %s\\n" "${mp}" "${mi}"
      fi
   }
}

define-command -hidden mark-word-impl %{
   evaluate-commands %sh{
      printf "mark-pattern toggle '\\\\b%s\\\\b'\\n" "${kak_selection}"
   }
}

define-command mark-word \
    -docstring %(mark-word: toggle highlighting for all occurrences of the
word under the cursor) \
%{
   # NOTE(fsub): temporarily override `extra_word_chars` to comply with regex,
   # see https://github.com/mawww/kakoune/issues/2608
   evaluate-commands -draft %sh{
      ewc="${kak_opt_extra_word_chars}"
      printf "set-option current extra_word_chars _\n"
      printf "try %%[ execute-keys <a-i>w:mark-word-impl<ret> ]\n"
      printf "set-option current extra_word_chars %s\n" "${ewc}"
   }
}

# save the current buffer to its file as root using `sudo`
# (optionally pass the user password to sudo if not cached)

define-command -hidden sudo-write-cached-password %{
    # easy case: the password was already cached, so we don't need any tricky handling
    eval -save-regs f %{
        reg f %sh{ mktemp -t XXXXXX }
        write! %reg{f}
        eval %sh{
            sudo -n -- dd if="$kak_main_reg_f" of="$kak_buffile" >/dev/null 2>&1
            if [ $? -eq 0 ]; then
                echo "edit!"
            else
                echo 'fail "Unknown failure"'
            fi
            rm -f "$kak_main_reg_f"
        }
    }
}

define-command -hidden sudo-write-prompt-password %{
    prompt -password 'Password:' %{
        eval -save-regs r %{
            eval -draft -save-regs 'tf|"' %{
                reg t %val{buffile}
                reg f %sh{ mktemp -t XXXXXX }
                write! %reg{f}

                # write the password in a buffer in order to pass it through STDIN to sudo
                # somewhat dangerous, but better than passing the password
                # through the shell scope's environment or interpolating it inside the shell string
                # 'exec |' is pretty much the only way to pass data over STDIN
                edit -scratch '*sudo-password-tmp*'
                reg '"' "%val{text}"
                exec <a-P>
                reg | %{
                    sudo -S -- dd if="$kak_main_reg_f" of="$kak_main_reg_t" > /dev/null 2>&1
                    if [ $? -eq 0 ]; then
                        printf 'edit!'
                    else
                        printf 'fail "Incorrect password?"'
                    fi
                    rm -f "$kak_main_reg_f"
                }
                exec '|<ret>'
                exec -save-regs '' '%"ry'
                delete-buffer! '*sudo-password-tmp*'
            }
            eval %reg{r}
        }
    }
}

define-command sudo-write -docstring "Write the content of the buffer using sudo" %{
    eval %sh{
        # tricky posix-way of getting the first character of a variable
        # no subprocess!
        if [ "${kak_buffile%"${kak_buffile#?}"}" != "/" ]; then
            # not entirely foolproof as a scratch buffer may start with '/', but good enough
            printf 'fail "Not a file"'
            exit
        fi
        # check if the password is cached
        if sudo -n true > /dev/null 2>&1; then
            printf sudo-write-cached-password
        else
            printf sudo-write-prompt-password
        fi
    }
}


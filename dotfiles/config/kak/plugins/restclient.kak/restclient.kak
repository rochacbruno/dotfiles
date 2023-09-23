hook global BufCreate .*[.]rest %{
    set-option buffer filetype restclient
}

hook global WinSetOption filetype=restclient %{
    require-module restclient

    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window restclient-.+ }
}

hook -group restclient-highlight global WinSetOption filetype=restclient %{
    add-highlighter window/restclient ref restclient
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/restclient }
}

provide-module restclient %{
    add-highlighter shared/restclient regions
    add-highlighter shared/restclient/block region '^###' '$' fill header
    add-highlighter shared/restclient/comment region '^#' '$' fill comment
    add-highlighter shared/restclient/parts default-region group
    add-highlighter shared/restclient/parts/method regex ^(?:GET|HEAD|POST|PUT|PATCH|DELETE|OPTIONS) 0:type
    add-highlighter shared/restclient/parts/url regex '^(?:GET|HEAD|POST|PUT|PATCH|DELETE|OPTIONS)\s+([^\n]+)' 1:string
    add-highlighter shared/restclient/parts/variable_value regex '^:[^\s=]+\s*=\s*([^\n]+)' 1:value
    add-highlighter shared/restclient/parts/variable regex '^:[^\s=]+' 0:variable
    add-highlighter shared/restclient/parts/header regex ^\S+(?=:) 0:keyword

    declare-option -docstring "Command to copy to clipboard" str restclient_copy_command 'wl-copy'

    declare-option -docstring "Python code to convert block to curl command" str restclient_curlify '
import sys

lines = [l.strip() for l in sys.stdin.read().strip().split("\n")]

vars = {}
for line in lines:
    if line.startswith(":") and "=" in line:
        segments = [s.strip() for s in line.split("=", 1)]
        vars[segments[0]] = segments[1]

lines = [line for line in lines if not (line.startswith(":") and "=" in line)]
while len(lines) > 0 and len(lines[0]) == 0:
    lines.pop(0)

if len(lines) == 0:
    print("Error: no valid request block under the cursor", file=sys.stderr)
    sys.exit(1)

method, url = lines.pop(0).split(" ", 1)
result = "curl -Ssi -X{} ''{}'' ".format(method, url)

while len(lines) > 0:
    line = lines.pop(0)
    if len(line) == 0:
        break
    result += "-H ''{}'' ".format(line)

if len(lines) > 0:
    result += "-d ''{}''".format("".join([l.strip() for l in lines]))

for var, val in vars.items():
    result = result.replace(var, val)

print(result)
'

    declare-option -docstring "Python code to prettify curl output" str restclient_prettify '
import sys
import json

lines = "\n".join(sys.stdin.read().strip().splitlines())
data = lines.split("\n\n", 1)
if len(data) > 1:
    try:
        print(json.dumps(json.loads(data[1]), indent=4, sort_keys=True, ensure_ascii=False), "\n")
    except:
        print(data[1])
print(data[0])
'
    define-command restclient-execute %{
        nop %sh{
            mkdir -p /tmp/kak-restclient
            echo 'Loading...' > "/tmp/kak-restclient/${kak_session}.json"
        }

        try %{
            evaluate-commands -client kak-restclient-response edit!
        } catch %{
            new "rename-client kak-restclient-response; edit /tmp/kak-restclient/%val{session}.json; set-option buffer autoreload true"
        }

        evaluate-commands -draft %{
            restclient-select-block

            nop %sh{
                (
                    {
                        echo "${kak_selections}" \
                            | python -c "${kak_opt_restclient_curlify}" \
                            | sh \
                            | python -c "${kak_opt_restclient_prettify}"
                    } >"/tmp/kak-restclient/${kak_session}.json.new" 2>&1
                    mv "/tmp/kak-restclient/${kak_session}.json.new" "/tmp/kak-restclient/${kak_session}.json"
                    echo 'evaluate-commands -client kak-restclient-response edit!' | kak -p "$kak_session"
                    echo 'execute-keys -client kak-restclient-response gg' | kak -p "$kak_session"
                ) < /dev/null >/dev/null 2>&1 &
            }
        }
    }

    define-command restclient-copy-curl %{
        evaluate-commands -draft %{
            restclient-select-block

            nop %sh{
                (
                    echo "${kak_selections}" \
                        | python -c "${kak_opt_restclient_curlify}" \
                        | ${kak_opt_restclient_copy_command}
                ) < /dev/null >/dev/null 2>&1 &
            }
        }
    }

    define-command -hidden restclient-select-block %{
        evaluate-commands -draft %{
            execute-keys 'ggO###<esc>gjo###<esc>'
        }

        try %{
            execute-keys -save-regs '' '<a-i>c###,###<ret><a-x><a-s><a-K>^#<ret><a-_>Z<a-:><a-;>Gg<a-s><a-k>^:.*=<ret>'
            execute-keys '<a-z>a'
        } catch %{
            execute-keys 'z'
        }
        execute-keys '<a-x>'

        evaluate-commands -draft %{
            execute-keys 'ggxdgjxd'
        }
    }
}

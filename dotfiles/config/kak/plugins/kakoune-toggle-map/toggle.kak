define-command -params 5..7 toggle-map %{ evaluate-commands %sh{
    if [ $# -eq 6 ]; then
        echo "fail %{Error: 'toggle-map' wrong argument count}"
        exit 1
    elif [ "$1" == "-docstring" ]; then
        shift 1
        doc="$1"
        shift 1
    fi

    scope="$1"
    mode="$2"
    key="$3"
    on="$4"
    off="$5"

    if [ ! -z "$doc" ]; then
        echo "map -docstring %{$doc} %{$scope} %{$mode} %{$key} %{:$on-toggle<ret>}"
    else
        echo "map %{$scope} %{$mode} %{$key} %{:$on-toggle<ret>}"
    fi

    echo "define-command -override $on-toggle %{"
    echo "$on"
    echo "map $scope $mode $key %{:$off-toggle<ret>}"
    echo "}"


    echo "define-command -override $off-toggle %{"
    echo "$off"
    echo "map $scope $mode $key %{:$on-toggle<ret>}"
    echo "}"
}}

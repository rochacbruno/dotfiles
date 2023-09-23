define-command hlsearch-off %{
    remove-highlighter global/hltoggle
}

define-command hlsearch-on %{
    add-highlighter global/hltoggle dynregex '%reg{/}' 0:white,rgb:222222+ub
}

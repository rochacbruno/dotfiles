
# set cursor to underline
hook global InsertIdle .* %{
  set-face window PrimaryCursor default,default+u
  set-face window PrimaryCursorEol default,default+u
  set-face window SecondaryCursor default,default+u
  set-face window SecondaryCursorEol default,default+u
  set-face window LineNumberCursor default,default+u
  set-face window PrimarySelection default,default+u
  set-face window SecondarySelection default,default+u
}

# set cursor to default
hook global NormalIdle .* %{
  set-face window PrimaryCursor default,default+r
  set-face window PrimaryCursorEol default,default+r
  set-face window SecondaryCursor default,default+r
  set-face window SecondaryCursorEol default,default+r
  set-face window LineNumberCursor default,default+r
  set-face window PrimarySelection default,default+r
  set-face window SecondarySelection default,default+r
}


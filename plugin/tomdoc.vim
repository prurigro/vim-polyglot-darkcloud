aug filetype_setup
  au!
  au FileType *
        \ let b:current_syntax = &syntax |
        \ let &syntax = b:current_syntax . '.tomdoc'
aug END

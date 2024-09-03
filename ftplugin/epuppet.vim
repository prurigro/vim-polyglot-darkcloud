" Vim filetype plugin
" Language:             embedded puppet
" Maintainer:           Gabriel Filion <gabster@lelutin.ca>
" URL:                  https://github.com/rodjek/vim-puppet
" Last Change:          2019-09-01

" Only do this when not done yet for this buffer
if exists('b:did_ftplugin')
  finish
endif

let s:save_cpo = &cpo
set cpo-=C

" Define some defaults in case the included ftplugins don't set them.
let s:undo_ftplugin = ''
if has('win32')
  let s:browsefilter = "All Files (*.*)\t*.*\n"
else
    let s:browsefilter = "All Files (*)\t*\n"
endif
let s:match_words = ''

if !exists('g:epuppet_default_subtype')
  let g:epuppet_default_subtype = 'sh'
endif

if &filetype =~# '^epuppet\.'
    let b:epuppet_subtype = matchstr(&filetype,'^epuppet\.\zs\w\+')
elseif !exists('b:epuppet_subtype')
  let b:epuppet_subtype = matchstr(substitute(expand('%:t'),'\c\%(\.epp\)\+$','',''),'\.\zs\w\+\%(\ze+\w\+\)\=$')
  " TODO instead of listing exceptions like this, can we instead recognize
  "  extension -> type mapping?
  if b:epuppet_subtype ==? 'rhtml'
    let b:epuppet_subtype = 'html'
  elseif b:epuppet_subtype ==? 'rb'
    let b:epuppet_subtype = 'ruby'
  elseif b:epuppet_subtype ==? 'yml'
    let b:epuppet_subtype = 'yaml'
  elseif b:epuppet_subtype ==? 'js'
    let b:epuppet_subtype = 'javascript'
  elseif b:epuppet_subtype ==? 'txt'
    " Conventional; not a real file type
    let b:epuppet_subtype = 'text'
  elseif b:epuppet_subtype ==? 'py'
    let b:epuppet_subtype = 'python'
  elseif b:epuppet_subtype ==? 'rs'
    let b:epuppet_subtype = 'rust'
  elseif b:epuppet_subtype ==?''
    let b:epuppet_subtype = g:epuppet_default_subtype
  endif
endif

if exists('b:epuppet_subtype') && b:epuppet_subtype != '' && b:epuppet_subtype !=? 'epuppet'
  exe 'runtime! ftplugin/'.b:epuppet_subtype.'.vim ftplugin/'.b:epuppet_subtype.'_*.vim ftplugin/'.b:epuppet_subtype.'/*.vim'
endif
unlet! b:did_ftplugin

runtime! ftplugin/sh.vim
unlet! b:did_ftplugin

" Override our defaults if these were set by an included ftplugin.
if exists('b:undo_ftplugin')
  let s:undo_ftplugin = b:undo_ftplugin
  unlet b:undo_ftplugin
endif
if exists('b:browsefilter')
  let s:browsefilter = b:browsefilter
  unlet b:browsefilter
endif
if exists('b:match_words')
  let s:match_words = b:match_words
  unlet b:match_words
endif

let s:include = &l:include
let s:path = &l:path
let s:suffixesadd = &l:suffixesadd

runtime! ftplugin/puppet.vim
let b:did_ftplugin = 1

" Combine the new set of values with those previously included.
if exists('b:undo_ftplugin')
  let s:undo_ftplugin = b:undo_ftplugin . ' | ' . s:undo_ftplugin
endif
if exists ('b:browsefilter')
  let s:browsefilter = substitute(b:browsefilter,'\cAll Files (\*\.\*)\t\*\.\*\n','','') . s:browsefilter
endif
if exists('b:match_words')
  let s:match_words = b:match_words . ',' . s:match_words
endif

if len(s:include)
  let &l:include = s:include
endif
let &l:path = s:path . (s:path =~# ',$\|^$' ? '' : ',') . &l:path
let &l:suffixesadd = s:suffixesadd . (s:suffixesadd =~# ',$\|^$' ? '' : ',') . &l:suffixesadd
unlet s:include s:path s:suffixesadd

" Load the combined list of match_words for matchit.vim
if exists('loaded_matchit')
  let b:match_words = s:match_words
endif

" TODO: comments=
setlocal commentstring=<%#%s%>

let b:undo_ftplugin = 'setl cms< '
      \ " | unlet! b:browsefilter b:match_words | " . s:undo_ftplugin

let &cpo = s:save_cpo
unlet s:save_cpo


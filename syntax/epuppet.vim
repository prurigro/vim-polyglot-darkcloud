" Vim syntax plugin
" Language:             embedded puppet
" Maintainer:           Gabriel Filion <gabster@lelutin.ca>
" URL:                  https://github.com/rodjek/vim-puppet
" Last Change:          2019-09-01

" quit when a syntax file was already loaded {{{1
if exists('b:current_syntax')
  finish
endif

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
  elseif b:epuppet_subtype ==? ''
    let b:epuppet_subtype = g:epuppet_default_subtype
  endif
endif

if exists('b:epuppet_subtype') && b:epuppet_subtype != '' && b:epuppet_subtype !=? 'epuppet'
  exe 'runtime! syntax/'.b:epuppet_subtype.'.vim'
  unlet! b:current_syntax
endif

syn include @puppetTop syntax/puppet.vim

syn cluster ePuppetRegions contains=ePuppetBlock,ePuppetExpression,ePuppetComment

syn region  ePuppetBlock      matchgroup=ePuppetDelimiter start="<%%\@!-\=" end="[=-]\=%\@<!%>" contains=@puppetTop  containedin=ALLBUT,@ePuppetRegions keepend
syn region  ePuppetExpression matchgroup=ePuppetDelimiter start="<%=\{1,4}" end="[=-]\=%\@<!%>" contains=@puppetTop  containedin=ALLBUT,@ePuppetRegions keepend
syn region  ePuppetComment    matchgroup=ePuppetDelimiter start="<%-\=#"    end="[=-]\=%\@<!%>" contains=puppetTodo,@Spell containedin=ALLBUT,@ePuppetRegions keepend

" Define the default highlighting.

hi def link ePuppetDelimiter              PreProc
hi def link ePuppetComment                Comment

let b:current_syntax = 'epuppet'

" Language:    CoffeeScript
" Maintainer:  Mick Koch <mick@kochm.co>
" URL:         http://github.com/kchmck/vim-coffee-script
" License:     WTFPL

if exists('b:current_syntax')
  let s:current_syntax_save = b:current_syntax
endif

" Syntax highlighting for text/coffeescript script tags
syn include @htmlCoffeeScript syntax/coffee.vim
syn region coffeeScript start=#<script [^>]*type=['"]\?text/coffeescript['"]\?[^>]*>#
\                       end=#</script>#me=s-1 keepend
\                       contains=@htmlCoffeeScript,htmlScriptTag,@htmlPreproc
\                       containedin=htmlHead

if exists('s:current_syntax_save')
  let b:current_syntax = s:current_syntax_save
  unlet s:current_syntax_save
endif
" Vim syntax file
" Language:     HTML (version 5.1)
" Last Change:  2017 Feb 15
" License:      Public domain
"               (but let me know if you like :) )
"
" Maintainer:   Kao, Wei-Ko(othree) ( othree AT gmail DOT com )

" Comment
" https://github.com/w3c/html/issues/694
syntax region htmlComment start=+<!--+ end=+-->+ contains=@Spell
syntax region htmlComment start=+<!DOCTYPE+ keepend end=+>+
if !exists("g:less_html_style_tags")
  let g:less_html_style_tags = 1
endif

if !g:less_html_style_tags
  finish
endif

" Unset (but preserve) so that less will run.
if exists("b:current_syntax")
   let s:pre_less_cur_syn = b:current_syntax
   unlet b:current_syntax
endif

" Inspired by code from github.com/kchmck/vim-coffee-script
" and the html syntax file included with vim 7.4.

syn include @htmlLess syntax/less.vim

" We have to explicitly add to htmlHead (containedin) as that region specifies 'contains'.
syn region lessStyle start=+<style [^>]*type *=[^>]*text/less[^>]*>+ keepend end=+</style>+ contains=@htmlLess,htmlTag,htmlEndTag,htmlCssStyleComment,@htmlPreproc containedin=htmlHead

" Reset since 'less' isn't really the current_syntax.
if exists("s:pre_less_cur_syn")
   let b:current_syntax = s:pre_less_cur_syn
endif

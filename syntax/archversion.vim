" Vim syntax file
" Language: archversion.conf
" Maintainer: Kevin MacMartin (prurigro@gmail.com)
" Latest Revision: 26 June 2014

if exists("b:current_syntax")
  finish
endif

syn case match
syntax sync fromstart
setlocal iskeyword+=:,/,.,+,-,_,[,],?,=,&

" Main Keywords
syn keyword avVariable timeout retry repo arch repo timeout timeout abs_path repo eval_upstream eval_compare
hi def link avVariable Constant

" Comparisons
syn keyword avCompareVariable compare contained
hi def link avCompareVariable Constant
syn keyword avCompare pacman archweb aur abs cache none contained
hi def link avCompare Type
syn match avCompareBlock "^ *compare *=.*" contains=avCompareVariable,avCompare

" URL
syn keyword avURLVariable url contained
hi def link avURLVariable Constant
syn match avURL 'https*:[^ ]*' contained
hi def link avURL Type
syn match avURLBlock "^ *url *=.*" contains=avURLVariable,avURL

" Regex
syn keyword avRegexVariable regex regex_name regex_version regex_ext regex_exclude contained
hi def link avRegexVariable Constant
syn match avRegex '.*' contained
hi def link avRegex String
syn match avRegexBlock "^\ *regex[^=]*=.*" contains=avRegexVariable,avRegex

" Comments
syn match avComment "#.*$"
hi def link avComment Comment

" Headings
syn region avHeading start="\[" end="\]"
hi def link avHeading Special

let b:current_syntax = "archversion"

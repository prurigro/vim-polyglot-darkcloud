au BufNewFile,BufRead *archversion.conf set filetype=archversion
au BufNewFile,BufRead *packages.conf set filetype=archversion
au BufRead,BufNewFile *.ino,*.pde set filetype=arduino
autocmd BufNewFile,BufRead *.blade.php set filetype=blade
autocmd BufNewFile,BufRead *.clj,*.cljs,*.edn,*.cljx,*.cljc,{build,profile}.boot setlocal filetype=clojure
autocmd BufNewFile,BufRead *.coffee set filetype=coffee
autocmd BufNewFile,BufRead *Cakefile set filetype=coffee
autocmd BufNewFile,BufRead *.coffeekup,*.ck set filetype=coffee
autocmd BufNewFile,BufRead *._coffee set filetype=coffee
function! s:DetectCoffee()
    if getline(1) =~ '^#!.*\<coffee\>'
        set filetype=coffee
    endif
endfunction
autocmd BufNewFile,BufRead * call s:DetectCoffee()
autocmd BufNewFile,BufReadPost *.feature,*.story set filetype=cucumber
au BufNewFile,BufRead Dockerfile* set filetype=dockerfile
au BufRead,BufNewFile *.ex,*.exs call s:setf('elixir')
au BufRead,BufNewFile *.eex call s:setf('eelixir')
au BufRead,BufNewFile * call s:DetectElixir()
function! s:setf(filetype) abort
  let &filetype = a:filetype
endfunction
function! s:DetectElixir()
  if getline(1) =~ '^#!.*\<elixir\>'
    call s:setf('elixir')
  endif
endfunction
if !exists('g:vim_ember_script')
  let g:vim_ember_script = 1
endif
autocmd BufNewFile,BufRead *.em set filetype=ember-script
autocmd FileType ember-script set tabstop=2|set shiftwidth=2|set expandtab
if !exists('g:vim_emblem')
  let g:vim_emblem = 1
endif
if exists('g:vim_ember_script')
  autocmd BufNewFile,BufRead *.emblem set filetype=emblem
else
  autocmd BufNewFile,BufRead *.em,*.emblem set filetype=emblem
endif
autocmd FileType emblem set tabstop=2|set shiftwidth=2|set expandtab
autocmd BufNewFile,BufRead *.git/{,modules/**/,worktrees/*/}{COMMIT_EDIT,TAG_EDIT,MERGE_,}MSG set ft=gitcommit
autocmd BufNewFile,BufRead *.git/config,.gitconfig,gitconfig,.gitmodules set ft=gitconfig
autocmd BufNewFile,BufRead */.config/git/config                          set ft=gitconfig
autocmd BufNewFile,BufRead *.git/modules/**/config                       set ft=gitconfig
autocmd BufNewFile,BufRead git-rebase-todo                               set ft=gitrebase
autocmd BufNewFile,BufRead .gitsendemail.*                               set ft=gitsendemail
autocmd BufNewFile,BufRead *.git/**
      \ if getline(1) =~ '^\x\{40\}\>\|^ref: ' |
      \   set ft=git |
      \ endif
autocmd BufNewFile,BufRead,StdinReadPost *
      \ if getline(1) =~ '^\(commit\|tree\|object\) \x\{40\}\>\|^tag \S\+$' |
      \   set ft=git |
      \ endif
autocmd BufNewFile,BufRead *
      \ if getline(1) =~ '^From \x\{40\} Mon Sep 17 00:00:00 2001$' |
      \   set filetype=gitsendemail |
      \ endif
let s:cpo_save = &cpo
set cpo&vim
let s:current_fileformats = ''
let s:current_fileencodings = ''
function! s:gofiletype_pre(type)
  let s:current_fileformats = &g:fileformats
  let s:current_fileencodings = &g:fileencodings
  set fileencodings=utf-8 fileformats=unix
  let &l:filetype = a:type
endfunction
function! s:gofiletype_post()
  let &g:fileformats = s:current_fileformats
  let &g:fileencodings = s:current_fileencodings
endfunction
au BufNewFile *.go setfiletype go | if &modifiable | setlocal fileencoding=utf-8 fileformat=unix | endif
au BufRead *.go call s:gofiletype_pre("go")
au BufReadPost *.go call s:gofiletype_post()
au BufNewFile *.s setfiletype asm | if &modifiable | setlocal fileencoding=utf-8 fileformat=unix | endif
au BufRead *.s call s:gofiletype_pre("asm")
au BufReadPost *.s call s:gofiletype_post()
au BufRead,BufNewFile *.tmpl set filetype=gohtmltmpl
au! BufNewFile,BufRead *.mod,*.MOD
au BufNewFile,BufRead go.mod call s:gomod()
fun! s:gomod()
  for l:i in range(1, line('$'))
    let l:l = getline(l:i)
    if l:l ==# '' || l:l[:1] ==# '//'
      continue
    endif
    if l:l =~# '^module .\+'
      set filetype=gomod
    endif
    break
  endfor
endfun
let &cpo = s:cpo_save
unlet s:cpo_save
autocmd BufNewFile,BufRead *.hx setf haxe
autocmd BufNewFile,BufRead *Spec.js,*_spec.js set filetype=jasmine.javascript syntax=jasmine
fun! s:SelectJavascript()
  if getline(1) =~# '^#!.*/bin/\%(env\s\+\)\?node\>'
    set ft=javascript
  endif
endfun
augroup javascript_syntax_detection
  autocmd!
  autocmd BufNewFile,BufRead *.{js,mjs,jsm,es,es6},Jakefile setfiletype javascript
  autocmd BufNewFile,BufRead * call s:SelectJavascript()
augroup END
autocmd BufNewFile,BufRead *.json setlocal filetype=json
autocmd BufNewFile,BufRead *.jsonl setlocal filetype=json
autocmd BufNewFile,BufRead *.jsonp setlocal filetype=json
autocmd BufNewFile,BufRead *.geojson setlocal filetype=json
autocmd BufNewFile,BufRead *.template setlocal filetype=json
au BufNewFile,BufRead *.ejs set filetype=jst
au BufNewFile,BufRead *.jst set filetype=jst
au BufNewFile,BufRead *.djs set filetype=jst
au BufNewFile,BufRead *.hamljs set filetype=jst
au BufNewFile,BufRead *.ect set filetype=jst
autocmd BufNewFile,BufRead *.less setf less
au BufNewFile,BufRead *.liquid					set ft=liquid
au BufNewFile,BufRead */_layouts/*.html,*/_includes/*.html	set ft=liquid
au BufNewFile,BufRead *.html,*.xml,*.textile
      \ if getline(1) == '---' | set ft=liquid | endif
au BufNewFile,BufRead *.markdown,*.mkd,*.mkdn,*.md
      \ if getline(1) == '---' |
      \   let b:liquid_subtype = 'markdown' |
      \   set ft=liquid |
      \ endif
au BufNewFile,BufRead */templates/**.liquid,*/layout/**.liquid,*/snippets/**.liquid
      \ let b:liquid_subtype = 'html' |
      \ set ft=liquid |
au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn} set filetype=markdown
au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn}.{des3,des,bf,bfa,aes,idea,cast,rc2,rc4,rc5,desx} set filetype=markdown
autocmd BufRead *.html
    \ if getline(1) =~ '^\(%\|<[%&].*>\)' |
    \     set filetype=mason |
    \ endif
if has("autocmd")
  au  BufNewFile,BufRead *.mustache,*.hogan,*.hulk,*.hjs set filetype=html.mustache syntax=mustache | runtime! ftplugin/mustache.vim ftplugin/mustache*.vim ftplugin/mustache/*.vim
  au  BufNewFile,BufRead *.handlebars,*.hbs set filetype=html.handlebars syntax=mustache | runtime! ftplugin/mustache.vim ftplugin/mustache*.vim ftplugin/mustache/*.vim
endif
au BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/*,*/nginx/vhosts.d/*,nginx.conf if &ft == '' | setfiletype nginx | endif
au BufNewFile,BufRead *.nim,*.nims,*.nimble set filetype=nim
au! BufRead,BufNewFile *.cl set filetype=opencl
au BufRead,BufNewFile *.items set filetype=openhab-items syntax=openhab
au BufRead,BufNewFile *.rules set filetype=openhab-rules syntax=openhab
au BufRead,BufNewFile *.persist set filetype=openhab-persist syntax=openhab
au BufRead,BufNewFile *.sitemap set filetype=openhab-sitemap syntax=openhab
au BufRead,BufNewFile *.things set filetype=openhab-things syntax=openhab
function! s:DetectPerl6()
  let line_no = 1
  let eof     = line('$')
  let in_pod  = 0
  while line_no <= eof
    let line    = getline(line_no)
    let line_no = line_no + 1
    if line =~ '^=\w'
      let in_pod = 1
    elseif line =~ '^=\%(end\|cut\)'
      let in_pod = 0
    elseif !in_pod
      let line = substitute(line, '#.*', '', '')
      if line =~ '^\s*$'
        continue
      endif
      if line =~ '^\s*\%(use\s\+\)\=v6\%(\.\d\%(\.\d\)\=\)\=;'
        set filetype=perl6 " we matched a 'use v6' declaration
      elseif line =~ '^\s*\%(\%(my\|our\)\s\+\)\=\%(unit\s\+\)\=\(module\|class\|role\|enum\|grammar\)'
        set filetype=perl6 " we found a class, role, module, enum, or grammar declaration
      endif
      break " we either found what we needed, or we found a non-POD, non-comment,
            " non-Perl 6 indicating line, so bail out
    endif
  endwhile
endfunction
autocmd BufReadPost *.pl,*.pm,*.t call s:DetectPerl6()
autocmd BufNew,BufNewFile,BufRead *.nqp setf perl6
autocmd BufNewFile,BufRead *.proto setfiletype proto
autocmd BufNewFile,BufReadPost *.pug set filetype=pug
autocmd BufNewFile,BufReadPost *.jade set filetype=pug
au! BufRead,BufNewFile *.pp setfiletype puppet
au! BufRead,BufNewFile Puppetfile setfiletype ruby
function! s:setf(filetype) abort
  if &filetype !=# a:filetype
    let &filetype = a:filetype
  endif
endfunction
au BufNewFile,BufRead Appraisals		call s:setf('ruby')
au BufNewFile,BufRead .autotest			call s:setf('ruby')
au BufNewFile,BufRead *.axlsx			call s:setf('ruby')
au BufNewFile,BufRead [Bb]uildfile		call s:setf('ruby')
au BufNewFile,BufRead Capfile,*.cap		call s:setf('ruby')
au BufNewFile,BufRead Cheffile			call s:setf('ruby')
au BufNewFile,BufRead Berksfile			call s:setf('ruby')
au BufNewFile,BufRead Podfile,*.podspec		call s:setf('ruby')
au BufNewFile,BufRead Guardfile,.Guardfile	call s:setf('ruby')
au BufNewFile,BufRead *.jbuilder		call s:setf('ruby')
au BufNewFile,BufRead KitchenSink		call s:setf('ruby')
au BufNewFile,BufRead *.opal			call s:setf('ruby')
au BufNewFile,BufRead .pryrc			call s:setf('ruby')
au BufNewFile,BufRead Puppetfile		call s:setf('ruby')
au BufNewFile,BufRead *.rabl			call s:setf('ruby')
au BufNewFile,BufRead [rR]outefile		call s:setf('ruby')
au BufNewFile,BufRead .simplecov		call s:setf('ruby')
au BufNewFile,BufRead [tT]horfile,*.thor	call s:setf('ruby')
au BufNewFile,BufRead [vV]agrantfile		call s:setf('ruby')
function! s:setf(filetype) abort
  if &filetype !~# '\<'.a:filetype.'\>'
    let &filetype = a:filetype
  endif
endfunction
func! s:StarSetf(ft)
  if expand("<amatch>") !~ g:ft_ignore_pat
    exe 'setf ' . a:ft
  endif
endfunc
au BufNewFile,BufRead *.erb,*.rhtml				call s:setf('eruby')
au BufNewFile,BufRead .irbrc,irbrc				call s:setf('ruby')
au BufNewFile,BufRead *.rb,*.rbw,*.gemspec			call s:setf('ruby')
au BufNewFile,BufRead *.ru					call s:setf('ruby')
au BufNewFile,BufRead Gemfile					call s:setf('ruby')
au BufNewFile,BufRead *.builder,*.rxml,*.rjs,*.ruby		call s:setf('ruby')
au BufNewFile,BufRead [rR]akefile,*.rake			call s:setf('ruby')
au BufNewFile,BufRead [rR]akefile*				call s:StarSetf('ruby')
au BufNewFile,BufRead [rR]antfile,*.rant			call s:setf('ruby')
au BufRead,BufNewFile *.rs set filetype=rust
if exists("disable_r_ftplugin")
  finish
endif
autocmd BufNewFile,BufRead *.Rprofile set ft=r
autocmd BufRead *.Rhistory set ft=r
autocmd BufNewFile,BufRead *.r set ft=r
autocmd BufNewFile,BufRead *.R set ft=r
autocmd BufNewFile,BufRead *.s set ft=r
autocmd BufNewFile,BufRead *.S set ft=r
autocmd BufNewFile,BufRead *.Rout set ft=rout
autocmd BufNewFile,BufRead *.Rout.save set ft=rout
autocmd BufNewFile,BufRead *.Rout.fail set ft=rout
autocmd BufNewFile,BufRead *.Rrst set ft=rrst
autocmd BufNewFile,BufRead *.rrst set ft=rrst
autocmd BufNewFile,BufRead *.Rmd set ft=rmd
autocmd BufNewFile,BufRead *.rmd set ft=rmd
au BufRead,BufNewFile *.sbt set filetype=sbt.scala
fun! s:DetectScala()
    if getline(1) =~# '^#!\(/usr\)\?/bin/env\s\+scalas\?'
        set filetype=scala
    endif
endfun
au BufRead,BufNewFile *.scala,*.sc set filetype=scala
au BufRead,BufNewFile * call s:DetectScala()
au BufRead,BufNewFile *.sbt setfiletype sbt.scala
au BufRead,BufNewFile *.scss setfiletype scss
au BufEnter *.scss :syntax sync fromstart
autocmd BufNewFile,BufRead *.slim setfiletype slim
autocmd BufNewFile,BufReadPost *.styl set filetype=stylus
autocmd BufNewFile,BufReadPost *.stylus set filetype=stylus
autocmd BufNewFile,BufRead *.swift set filetype=swift
au BufNewFile,BufRead *.automount set filetype=systemd
au BufNewFile,BufRead *.mount     set filetype=systemd
au BufNewFile,BufRead *.path      set filetype=systemd
au BufNewFile,BufRead *.service   set filetype=systemd
au BufNewFile,BufRead *.socket    set filetype=systemd
au BufNewFile,BufRead *.swap      set filetype=systemd
au BufNewFile,BufRead *.target    set filetype=systemd
au BufNewFile,BufRead *.timer     set filetype=systemd
au BufRead,BufNewFile *.textile set filetype=textile
autocmd BufNewFile,BufRead {.,}tmux*.conf set ft=tmux | compiler tmux
autocmd BufNewFile,BufRead *.toml,Gopkg.lock,Cargo.lock,*/.cargo/config,*/.cargo/credentials,Pipfile set filetype=toml
autocmd BufNewFile,BufRead *.twig set filetype=twig
autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
autocmd BufNewFile,BufRead *.ts  set filetype=typescript
autocmd BufNewFile,BufRead *.tsx setfiletype typescript
autocmd BufRead *.vala,*.vapi set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
au BufRead,BufNewFile *.vala,*.vapi setfiletype vala
au BufRead,BufNewFile *.vm set ft=velocity syntax=velocity
autocmd BufNewFile,BufRead *.litcoffee set filetype=litcoffee
autocmd BufNewFile,BufRead *.coffee.md set filetype=litcoffee
au BufNewFile,BufRead *.vue,*.wpy setf vue

"
" Simple format using puppet's l:indents and align hashrockets function
function! puppet#format#Format() abort
  " only allow reformatting through the gq command
  " (e.g. Vim is in normal mode)
  if mode() !=# 'n'
    " do not fall back to internal formatting
    return 0
  endif

  let l:start_lnum = v:lnum
  let l:end_lnum = v:lnum + v:count - 1

  call puppet#format#Indention(l:start_lnum, l:end_lnum)
  call puppet#format#Hashrocket(l:start_lnum, l:end_lnum)
  call puppet#format#Fallback(l:start_lnum, l:end_lnum)

  " explicitly avoid falling back to default formatting
  return 0
endfunction

""
" Format hashrockets expressions in every line in range start_lnum and
" end_lnum, both ends included
"
function! puppet#format#Hashrocket(start_lnum, end_lnum) abort
  let l:lnum = a:start_lnum
  let processed_lines = []
  while l:lnum <= a:end_lnum
    if index(processed_lines, l:lnum) ==# -1
      let line_text = getline(l:lnum)
      if line_text =~? '\v\S'
        let processed_lines += puppet#align#AlignHashrockets(l:lnum)
      else
        " empty lines make puppet#align#AlignHashrockets reprocess blocks with
        " indentation that were already processed so we just skip them
        call add(processed_lines, l:lnum)
      endif
    endif
    let l:lnum += 1
  endwhile
endfunction

""
" Format indention in every line in range start_lnum and end_lnum, both ends
" included
"
function! puppet#format#Indention(start_lnum, end_lnum) abort
  execute 'normal! ' . a:start_lnum . 'gg=' . a:end_lnum . 'gg'
endfunction

""
" Use internal vim default autoformat method for every line in range, only
" lines which exeed &widthline are formated
"
function! puppet#format#Fallback(start_lnum, end_lnum) abort
  " We shouldn't wrap lines based on textwidth if it is disabled
  if &textwidth == 0
    return
  endif

  " I'm using it to check if autoformat expand range
  let l:eof_lnum = line('$')
  let l:lnum = a:start_lnum
  let l:end_lnum = a:end_lnum

  while l:lnum <= l:end_lnum
    if strlen(getline(l:lnum)) > &textwidth
      call cursor(l:lnum)
      execute 'normal! gww'
      " Checking if autoformat expand number of lines if yes, I will extend
      " range too
      if l:eof_lnum < line('$')
        let l:end_lnum += line('$') - l:eof_lnum
        let l:eof_lnum = line('$')
      endif
    endif
    let l:lnum += 1
  endwhile

endfunction


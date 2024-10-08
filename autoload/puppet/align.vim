function! puppet#align#IndentLevel(lnum) abort
    return indent(a:lnum) / &shiftwidth
endfunction

function! puppet#align#LinesInBlock(lnum) abort
    let lines = []
    let indent_level = puppet#align#IndentLevel(a:lnum)

    let marker = a:lnum - 1
    while marker >= 1
        let line_text = getline(marker)

        if line_text =~? '\v\S'
            let line_indent = puppet#align#IndentLevel(marker)
            if line_indent < indent_level
                break
            elseif line_indent == indent_level
                call add(lines, marker)
            endif
        endif

        let marker -= 1
    endwhile

    let marker = a:lnum
    while marker <= line('$')
        let line_text = getline(marker)

        if line_text =~? '\v\S'
            let line_indent = puppet#align#IndentLevel(marker)
            if line_indent < indent_level
                break
            elseif line_indent == indent_level
                call add(lines, marker)
            endif
        endif

        let marker += 1
    endwhile

    return lines
endfunction

""
" Format lines with hashrocket (=>)
" @param a:1 a line where function should search for first hashrocket
"   expression, if param is not given, line with active cursor is used
function! puppet#align#AlignHashrockets(...) abort
    let l:lnum = get(a:, 1, line('.'))
    let lines_in_block = puppet#align#LinesInBlock(l:lnum)
    let max_left_len = 0
    let indent_str = printf('%' . indent(l:lnum) . 's', '')

    for line_num in lines_in_block
        let text_line = getline(line_num)
        " skip comment lines
        if matchstr(text_line, '\S') ==# '#'
            continue
        endif

        let data = matchlist(text_line, '^\s*\(.\{-}\S\)\s*=>\s*\(.*\)$')
        if !empty(data)
            let max_left_len = max([max_left_len, strlen(data[1])])
        endif
    endfor

    for line_num in lines_in_block
        let text_line = getline(line_num)
        " skip comment lines
        if matchstr(text_line, '\S') ==# '#'
            continue
        endif

        let data = matchlist(text_line, '^\s*\(.\{-}\S\)\s*=>\s*\(.*\)$')
        if !empty(data)
            let new_line = printf('%s%-' . max_left_len . 's => %s', indent_str, data[1], data[2])
            call setline(line_num, new_line)
        endif
    endfor

    return lines_in_block
endfunction

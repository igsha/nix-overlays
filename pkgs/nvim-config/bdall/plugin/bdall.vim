" delete all buffers except current

if exists("g:bdall")
  finish
endif

function DeleteAllBuffersAround(buf_num)
  bfirst
  let l:first1 = bufnr("%")
  let l:end1 = a:buf_num - 1
  let l:first2 = a:buf_num + 1
  let l:end2 = bufnr("$")
  if l:first1 <= l:end1
    silent exec "" . l:first1 . "," . l:end1 . "bdelete"
  endif
  if l:first2 <= l:end2
    silent exec "" . l:first2 . "," . l:end2 . "bdelete"
  endif
endfunction

command -nargs=0 Bda call DeleteAllBuffersAround(bufnr("%"))

let g:bdall = '1.0'


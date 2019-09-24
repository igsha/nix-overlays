" switch to alternate source file

if exists("g:switchalt")
  finish
endif

function s:SwitchToAlt(src_file_root, extention)
  let &l:path= '.,../**'
  if tolower(a:extention) == "h" || tolower(a:extention) == "hpp"
    try
      exec 'find ' . a:src_file_root . ".c"
    catch
      exec 'find ' . a:src_file_root . ".cpp"
    endtry
  else
    try
      exec 'find ' . a:src_file_root . ".h"
    catch
      exec 'find ' . a:src_file_root . ".hpp"
    endtry
  endif
endfunction

command -nargs=0 Iswitchalt call s:SwitchToAlt(expand("%:r"), expand("%:e"))
map <Leader>s :Iswitchalt<CR>

let g:switchalt = '1.2'

" vim: ts=2 sw=2

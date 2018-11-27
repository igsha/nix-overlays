set nocompatible
set encoding=utf-8
filetype plugin indent on  " Enable file type detection.
syntax on                  " Enable syntax highlighting.

if has("win32") || has("win64") " {{{ TMPDIR
  let $TMPDIR = $TEMP
  au GUIEnter * simalt ~x
else
  if empty($TMPDIR)
    let $TMPDIR = "/tmp"
  endif
endif
set directory=$TMPDIR
set backupdir=$TMPDIR
" }}}

set number
set softtabstop=4
set shiftwidth=4
set tabstop=4
set expandtab
set cindent
set smarttab
set ruler
set autoindent
set smartindent
set backspace=2
set modeline

let g:netrw_list_hide = '^\.'
let g:netrw_liststyle = 1

set list listchars=tab:»»,trail:·,nbsp:º

set hlsearch incsearch ignorecase smartcase
set vb t_vb= novb
set mouse=a
set hidden
set autochdir
set textwidth=200

" {{{ Key mapping
map k <c-y>
map j <c-e>
map h zh
map l zl

map <c-tab> :bn<CR>
map <c-s-tab> :bp<CR>
map gt <c-tab>
map gT <c-s-tab>

map <Space> :noh<CR>
map <C-Left> <C-W><Left>
map <C-Right> <C-W><Right>
map <C-Up> <C-W><Up>
map <C-Down> <C-W><Down>
tnoremap <Esc> <C-\><C-n>
imap <C-Space> <C-x><C-o>
" }}}

set wildmode=longest,list,full
set wildmenu
set fileencodings=utf8,cp1251,koi8-r,cp866

" omni completion
set completeopt=menu

colorscheme desert

set fileformats+=dos " http://stackoverflow.com/questions/14171254/why-would-vim-add-a-new-line-at-the-end-of-a-file

checktime

set langmap=ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.~QWERTYUIOP{}ASDFGHJKL:\\"ZXCVBNM<>
set spelllang=ru_yo,en

function MakeTagsInGitRootDir()
    let l:rootdir = system('git rev-parse --show-toplevel')
    if v:shell_error != 0
        echoerr 'Not a git directory'
        return
    endif
    let l:tagfile = substitute(l:rootdir, '\n\+$', '', '') . '/.git/tags'
    echo system('ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --exclude="*.html" -o ' . l:tagfile . ' ' . l:rootdir)
    if v:shell_error != 0
        echoerr 'Got a error' v:shell_error
    endif
    echo 'Updated tags:' l:tagfile
endfunction

command -nargs=0 MakeGitTags :call MakeTagsInGitRootDir()

function AttachGitTags()
    let l:rootdir = system('git rev-parse --show-toplevel')
    if v:shell_error != 0 | return | endif
    let l:tagfile = substitute(l:rootdir, '\n\+$', '', '') . '/.git/tags'
    let &l:tags = l:tagfile
endfunction

autocmd BufEnter *.c,*.h,*.tex,*.cpp,*.s,*.hpp :call AttachGitTags()
autocmd FileType asm setlocal formatoptions+=rol
augroup filetypedetect
    au BufRead,BufNewFile *.inc set filetype=asm
augroup END

function MakeDefaultLocalvimrc()
    let l:rootdir = system('git rev-parse --show-toplevel')
    if v:shell_error != 0
        echoerr 'Not a git directory'
        return
    endif
    let l:localvimrc_file = substitute(l:rootdir, '\n\+$', '', '') . '/.git/localvimrc'
    if filereadable(l:localvimrc_file)
        echoerr 'File ' . l:localvimrc_file . ' exists'
        return
    endif
    let l:commands = [
                \       "let project_root_dir = g:localvimrc_script_dir . '/..'",
                \       "let &l:makeprg = 'make -C ' . project_root_dir . '/build -j '"
                \    ]
    let l:result = writefile(l:commands, l:localvimrc_file, )
    if l:result != 0
        echoerr "Can't write a localvimrc to " . l:localvimrc_file
    endif
    echo "Write localvimrc to " . l:localvimrc_file
endfunction

command -nargs=0 MakeLocalvimrc :call MakeDefaultLocalvimrc()

" vim: fdm=marker:

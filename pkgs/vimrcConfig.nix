{ vimUtils, vimPlugins, fetchFromGitHub, python3Packages }:

let
  customConfigs = {
    ackConf = ''
      nnoremap <Leader>q :cclose<CR>
      nnoremap <Leader>n :cnext<CR>
      nnoremap <Leader>p :cprev<CR>
      nnoremap <Leader>o :copen<CR>
      nnoremap <Leader>g :Ack<CR>
      command -nargs=* AckWord :Ack <cword> <args>
    '';
    tagbarConf = ''
      nnoremap <Leader>t :TagbarToggle<cr>
      let g:tagbar_left = 0
      let g:tagbar_autoclose = 1
    '';
    localvimrcConf = ''
      let g:localvimrc_sandbox = 0
      let g:localvimrc_ask = 0
      let g:localvimrc_name = [ ".lvimrc", ".git/localvimrc" ]
    '';
    airlineConf = "let g:airline_section_z = '%3p%% (0x%2B) %#__accent_bold#%4l%#__restore__#:%3c'";
    hybridConf = "let g:hybrid_reduced_contrast = 1";
    buffergator = ''
      let g:buffergator_suppress_keymaps = 1
      let g:buffergator_viewport_split_policy = 'T'
      nnoremap <Leader>b :BuffergatorToggle<CR>
    '';
    color = ''
      colorscheme jellybeans
      let g:jellybeans_overrides = {'background':{'ctermbg':'none','256ctermbg':'none','guibg':'none'}}
      set background=
    '';
    jupytext = ''
      let g:jupytext_command = '${python3Packages.jupytext}/bin/jupytext'
    '';
  };
  bdall = vimUtils.buildVimPlugin {
    name = "bdall";
    src = ./nvim-config/bdall;
  };
  plantuml = vimUtils.buildVimPlugin {
    name = "plantuml";
    src = fetchFromGitHub {
      owner = "aklt";
      repo = "plantuml-syntax";
      rev = "41eeca5";
      sha256 = "1v11dj4vwk5hyx0zc8qkl0a5wh91zfmwhcq2ndl8zwp78h9yf5wr";
    };
  };
  smarthomekey = vimUtils.buildVimPlugin {
    name = "smarthomekey";
    src = builtins.fetchTarball https://api.github.com/repos/chenkaie/smarthomekey.vim/tarball/master;
  };
  jellybeans = vimUtils.buildVimPlugin {
    name = "jellybeans";
    src = builtins.fetchTarball https://api.github.com/repos/nanotech/jellybeans.vim/tarball/master;
  };
  jupytext-vim = vimUtils.buildVimPlugin {
    name = "jupytext-vim";
    src = builtins.fetchTarball https://api.github.com/repos/goerz/jupytext.vim/tarball/master;
  };

in rec {
  customRC = ''
    ${builtins.readFile ./nvim-config/init.vim}
    ${builtins.concatStringsSep "\n" (builtins.attrValues customConfigs)}
  '';

  packages.myVimPackage = {
    start = with vimPlugins; [
      ack-vim
      supertab
      tagbar
      vim-localvimrc
      vim-dirdiff
      denite
      airline
      vim-nix
      multiple-cursors
      bdall
      plantuml
      vim-buffergator
      vim-grammarous
      smarthomekey
      jellybeans
      jupytext-vim
      csv
      editorconfig-vim
    ];
    opt = [ ];
  };
}

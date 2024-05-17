call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

Plug 'github/copilot.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.6' }
" or                                , { 'branch': '0.1.x' }
Plug 'norcalli/nvim-colorizer.lua'
Plug 'sheerun/vim-polyglot'

call plug#end()

" Use jk to escape from insert mode
inoremap jk <esc>
command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')

" Prettier conformity
" Set tab width to 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab  " Convert tabs to spaces

" Find files using Telescope command-line sugar.
nnoremap ff <cmd>Telescope find_files<cr>
nnoremap fg <cmd>Telescope live_grep<cr>
nnoremap fb <cmd>Telescope buffers<cr>
nnoremap fh <cmd>Telescope help_tags<cr>

" Case insentive search
function! CaseInsensitiveLiveGrep()
  lua require('telescope.builtin').live_grep({ grep_open_opts = '-i' })
endfunction
command! CaseInsensitiveGrep call CaseInsensitiveLiveGrep()

nnoremap fig :CaseInsensitiveGrep<cr>

" Jump to the definition
nmap <silent> gd <Plug>(coc-definition)

" Jump to declaration
nmap <silent> gD <Plug>(coc-declaration)

" Find references
nmap <silent> gr <Plug>(coc-references)

" Rename symbol
nmap <leader>rn <Plug>(coc-rename)

" Format code
nmap <leader>f :CocCommand format<CR>

" Code actions
nmap <leader>a <Plug>(coc-codeaction)

" See documentation
" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Line numbers by default
set number
set relativenumber

" Save session based on git branch
function! SaveGitBranchSession()
  if system('git rev-parse --is-inside-work-tree') == "true\n"
    let l:branch = system("git rev-parse --abbrev-ref HEAD")
    let l:branch = substitute(l:branch, '\n', '', '')
    " Replace slashes with underscores or another suitable character
    let l:branch = substitute(l:branch, '/', '_', 'g')
    let l:session_dir = $HOME . '/.config/nvim/sessions/'
    if !isdirectory(l:session_dir)
      call mkdir(l:session_dir)
    endif
    let l:session_file = l:session_dir . l:branch . '.vim'
    execute 'mksession! ' . l:session_file . ' " Save all settings including syntax highlighting'
  else
    echo "Not inside a Git repository"
  endif
endfunction

function! LoadGitBranchSession()
  if system('git rev-parse --is-inside-work-tree') == "true\n"
    let l:branch = system("git rev-parse --abbrev-ref HEAD")
    let l:branch = substitute(l:branch, '\n', '', '')
    " Replace slashes with underscores or another suitable character
    let l:branch = substitute(l:branch, '/', '_', 'g')
    let l:session_file = $HOME . '/.config/nvim/sessions/' . l:branch . '.vim'
    if filereadable(l:session_file)
      execute 'source' l:session_file
    else
      echo "Session file not found: " . l:session_file
    endif
  else
    echo "Not inside a Git repository"
  endif
endfunction
set sessionoptions+=options,globals,localoptions

autocmd VimLeave * call SaveGitBranchSession()
autocmd VimEnter * if argc() == 0 | call LoadGitBranchSession() | endif


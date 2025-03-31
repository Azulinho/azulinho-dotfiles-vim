


" my setup from here

execute pathogen#infect()
syntax on
filetype plugin indent on

let g:mapleader = "\<Space>"
let g:maplocalleader = ","
set tabstop=2 shiftwidth=2 expandtab
set encoding=UTF-8
set t_Co=256
set nowrap
set hidden
set scrolloff=5
set matchpairs+=<:>
set autoread
set history=1000
set backspace=indent,eol,start
set splitright
set number
set relativenumber
set autoindent
set nostartofline
set noerrorbells
set novisualbell
set ignorecase
set smartcase
set incsearch
" when enabled, it 'sticks' highliight after an easymotion jump
"set hlsearch
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround
set textwidth=0
set formatoptions-=t
set nobackup
set nowritebackup
set cmdheight=1
set updatetime=300
let &t_SI.="\e[5 q"
let &t_SR.="\e[4 q"
let &t_EI.="\e[1 q"

set background=light
colorscheme PaperColor

" general keymapping
nnoremap <leader>sp :set paste!<CR>
nnoremap <leader>snp :set nopaste!<CR>

" FormatFile
augroup FormatFile
  autocmd!
  autocmd BufEnter vifmrc,*.vifm set filetype=vim
  autocmd BufEnter * set fo-=c fo-=r fo-=o
  autocmd BufEnter *.py set ai ts=4 sw=4 sts=4 et
  autocmd BufEnter *.md setlocal conceallevel=0
augroup end


"simple-commenter
let g:scomment_default_mapping = 1
map <silent>,,           <Plug>(one-line-comment)

" AnyJump
  let g:any_jump_disable_default_keybindings = 1
  " Normal mode: Jump to definition under cursor
  nnoremap <leader>j :AnyJump<CR>

  " Visual mode: jump to selected text in visual mode
  xnoremap <leader>j :AnyJumpVisual<CR>


   " Show line numbers in search results
  let g:any_jump_list_numbers = 1

  " Auto search references
  let g:any_jump_references_enabled = 1

  " Auto group results by filename
  let g:any_jump_grouping_enabled = 1

  " Amount of preview lines for each search result
  let g:any_jump_preview_lines_count = 5

  " Max search results, other results can be opened via [a]
  let g:any_jump_max_search_results = 10

  " Preferred search engine: rg or ag
  let g:any_jump_search_preferred_engine = 'rg'


  " Custom ignore files
  " default is: ['*.tmp', '*.temp']
  let g:any_jump_ignored_files = ['*.tmp', '*.temp', '.git']

  " Search references only for current file type
  " (default: false, so will find keyword in all filetypes)
  let g:any_jump_references_only_for_current_filetype = 1

  " Disable search engine ignore vcs untracked files
  " (default: false, search engine will ignore vcs untracked files)
  let g:any_jump_disable_vcs_ignore = 1


" vim-test

	nmap <silent> <leader>t :TestNearest<CR>
	nmap <silent> <leader>T :TestFile<CR>
	nmap <silent> <leader>a :TestSuite<CR>
	nmap <silent> <leader>l :TestLast<CR>
	nmap <silent> <leader>g :TestVisit<CR>


" vim-sneak
	map f <Plug>Sneak_s
	map F <Plug>Sneak_S

	map f <Plug>Sneak_f
	map F <Plug>Sneak_F
	map t <Plug>Sneak_t
	map T <Plug>Sneak_T


" ultisnips

	" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
	" - https://github.com/Valloric/YouCompleteMe
	" - https://github.com/nvim-lua/completion-nvim
	let g:UltiSnipsExpandTrigger="<tab>"
	let g:UltiSnipsJumpForwardTrigger="<c-b>"
	let g:UltiSnipsJumpBackwardTrigger="<c-z>"

	" If you want :UltiSnipsEdit to split your window.
  let g:UltiSnipsEditSplit="vertical"


" ale
	" Set this variable to 1 to fix files when you save them.
	let g:ale_fix_on_save = 1

	" Enable completion where available.
	" This setting must be set before ALE is loaded.
	"
	" You should not turn this setting on if you wish to use ALE as a completion
	" source for other completion plugins, like Deoplete.
	let g:ale_completion_enabled = 1

	" Set this. Airline will handle the rest.
	let g:airline#extensions#ale#enabled = 1

" fuzzy
  let g:fuzzyy_enable_mappings = 0
  let g:fuzzyy_dropdown = 0
  let g:fuzzyy_respect_gitignore = 1
  let g:fuzzyy_include_hidden = 0
  let g:fuzzyy_root_patterns = ['.git', 'package.json', 'pyproject.toml']
  let g:fuzzyy_exclude_file = ['*.swp', 'tags', '.terraform', '.tags', 'venv', '.venv']


" vim-navigator
  let g:navigator = {'prefix':'<tab><tab>'}
  nnoremap <silent><tab><tab> :Navigator g:navigator<cr>
  vnoremap <silent><tab><tab> :NavigatorVisual g:navigator_visual<cr>

  let g:navigator =  {}
  " (s)earch
  let g:navigator.s = { 'name' : '+search' }
    let g:navigator.s.f = [':FuzzyFilesRoot', 'search-file']
    let g:navigator.s.w = [":execute 'FuzzyGrepRoot ' . expand('<cword>')", 'search-Word']
    let g:navigator.s.b = [':FuzzyMruRoot','search-buffers']
    let g:navigator.s.c = [':FuzzyCommands', 'search-commands']
    let g:navigator.s.t = [':FuzzyTagsRoot','search-tags']
  " (c)code
  let g:navigator.c = { 'name' : '+code' }
    let g:navigator.c.d = [':ALEGoToDefinition','go-to-definition']
    let g:navigator.c.r = [':ALEFindReferences','find-references']
    let g:navigator.c.h = [':ALEHover','hover']
    let g:navigator.c.s = [":execute 'ALESymbolSearch ' . expand('<cword>')",'symbol-search']
    let g:navigator.c.c = ['<Plug>(one-line-comment)','Comment-out/toggle']
    let g:navigator.c.j = [":AnyJump",'AnyJump-to-definition']

  let g:navigator_visual =  {}
  " (c)code
  let g:navigator_visual.c = { 'name' : '+code' }
    let g:navigator_visual.c.c = ['<Plug>(one-line-comment)','Comment-out/toggle']
    let g:navigator_visual.c.j = [":AnyJump",'AnyJump-to-definition']


" easyMotion
  let g:EasyMotion_do_mapping = 0
  let g:EasyMotion_smartcase = 1
  let g:EasyMotion_landing_highlight = 0
  nmap <Leader>bm <Plug>(easymotion-in-f2)
  map  / <Plug>(easymotion-sn)
  omap / <Plug>(easymotion-tn)
  " These `n` and `N` mappings are optional, but they are useful for
  " repeating the last search in the forward or backward direction.
  nmap n <Plug>(easymotion-next)
  nmap N <Plug>(easymotion-prev)




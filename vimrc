


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


function! GitCloneDepth1(repo_url, target_path)
    let clone_command = 'cd bundle && git clone --depth 1 ' . a:repo_url . ' ' . a:target_path
    let update_command = 'cd bundle && git -C ' . a:target_path . ' pull origin master'
    let is_git_repo = system('cd bundle && git -C ' . a:target_path . ' rev-parse --is-inside-work-tree')

    " Check if the target directory already exists
    if isdirectory('bundle/' . a:target_path)

      if is_git_repo == "true\n"
          call system(update_command)
          echo "Git repository updated successfully"
          return
      else
          echo "Directory exists but is not a Git repository. Clone the repository manually."
          return
      endif
    else
      call system(clone_command)
    endif
endfunction

function PluginInstall()
  call GitCloneDepth1('https://github.com/mileszs/ack.vim.git', 'ack.vim')
  call GitCloneDepth1('https://github.com/dense-analysis/ale.git', 'ale')
  call GitCloneDepth1('https://github.com/junegunn/vim-easy-align.git', 'Align')
  call GitCloneDepth1('https://github.com/pechorin/any-jump.vim.git', 'any-jump.vim')
  call GitCloneDepth1('https://github.com/romainl/Apprentice.git', 'Apprentice')
  call GitCloneDepth1('https://github.com/metakirby5/codi.vim.git', 'codi.vim')
  call GitCloneDepth1('https://github.com/github/copilot.vim.git', 'copilot.vim')
  call GitCloneDepth1('https://github.com/Raimondi/delimitMate.git', 'delimitMate')
  call GitCloneDepth1('https://github.com/editorconfig/editorconfig-vim.git', 'editorconfig-vim')
  call GitCloneDepth1('https://github.com/morhetz/gruvbox.git', 'gruvbox')
  call GitCloneDepth1('https://github.com/sjl/gundo.vim.git', 'gundo.vim')
  call GitCloneDepth1('https://github.com/preservim/nerdtree.git', 'nerdtree')
  call GitCloneDepth1('https://github.com/NLKNguyen/papercolor-theme.git', 'papercolor-theme')
  call GitCloneDepth1('https://github.com/c9s/simple-commenter.vim.git', 'simple-commenter.vim')
  call GitCloneDepth1('https://github.com/tek256/simple-dark.git', 'simple-dark')
  call GitCloneDepth1('https://github.com/preservim/tagbar.git', 'tagbar')
  call GitCloneDepth1('https://github.com/SirVer/ultisnips.git', 'ultisnips')
  call GitCloneDepth1('https://github.com/jreybert/vimagit.git', 'vimagit')
  call GitCloneDepth1('https://github.com/madox2/vim-ai.git', 'vim-ai')
  call GitCloneDepth1('https://github.com/vim-airline/vim-airline.git', 'vim-airline')
  call GitCloneDepth1('https://github.com/vim-airline/vim-airline-themes.git', 'vim-airline-themes')
  call GitCloneDepth1('https://github.com/blueyed/vim-diminactive.git', 'vim-diminactive')
  call GitCloneDepth1('https://github.com/easymotion/vim-easymotion.git', 'vim-easymotion')
  call GitCloneDepth1('https://github.com/airblade/vim-gitgutter.git', 'vim-gitgutter')
  call GitCloneDepth1('https://github.com/fatih/vim-go.git', 'vim-go')
  call GitCloneDepth1('https://github.com/ludovicchabant/vim-gutentags.git', 'vim-gutentags')
  call GitCloneDepth1('https://github.com/preservim/vim-indent-guides.git', 'vim-indent-guides')
  call GitCloneDepth1('https://github.com/skywind3000/vim-navigator.git', 'vim-navigator')
  call GitCloneDepth1('https://github.com/sheerun/vim-polyglot.git', 'vim-polyglot')
  call GitCloneDepth1('https://github.com/skywind3000/vim-quickui.git', 'vim-quickui')
  call GitCloneDepth1('https://github.com/mhinz/vim-signify.git', 'vim-signify')
  call GitCloneDepth1('https://github.com/honza/vim-snippets.git', 'vim-snippets')
  call GitCloneDepth1('https://github.com/mhinz/vim-startify.git', 'vim-startify')
  call GitCloneDepth1('https://github.com/vim-test/vim-test.git', 'vim-test')
  call GitCloneDepth1('https://github.com/vimwiki/vimwiki.git', 'vimwiki')
  call GitCloneDepth1('https://github.com/Donaldttt/fuzzyy.git', 'fuzzy')
endfunction

command! PluginInstall call PluginInstall()

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

  let g:ale_go_go_executable = 'go'
  let g:ale_go_golangci_lint_executable = 'golangci-lint'
  let g:ale_go_gopls_executable = 'gopls'
  let g:ale_go_gofmt_executable = 'gofmt'

  let g:ale_terraform_terraform_executable = 'terraform'
  let g:ale_terraform_tflint_executable = 'tflint'
  let g:ale_terraform_tfsec_executable = 'tfsec'
  let g:ale_terraform_tfdocs_executable = 'terraform-docs'
  let g:ale_terraform_ls_executable = 'terraform-ls'
  let g:ale_terraform_ls_options = 'serve'
  let g:ale_terraform_langserver_executable = 'terraform-lsp'

  let g:ale_linters = {
        "\ 'terraform': ['terraform_ls', 'terraform_lsp', 'tflint', 'tfsec'],
        \ 'terraform': ['terraform_lsp', 'tflint', 'tfsec'],
        \ 'go': ['gopls', 'golangci_lint'],
        \ 'python': ['mypy', 'pylint', 'pyright', 'black'],
   \}
  let g:ale_fixers = {
        \ 'terraform': ['terraform'],
        \ 'go': ['gofmt'],
        \ 'python': ['black'],
   \} 

  let g:ale_linters_explicit = 1
  let g:ale_fixers_explicit = 1
  let g:ale_lint_on_enter = 0
  let g:ale_lint_on_save = 1
  let g:ale_lint_on_filetype_changed = 0
  let g:ale_lint_on_text_changed = 0
  let g:ale_lint_on_insert_leave = 0
  let g:ale_lint_on_cursor_hold = 0
  let g:ale_lint_delay = 0

" fuzzy
  let g:fuzzyy_enable_mappings = 0
  let g:fuzzyy_dropdown = 0
  let g:fuzzyy_respect_gitignore = 1
  let g:fuzzyy_include_hidden = 0
  let g:fuzzyy_root_patterns = ['.git', 'package.json', 'pyproject.toml']
  let g:fuzzyy_exclude_file = ['*.swp', 'tags', '.terraform.*', '.tags', 'venv', '.venv']
  let g:fuzzyy_exclude_dir = ['node_modules', 'vendor', 'venv', '.venv', '.git', '.terraform']

" vim-navigator
  let g:navigator = {'prefix':'<tab><tab>'}
  nnoremap <silent><tab><tab> :Navigator g:navigator<cr>
  vnoremap <silent><tab><tab> :NavigatorVisual g:navigator_visual<cr>

  let g:navigator =  {}

  " (s)earch
  let g:navigator.s = { 'name' : '+search' }
    let g:navigator.s.f = [':FuzzyFilesRoot', 'search-file']

    let g:navigator.s.w = [":execute 'FuzzyGrepRoot ' . expand('<cword>')", 'search-current-word']
    let g:navigator.s.W = ["FuzzyGrepRoot", 'search-any-Word']

    let g:navigator.s.b = [':FuzzyMruRoot','search-buffers']

    let g:navigator.s.c = [':FuzzyCommands', 'search-commands']
    let g:navigator.s.t = [":execute 'FuzzyGrepRoot ' . ':o:'", 'search-tasks-todo']
    let g:navigator.s.T = [":execute 'FuzzyGrepRoot ' . ':WAIT'", 'search-tasks-waiting']

  " (c)code
  let g:navigator.c = { 'name' : '+code' }
    let g:navigator.c.d = [':ALEGoToDefinition','go-to-definition']
    let g:navigator.c.h = [':ALEHover','hover']
    let g:navigator.c.r = [':ALEFindReferences','find-references']
    let g:navigator.c.s = [":execute 'ALESymbolSearch ' . expand('<cword>')",'symbol-search']
    let g:navigator.c.c = ['<Plug>(one-line-comment)','Comment-out/toggle']
    let g:navigator.c.j = [":AnyJump",'AnyJump-to-definition']
    let g:navigator.c.t = [":TagbarToggle",'TagBar']
    let g:navigator.c.t = [':FuzzyTagsRoot','search-tags']

  let g:navigator_visual =  {}
  " (c)code
  let g:navigator_visual.c = { 'name' : '+code' }
    let g:navigator_visual.c.c = ['<Plug>(one-line-comment)','Comment-out/toggle']


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


  " guttentags
  let g:guttentags_enabled=1
  let g:guttentags_ctags_executable='ctags'

  " magit
  let g:magit_git_cmd = 'git'

" =============================================================================
" Vim Configuration File
" =============================================================================
" Author: [Your Name]
" Description: Comprehensive Vim configuration with plugins and LSP support
" Last Updated: $(date +%Y-%m-%d)
" =============================================================================

" =============================================================================
" 1. PLUGIN MANAGEMENT
" =============================================================================

" Pathogen plugin manager setup
execute pathogen#infect()
syntax on
filetype plugin indent on

" Plugin installation function
function! GitCloneDepth1(repo_url, target_path)
    let clone_command = 'cd bundle && git clone --depth 1 ' . a:repo_url . ' ' . a:target_path
    let update_command = 'cd bundle && git -C ' . a:target_path . ' pull origin master'
    let is_git_repo = system('cd bundle && git -C ' . a:target_path . ' rev-parse --is-inside-work-tree')

    " Check if the target directory already exists
    if isdirectory('bundle/' . a:target_path)
        if is_git_repo == "true\n"
            echo "Updating: " . a:repo_url
            call system(update_command)
            echo "Git repository updated successfully"
            return
        else
            echo "Directory exists but is not a Git repository. Clone the repository manually."
            return
        endif
    else
        echo "Cloning: " . a:repo_url
        call system(clone_command)
    endif
endfunction

" Install all plugins
function! PluginInstall()
    " NEW PLUGINS - Replace coc.nvim
    call GitCloneDepth1('https://github.com/dense-analysis/ale.git', 'ale')

    call GitCloneDepth1('https://github.com/metakirby5/codi.vim.git', 'codi.vim')
    call GitCloneDepth1('https://github.com/editorconfig/editorconfig-vim.git', 'editorconfig-vim')
    call GitCloneDepth1('https://github.com/preservim/nerdtree.git', 'nerdtree')
    call GitCloneDepth1('https://github.com/NLKNguyen/papercolor-theme.git', 'papercolor-theme')
    call GitCloneDepth1('https://github.com/preservim/tagbar.git', 'tagbar')
    call GitCloneDepth1('https://github.com/morhetz/gruvbox.git', 'gruvbox')
    call GitCloneDepth1('https://github.com/jreybert/vimagit.git', 'vimagit')
    call GitCloneDepth1('https://github.com/easymotion/vim-easymotion.git', 'vim-easymotion')
    call GitCloneDepth1('https://github.com/airblade/vim-gitgutter.git', 'vim-gitgutter')
    call GitCloneDepth1('https://github.com/fatih/vim-go.git', 'vim-go')

    call GitCloneDepth1('https://github.com/skywind3000/vim-navigator.git', 'vim-navigator')
    call GitCloneDepth1('https://github.com/sheerun/vim-polyglot.git', 'vim-polyglot')
    call GitCloneDepth1('https://github.com/mhinz/vim-startify.git', 'vim-startify')
    call GitCloneDepth1('https://github.com/Exafunction/windsurf.vim.git', 'windsurf.vim')
    call GitCloneDepth1('https://github.com/puremourning/vimspector.git', 'vimspector')
    call GitCloneDepth1('https://github.com/tpope/vim-fugitive.git', 'vim-fugitive')
    call GitCloneDepth1('https://github.com/preservim/vimux.git', 'vimux')
    call GitCloneDepth1('https://github.com/lervag/wiki.vim.git', 'wiki')
    call GitCloneDepth1('https://github.com/mhinz/vim-grepper', 'vim-grepper')

    " REPLACEMENT PLUGINS - Replacing custom functions
    call GitCloneDepth1('https://github.com/vim-airline/vim-airline.git', 'vim-airline')
    call GitCloneDepth1('https://github.com/tpope/vim-commentary.git', 'vim-commentary')
    call GitCloneDepth1('https://github.com/vim-fuzzbox/fuzzbox.vim.git', 'fuzzbox.vim')
    call GitCloneDepth1('https://github.com/ludovicchabant/vim-gutentags.git', 'vim-gutentags')
    call GitCloneDepth1('https://github.com/tpope/vim-eunuch.git', 'vim-eunuch')
    call GitCloneDepth1('https://github.com/jiangmiao/auto-pairs.git', 'auto-pairs')
endfunction

" Install plugins command
command! PluginInstall call PluginInstall()

" =============================================================================
" 2. BASIC VIM SETTINGS
" =============================================================================

" Leader keys
let g:mapleader = "\<Space>"
let g:maplocalleader = ","

" Encoding and file settings
set encoding=UTF-8
set t_Co=256
set autoread
set history=1000
set backspace=indent,eol,start

" Indentation and tabs
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround
set autoindent
set smartindent

" Search settings
set ignorecase
set smartcase
set incsearch
" set hlsearch  " Uncomment to enable search highlighting

" UI settings
set number
set relativenumber
set scrolloff=5
set matchpairs+=<:>
set nowrap
set textwidth=0
set formatoptions-=t
set cmdheight=1
set updatetime=300
set hidden
set splitright
set nostartofline

" Cursor settings
let &t_SI.="\e[5 q"  " Insert mode cursor
let &t_SR.="\e[4 q"  " Replace mode cursor
let &t_EI.="\e[1 q"  " Normal mode cursor

" File handling
set nobackup
set nowritebackup
set noswapfile

" Error handling
set noerrorbells
set novisualbell

" Path settings
set path+=$PWD/**

" Indent visualization using native Vim features
set list
set listchars=lead:·,space:·,tab:»·,trail:·,extends:>,precedes:<,nbsp:+
highlight SpecialKey ctermfg=DarkGray guifg=DarkGray

" =============================================================================
" 3. BACKGROUND AND COLORS
" =============================================================================

" Automatic background switching based on time of day
function! SetBackgroundBasedOnTime()
    let l:hour = strftime("%H")
    if l:hour >= 18 || l:hour < 6
        " Evening/Night: 6 PM to 6 AM
        set background=dark
    else
        " Day: 6 AM to 6 PM
        set background=light
    endif
endfunction

" Manual background toggle function
function! ToggleBackground()
    if &background == "light"
        set background=dark
        echo "Switched to dark background"
    else
        set background=light
        echo "Switched to light background"
    endif
    " Reapply colorscheme to reflect the change
    colorscheme PaperColor
endfunction

" Set background automatically on startup
call SetBackgroundBasedOnTime()

" Colorscheme
colorscheme PaperColor

" =============================================================================
" 4. STATUS LINE AND UI
" =============================================================================

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1

" =============================================================================
" 5. KEY MAPPINGS
" =============================================================================

" Basic mappings
nnoremap <leader>sp :set paste!<CR>
nnoremap <leader>snp :set nopaste!<CR>
nnoremap <leader>w :w!<CR>

" Auto-closing delimiters (auto-pairs)
" auto-pairs handles this automatically
" Background toggle
nmap <leader>bg :call ToggleBackground()<CR>

" ===== LSP AND ALE KEY MAPPINGS =====
" Diagnostic Navigation (ALE)
nmap <silent> [g <Plug>(ale_previous_wrap)
nmap <silent> ]g <Plug>(ale_next_wrap)

" LSP Navigation (ALE)
nmap <silent> gd <Plug>(ale_go_to_definition)
nmap <silent> gy <Plug>(ale_go_to_type_definition)
nmap <silent> gi <Plug>(ale_go_to_implementation)
nmap <silent> gr <Plug>(ale_find_references)

" Hover Documentation
nnoremap <silent> K :ALEHover<CR>

" Rename
nmap <leader>rn <Plug>(ale_rename)

" Code Actions
nmap <leader>ca :ALECodeAction<CR>
xmap <leader>ca :ALECodeAction<CR>

" Format
nmap <leader>f :ALEFix<CR>
xmap <leader>f :ALEFix<CR>

" Organize Imports
command! -nargs=0 OR :ALECodeAction

" Document Symbols - use :TagbarToggle instead

" Workspace Symbols
nmap <silent> gS :ALESymbolSearch<CR>

" ===== FUZZBOX KEY MAPPINGS =====
" File search
nnoremap <leader>ff :FuzzyFiles<CR>
" Buffer search
nnoremap <leader>fb :FuzzyBuffers<CR>
" Search in current buffer
nnoremap <leader>fl :FuzzyInBuffer<CR>
" Search all lines across buffers
nnoremap <leader>fa :FuzzyGrep<CR>

" ===== COMMENTARY KEY MAPPINGS =====
" Toggle comment on current line
nmap <leader>c <Plug>Commentary
" Toggle comment on selection
xmap <leader>c <Plug>Commentary
" Toggle comment with motions
nmap <leader>cc <Plug>CommentaryLine

" =============================================================================
" 6. SEARCH AND NAVIGATION FUNCTIONS
" =============================================================================

function! FzgrepCurrentWord()
    execute 'FuzzyGrep ' . expand('<cword>')
endfunction

function! FzInBufferCurrentWord()
    execute 'FuzzyInBuffer ' . expand('<cword>')
endfunction



" =============================================================================
" 7. COMMANDS
" =============================================================================



" =============================================================================
" 8. PLUGIN CONFIGURATIONS
" =============================================================================


" ===== ALE CONFIGURATION =====
" ALE linters for different filetypes
let g:ale_linters = {
    \ 'go': ['gopls', 'govet'],
    \ 'python': ['pylint', 'mypy'],
    \ 'javascript': ['eslint'],
    \ 'typescript': ['eslint', 'tsserver'],
    \ 'json': ['jsonlint'],
    \ 'yaml': ['yamllint'],
    \ 'html': ['htmlhint'],
    \ 'css': ['stylelint'],
    \ 'vim': ['vint'],
    \ 'tex': ['chktex'],
    \ 'java': ['javac'],
    \ 'terraform': ['tflint'],
    \ }

" ALE fixers for formatting
let g:ale_fixers = {
    \ '*': ['remove_trailing_lines', 'trim_whitespace'],
    \ 'javascript': ['prettier', 'eslint'],
    \ 'typescript': ['prettier', 'eslint'],
    \ 'python': ['black', 'isort'],
    \ 'go': ['gofmt'],
    \ 'json': ['prettier'],
    \ 'yaml': ['prettier'],
    \ 'html': ['prettier'],
    \ 'css': ['prettier']
    \ }

" ALE settings
let g:ale_linters_explicit = 0
let g:ale_fix_on_save = 0
let g:ale_sign_error = 'E'
let g:ale_sign_warning = 'W'
let g:ale_sign_info = 'I'
let g:ale_sign_style_error = 'S'
let g:ale_sign_style_warning = 'w'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_virtualtext_cursor = 1

" Enable ALE completion engine (replaces asyncomplete + vim-lsp)
let g:ale_completion_enabled = 1
" ===== Comment Toggle (vim-commentary) =====
" vim-commentary provides: gcc (toggle line), gc (toggle selection), gc{motion}
" ===== Vim Navigator =====
let g:navigator = {'prefix':'<tab><tab>'}
nnoremap <silent><tab><tab> :Navigator g:navigator<cr>
vnoremap <silent><tab><tab> :Navigator g:navigator_visual<cr>

let g:navigator = {}

" +search section
let g:navigator.s = { 'name' : '+search' }
let g:navigator.s.f = [':FuzzyFiles', 'search-file']
let g:navigator.s.w = [':call FzgrepCurrentWord()', 'search-current-word']
let g:navigator.s.W = [':FuzzyGrep', 'search-prompt']
let g:navigator.s.b = [':FuzzyBuffers', 'search-buffers']
let g:navigator.s.c = [':FuzzyCommands', 'search-commands']
let g:navigator.s.t = [':SearchChecklist', 'search-tasks-todo']
let g:navigator.s.T = [':SearchTodo', 'search-tasks-waiting']

" +Buffer section
let g:navigator.b = { 'name' : '+Buffer' }
let g:navigator.b.w = [':call FzInBufferCurrentWord()', 'search-word-in-buffer']
let g:navigator.b.W = [':FuzzyInBuffer', 'search-prompt-in-buffer']

" +code section - UPDATED for new plugins
let g:navigator.c = { 'name' : '+code' }
let g:navigator.c.d = ['<Plug>(ale_go_to_definition)','go-to-definition']
let g:navigator.c.h = ['<Plug>(ale_hover)','hover']
let g:navigator.c.r = ['<Plug>(ale_find_references)','find-references']
let g:navigator.c.s = [':ALEFindReferences','symbol-search']
let g:navigator.c.c = ['call ToggleComment()', 'Comment-out/toggle']     " FIXED
let g:navigator.c.t = [":TagbarToggle",'TagBar']
let g:navigator.c.g = [':FuzzyTags', 'search-tags']

" +Debug section - UNCHANGED (vimspector still works)
let g:navigator.d = { 'name' : '+Debug' }
let g:navigator.d.L = [':call vimspector#Launch()','Vimspector-launch']
let g:navigator.d.t = [':call vimspector#ToggleBreakpoint()','Vimspector-Toggle-Breakpoint']
let g:navigator.d.c = [':call vimspector#Continue()','Vimspector-Continue']
let g:navigator.d.T = [':call vimspector#ClearBreakpoint()','Vimspector-Clear-Breakpoint']
let g:navigator.d.i = [':call vimspector#StepInto()','Vimspector-Step-Into']
let g:navigator.d.n = [':call vimspector#StepOver()','Vimspector-Step-Over']
let g:navigator.d.o = [':call vimspector#StepOut()','Vimspector-Step-Out']
let g:navigator.d.r = [':call vimspector#Reset()','Vimspector-Reset']
let g:navigator.d.R = [':call vimspector#Restart()','Vimspector-Restart']

" +Wiki section - UNCHANGED (wiki.vim still works)
let g:navigator.w = { 'name' : '+Wiki' }
let g:navigator.w.i = [':WikiIndex','Open Wiki Index Page']

let g:navigator.w.j = {'name': '+Journal'}
let g:navigator.w.j.i = [':WikiJournalIndex', 'Open Journal Index']
let g:navigator.w.j.n = [':WikiJournal','New Journal Page']

let g:navigator.w.s = {'name': '+Search'}
let g:navigator.w.s.p = [':WikiPages','Search Wiki for a Page']
let g:navigator.w.s.t = [':WikiTags','Search Wiki for a Tag']
let g:navigator.w.s.r = [':WikiGraphRelated', 'Graph Related Map']

let g:navigator.w.l = {'name': '+Links'}
let g:navigator.w.l.l = [':WikiGraphCheckLinks', 'Check Links']
let g:navigator.w.l.o = [':WikiGraphCheckOrphans', 'Check Orphan links']
let g:navigator.w.l.b = [':WikiGraphFindBackLinks', 'Find Backlinks']
let g:navigator.w.l.t = [':WikiLinkTransform', 'Transform current link']

let g:navigator.w.a = { 'name' : '+Add' }
let g:navigator.w.a.l = [':WikiLinkAdd', 'Add Link']
let g:navigator.w.a.t = [':WikiTocGenerate', 'Create TOC']

let g:navigator.w.p = { 'name' : '+Page' }
let g:navigator.w.p.d = [':WikiPageDelete', 'Delete Page']
let g:navigator.w.p.r = [':WikiPageRename', 'Rename Page']

let g:navigator.w.t = { 'name' : '+Tag' }
let g:navigator.w.t.l = [ ':WikiTagList' , 'List Tags' ]
let g:navigator.w.t.x = [ ':WikiTagReload' , 'Reload Tags' ]
let g:navigator.w.t.r = [ ':WikiTagRename' , 'Rename Tag' ]
let g:navigator.w.t.s = [':WikiTags','Search Wiki for a Tag']

" Visual mode - UPDATED for new commenting plugin
let g:navigator_visual = {}
let g:navigator_visual.c = { 'name' : '+code' }
let g:navigator_visual.c.c = ['call ToggleComment()', 'Comment-out/toggle']   " FIXED

function! ToggleComment()
  if mode() ==# 'n'
    execute 'normal gcc'
  elseif mode() =~# '[vV]'
    execute 'normal gc'
  endif
endfunction

" ===== EasyMotion =====
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
let g:EasyMotion_landing_highlight = 0
nmap <Leader>bm <Plug>(easymotion-in-f2)


" ===== Tag Generation (gutentags) =====
" Gutentags automatically manages tag files - no configuration needed

"===== VimWiki =====
let g:vimwiki_list = [{'path': '~/vimwiki/',
    \ 'syntax': 'markdown', 'ext': 'md'}]
let g:vimwiki_global_ext = 0

" ===== Wiki =======
let g:wiki_root = '~/vimwiki'

" ===== Vim Magit =====
let g:magit_git_cmd = 'git'

" ===== Vim-Grepper =====
let g:grepper               = {}
let g:grepper.tools         = ['grep', 'git']
let g:grepper.jump          = 0
let g:grepper.open          = 1
let g:grepper.switch        = 1
let g:grepper.quickfix      = 1

" Grepper operator for visual selection
nmap gs  <plug>(GrepperOperator)
xmap gs  <plug>(GrepperOperator)

" Custom search in current buffer
nnoremap <leader>gb :Grepper -buffers -query

" Vimwiki custom search commands
command! -nargs=0 SearchChecklist call VimgrepSearchChecklist()
command! -nargs=0 SearchTodo call VimgrepSearchWaitingChecklist()

" Vimwiki search functions
function! VimgrepSearchChecklist()
    cclose
    try
        execute 'vimgrep / \[ \]/gj ~/vimwiki/**/*'
        copen
    catch
        echo "No occurrences found for the pattern: ' [ ]'"
    endtry
endfunction

function! VimgrepSearchWaitingChecklist()
    cclose
    try
        execute 'vimgrep /:WAIT:/gj ~/vimwiki/**/*'
        copen
    catch
        echo "No occurrences found for the pattern: :WAIT:"
    endtry
endfunction
command! -nargs=0 SearchTag :Grepper -noprompt -cword -query


" ===== Fugitive =====
function! Grebaseinteractive(args) abort
    let $GIT_EDITOR="sed -ie '0,/pick/ s/pick/edit/'"
    exec 'Git rebase --preserve-merges --interactive' a:args . '^'
    Grebase --edit-todo
endfunction

command! -nargs=+ -complete=customlist,fugitive#Complete Grebaseinteractive :call g:Grebaseinteractive('<q-args>')

function! g:GitEditTodo(mods) abort
    exec a:mods . ' Gsplit .git/rebase-merge/git-rebase-todo'
endfunction

function! g:GitRebaseInteractive(mods, args) abort
    let l:previous_editor = $GIT_EDITOR
    let $GIT_EDITOR='exit 0;'
    try
        exec 'Git rebase --interactive ' . a:args
    finally
        let $GIT_EDITOR = l:previous_editor
    endtry
    if !v:shell_error
        call g:GitEditTodo(a:mods)
    endif
endfunction

command! -nargs=+ -complete=customlist,fugitive#Complete Grebaseinteractive :call g:GitRebaseInteractive('<mods>', '<q-args>')
command! -nargs=0 Gedittodo :call g:GitEditTodo('<mods>')


" ===== GUTENTAGS CONFIGURATION =====
" Gutentags automatically manages tag files
let g:gutentags_enabled = 1
let g:gutentags_cache_dir = '.git/tags'
set tags=.git/tags;

" ===== AUTO-PAIRS CONFIGURATION =====
" auto-pairs handles bracket/quote pairing automatically - minimal config needed
let g:AutoPairsShortcutToggle = '<M-p>'
let g:AutoPairsShortcutFastWrap = '<M-e>'
let g:AutoPairsShortcutJump = '<M-n>'


" =============================================================================
" 9. AUTOCOMMANDS
" =============================================================================

" Format options
augroup FormatFile
    autocmd!
    autocmd BufEnter vifmrc,*.vifm set filetype=vim
    autocmd BufEnter * set fo-=c fo-=r fo-=o
    autocmd BufEnter *.py set ai ts=4 sw=4 sts=4 et
    autocmd BufEnter *.md setlocal conceallevel=0
augroup end

" Trim trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

" Change to git root on Vim enter


" Statusline updates
autocmd OptionSet paste redrawstatus
autocmd InsertEnter,InsertLeave * redrawstatus
autocmd ModeChanged * redrawstatus
autocmd User ALELint redrawstatus



" =============================================================================
" 10. FILE TYPE DETECTION
" =============================================================================

" Terraform files
autocmd BufRead,BufNewFile *.tf setfiletype terraform
autocmd BufRead,BufNewFile *.hcl setfiletype hcl
autocmd BufRead,BufNewFile *.tfvars setfiletype terraform

" Java files
autocmd BufNewFile,BufRead *.java set filetype=java
autocmd BufNewFile,BufRead *.gradle set filetype=groovy
autocmd BufNewFile,BufRead *.kt set filetype=kotlin

" Disable markdown syntax in Java to avoid missing group errors
let g:java_ignore_markdown = 1

" =============================================================================
" 11. UNIX HELPERS (vim-eunuch)
" =============================================================================
" vim-eunuch provides: :Remove, :Delete, :Move, :Rename, :Copy, :Duplicate,
" :Chmod, :Mkdir, :SudoWrite, :SudoEdit, :Wall, :Cfind, :Clocate

function! Send_to_Tmux(text)
  if !exists("b:tmux_sessionname") || !exists("b:tmux_windowname") || !exists("b:tmux_panenumber")
    if exists("g:tmux_sessionname") && exists("g:tmux_windowname") && exist("g:tmux_panenumber")
      let b:tmux_sessionname = g:tmux_sessionname
      let b:tmux_windowname = g:tmux_windowname
      let b:tmux_panenumber = g:tmux_panenumber
    else
      call <SID>Tmux_Vars()
    end
  end

  let target = b:tmux_sessionname . ":" . b:tmux_windowname . "." . b:tmux_panenumber

  call system("tmux set-buffer '" . substitute(a:text, "'", "'\\\\''", 'g') . "'" )
  call system("tmux paste-buffer -t " . target)
endfunction

" Session completion
function! Tmux_Session_Names(A,L,P)
  return system("tmux list-sessions | sed -e 's/:.*$//'")
endfunction

" Window completion
function! Tmux_Window_Names(A,L,P)
  return system("tmux list-windows -t" . b:tmux_sessionname . ' | grep -e "^\w:" | sed -e "s/ \[[0-9x]*\]$//"')
endfunction

" Pane completion
function! Tmux_Pane_Numbers(A,L,P)
  return system("tmux list-panes -t " . b:tmux_sessionname . ":" . b:tmux_windowname . " | sed -e 's/:.*$//'")
endfunction

" set tslime.vim variables
function! s:Tmux_Vars()
  let b:tmux_sessionname = input("session name: ", "", "custom,Tmux_Session_Names")
  let b:tmux_windowname = substitute(input("window name: ", "", "custom,Tmux_Window_Names"), ":.*$" , '', 'g')
  let b:tmux_panenumber = input("pane number: ", "", "custom,Tmux_Pane_Numbers")

  if !exists("g:tmux_sessionname") || !exists("g:tmux_windowname") || !exists("g:tmux_panenumber")
    let g:tmux_sessionname = b:tmux_sessionname
    let g:tmux_windowname = b:tmux_windowname
    let g:tmux_panenumber = b:tmux_panenumber
  end
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

vmap <C-c><C-c> "ry :call Send_to_Tmux(@r)<CR>
nmap <C-c><C-c> vip<C-c><C-c>

nmap <C-c>v :call <SID>Tmux_Vars()<CR>

" =============================================================================
" END OF VIMRC
" =============================================================================

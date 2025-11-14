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

" Install all plugins
function! PluginInstall()
    call GitCloneDepth1('https://github.com/mileszs/ack.vim.git', 'ack.vim')
    call GitCloneDepth1('https://github.com/neoclide/coc.nvim.git', 'coc.nvim')

    call GitCloneDepth1('https://github.com/metakirby5/codi.vim.git', 'codi.vim')
    call GitCloneDepth1('https://github.com/Raimondi/delimitMate.git', 'delimitMate')
    call GitCloneDepth1('https://github.com/editorconfig/editorconfig-vim.git', 'editorconfig-vim')
    call GitCloneDepth1('https://github.com/preservim/nerdtree.git', 'nerdtree')
    call GitCloneDepth1('https://github.com/NLKNguyen/papercolor-theme.git', 'papercolor-theme')
    call GitCloneDepth1('https://github.com/c9s/simple-commenter.vim.git', 'simple-commenter.vim')
    call GitCloneDepth1('https://github.com/preservim/tagbar.git', 'tagbar')
    call GitCloneDepth1('https://github.com/morhetz/gruvbox.git', 'gruvbox')
    call GitCloneDepth1('https://github.com/vimagit/vimagit.git', 'vimagit')
    call GitCloneDepth1('https://github.com/easymotion/vim-easymotion.git', 'vim-easymotion')
    call GitCloneDepth1('https://github.com/airblade/vim-gitgutter.git', 'vim-gitgutter')
    call GitCloneDepth1('https://github.com/fatih/vim-go.git', 'vim-go')
    call GitCloneDepth1('https://github.com/ludovicchabant/vim-gutentags.git', 'vim-gutentags')
    call GitCloneDepth1('https://github.com/preservim/vim-indent-guides.git', 'vim-indent-guides')
    call GitCloneDepth1('https://github.com/skywind3000/vim-navigator.git', 'vim-navigator')
    call GitCloneDepth1('https://github.com/sheerun/vim-polyglot.git', 'vim-polyglot')
    call GitCloneDepth1('https://github.com/mhinz/vim-startify.git', 'vim-startify')
    call GitCloneDepth1('https://github.com/vimwiki/vimwiki.git', 'vimwiki')
    call GitCloneDepth1('https://github.com/Exafunction/windsurf.vim.git', 'windsurf.vim')
    call GitCloneDepth1('https://github.com/preservim/vimspector.git', 'vimspector')
    call GitCloneDepth1('https://github.com/tpope/vim-fugitive.git', 'vim-fugitive')
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

" Custom statusline function
function! CustomStatusline()
    " Left side: mode, filename, modified flag
    let l:left = ''
    let l:left .= '%#StatusLine#' . ModeIndicator() . ' '
    let l:left .= '%f'  " Full filename
    let l:left .= '%m'  " Modified flag
    let l:left .= '%r'  " Read-only flag
    let l:left .= '%h'  " Help flag

    " Right side: file type, encoding, line/col, git branch
    let l:right = ''
    let l:right .= '%y'  " File type
    let l:right .= ' | %{&fileencoding?&fileencoding:&encoding}'
    let l:right .= ' | %l:%c'  " Line:Column
    let l:right .= ' | %P'  " Percentage through file

    " Git branch (requires fugitive)
    if exists('g:loaded_fugitive')
        let l:right .= ' | %{FugitiveHead()}'
    endif

    " coc.nvim integration (show errors/warnings)
    let l:right .= ' | ' . GetCocStatus()

    return l:left . '%=' . l:right
endfunction

" Mode indicator function
function! ModeIndicator()
    let l:mode = mode()
    let l:mode_text = ""

    " Determine base mode
    if l:mode == "n"
        let l:mode_text = "NORMAL"
    elseif l:mode == "i"
        let l:mode_text = "INSERT"
    elseif l:mode == "v"
        let l:mode_text = "VISUAL"
    elseif l:mode == "V"
        let l:mode_text = "V-LINE"
    elseif l:mode == "s"
        let l:mode_text = "SELECT"
    elseif l:mode == "R"
        let l:mode_text = "REPLACE"
    else
        let l:mode_text = l:mode
    endif

    " Add PASTE indicator if paste mode is active
    if &paste
        return l:mode_text . " [PASTE]"
    else
        return l:mode_text
    endif
endfunction

" coc.nvim status function
function! GetCocStatus()
    if exists('g:loaded_coc')
        let l:info = get(b:, 'coc_diagnostic_info', {})
        if empty(l:info)
            return get(g:, 'coc_status', '')
        endif
        let l:errors = get(l:info, 'error', 0)
        let l:warnings = get(l:info, 'warning', 0)
        let l:result = ''
        if l:errors > 0
            let l:result .= 'E:' . l:errors
        endif
        if l:warnings > 0
            if !empty(l:result)
                let l:result .= ' '
            endif
            let l:result .= 'W:' . l:warnings
        endif
        return l:result
    endif
    return ''
endfunction

" Set the statusline
set laststatus=2  " Always show statusline
set statusline=%!CustomStatusline()

" Tabline (replaces airline tabline)
set showtabline=2
set tabline=%!CustomTabline()

function! CustomTabline()
    let l:s = ''
    for i in range(1, tabpagenr('$'))
        let l:bufnr = tabpagebuflist(i)[tabpagewinnr(i) - 1]
        let l:bufname = bufname(l:bufnr)
        let l:bufname = fnamemodify(l:bufname, ':t')
        if empty(l:bufname)
            let l:bufname = '[No Name]'
        endif

        " Highlight current tab
        if i == tabpagenr()
            let l:s .= '%#TabLineSel#'
        else
            let l:s .= '%#TabLine#'
        endif

        let l:s .= ' ' . i . ': ' . l:bufname . ' '
    endfor

    let l:s .= '%#TabLineFill#%T'
    return l:s
endfunction

" Custom highlight groups
hi StatusLine ctermfg=15 ctermbg=238 guifg=#ffffff guibg=#444444
hi StatusLineNC ctermfg=7 ctermbg=238 guifg=#cccccc guibg=#444444
hi TabLineSel ctermfg=15 ctermbg=31 guifg=#ffffff guibg=#0087ff
hi TabLine ctermfg=7 ctermbg=238 guifg=#cccccc guibg=#444444

" =============================================================================
" 5. KEY MAPPINGS
" =============================================================================

" Basic mappings
nnoremap <leader>sp :set paste!<CR>
nnoremap <leader>snp :set nopaste!<CR>
nnoremap <leader>w :w!<CR>

" Background toggle
nmap <leader>bg :call ToggleBackground()<CR>

" =============================================================================
" 6. SEARCH AND NAVIGATION FUNCTIONS
" =============================================================================

" Git root functions
function! FindGitRoot()
    " Use git rev-parse to find the top-level git directory
    let git_root = system('git rev-parse --show-toplevel 2>/dev/null')
    let git_root = substitute(git_root, '\n', '', 'g')
    if v:shell_error == 0 && isdirectory(git_root)
        return git_root
    endif
    return "."
endfunction

function! ChangeToGitRoot()
    execute 'cd ' . FindGitRoot()
endfunction

" Search functions
let s:rg_command="rg -i --vimgrep --no-hidden --no-ignore -g '!tags' "

function! s:search_term()
    call inputsave()
    let search_term = input('Search: ')
    call inputrestore()
    if empty(search_term)
        echo "No search term entered"
        return ""
    endif
    return search_term
endfunction

function! s:rg_prompt_word()
    execute 'cexpr system(s:rg_command . s:search_term() . " " . FindGitRoot() . " |sort")'
    copen
endfunction

" Buffer management
function! ListMRUBuffers()
    let buf_list = []
    " Loop through buffer list
    for bufnr in range(1, bufnr('$'))
        if buflisted(bufnr)
            " Capture buffer details: number, filename, and last access time
            let bufname = bufname(bufnr)
            let lnum = bufwinnr(bufnr) > 0 ? line('.', bufnr) : 1
            let buf_details = {'bufnr': bufnr, 'filename': bufname, 'lnum': lnum}
            call add(buf_list, buf_details)
        endif
    endfor

    " Sort buffers based on the buffer number in descending order (most recently used at top)
    call sort(buf_list, {a, b -> b.bufnr - a.bufnr})

    " Set up items for the quickfix list
    let qf_items = map(buf_list, {idx, val -> {'filename': val.filename, 'lnum': val.lnum, 'text': 'Buffer '.val.bufnr}})

    " Populate the quickfix list
    call setqflist(qf_items)

    " Open quickfix window
    copen
endfunction

" File search functions
function! SearchWithFd(search_pattern)
    let l:cmd = 'cd ' . FindGitRoot() . ' && fd . | rg -i ' . shellescape(a:search_pattern)
    let l:results = split(system(l:cmd), "\n")
    call setqflist(map(filter(copy(l:results), 'len(v:val)'), '{"filename": v:val, "lnum": 1}'))

    " Automatically open the quickfix window if there are entries
    if len(getqflist()) > 0
        copen
    endif
endfunction

" Vim command search
function! SearchVimCommands(search_pattern)
    " Ask for input if no argument provided
    let l:pattern = a:search_pattern
    if len(l:pattern) == 0
        let l:pattern = input('Enter command search pattern: ')
    endif

    " Obtain all command names
    redir => l:commands
    silent command
    redir END

    " Split commands into a list and filter based on the search pattern
    let l:commands_list = split(l:commands, "\n")
    let l:filtered_commands = filter(copy(l:commands_list), 'v:val =~ l:pattern')

    " Prepare quickfix list
    let qf_list = []
    for cmd in l:filtered_commands
        call add(qf_list, {'filename': '', 'lnum': 0, 'text': cmd})
    endfor

    " Set quickfix list and open quickfix window
    call setqflist(qf_list)
    copen
endfunction

" Buffer search functions
function! RgCurrentWordInBuffer()
    let word = expand('<cword>')  " Get the word under the cursor.
    let pattern = shellescape('\<' . word . '\>')  " Add word boundaries and escape the pattern.

    " Build the command to execute
    let command = 'rg --vimgrep ' . pattern . ' ' . shellescape(expand('%:p'))

    " Execute the rg command and capture the output as a list
    let results = systemlist(command)

    " Clear the location list and conditionally populate it
    lclose
    lexpr []
    if !empty(results)
        call setloclist(0, map(copy(results), 'RgResultToLocList(v:val)'))
        lopen
    else
        echo "No occurrences found for the word: " . word
    endif
endfunction

function! RgResultToLocList(line)
    let parts = split(a:line, ':')
    return {
        \ "bufnr": bufnr(''),
        \ "lnum": str2nr(parts[1]),
        \ "col": str2nr(parts[2]),
        \ "text": join(parts[3:], ':')
    \ }
endfunction

function! RgSearchInBuffer()
    " Ask the user for a search pattern
    let pattern = input('Enter search pattern: ')
    if pattern == ''
        echo 'Search canceled.'
        return
    endif
    let escapedPattern = shellescape(pattern)

    " Build the rg command like before
    let command = 'rg --vimgrep ' . escapedPattern . ' ' . shellescape(expand('%:p'))

    " Execute the rg command and capture the output as a list
    let results = systemlist(command)

    " Clear the location list and conditionally populate it
    lclose
    lexpr []
    if !empty(results)
        call setloclist(0, map(copy(results), 'RgResultToLocList(v:val)'))
        lopen
    else
        echo "No occurrences found for the pattern: " . pattern
    endif
endfunction

" Vimwiki search functions
function! RgSearchChecklist()
    let pattern = "' \\\[ \\\]'"

    " Compose the ripgrep command for use with Vim's quickfix, ensuring --vimgrep for proper formatting.
    let command = 'rg --vimgrep ' . pattern . ' ~/vimwiki/'

    " Execute the rg command and get the results
    let results = systemlist(command)

    " Prepare results for Vim's quickfix list
    let formatted_results = map(results, 'ProcessRgOutput(v:val)')

    cclose
    if !empty(formatted_results)
        call setqflist(formatted_results)
        copen
    else
        echo "No occurrences found for the pattern: ' [ ]'"
    endif
endfunction

function! ProcessRgOutput(line)
    let parts = split(a:line, ':', 1)
    return {'filename': parts[0], 'lnum': str2nr(parts[1]), 'col': str2nr(parts[2]), 'text': join(parts[3:], ':')}
endfunction

function! RgSearchWaitingChecklist()
    let pattern = ":WAIT:"

    " Compose the command to search with rg and exclude any '[X]' patterns
    " Note: We use 'rg -v "\[X\]"' to filter out lines containing '[X]' after the initial search
    let command = 'rg --vimgrep ' . pattern . ' ~/vimwiki/ | rg -v "\[X\]"'

    " Execute the rg command and get the results
    let results = systemlist(command)

    " Prepare results for Vim's quickfix list
    let formatted_results = map(results, 'ProcessRgOutput(v:val)')

    cclose
    if !empty(formatted_results)
        call setqflist(formatted_results)
        copen
    else
        echo "No occurrences found for the pattern: ' [ ]' excluding '[X]'"
    endif
endfunction

" Tag search function
function! SearchTag()
    let tag_pattern = input('Enter tag to search for: ')

    " Exit if no input is given
    if empty(tag_pattern)
        echo 'Search canceled.'
        return
    endif

    let git_root = system('git rev-parse --show-toplevel')
    let git_root = substitute(git_root, '\n', '', 'g')

    if v:shell_error || git_root == ''
        echo 'Not inside a Git repository.'
        return
    endif

    let tags_file = git_root . '/tags'
    let command = 'rg --no-heading --vimgrep ' . shellescape(tag_pattern) . ' ' . shellescape(tags_file)

    let results = systemlist(command)
    let formatted_results = map(results, 'FormatTagResult(v:val)')

    cclose
    if !empty(formatted_results)
        call setqflist(formatted_results)
        copen
    else
        echo "No tag found matching: " . tag_pattern
    endif
endfunction

function! FormatTagResult(line)
    let parts = split(a:line, ':', 1)
    return {
        \ 'filename': parts[0],
        \ 'lnum': str2nr(parts[1]),
        \ 'col': str2nr(parts[2]),
        \ 'text': join(parts[3:], ':')
        \ }
endfunction

" =============================================================================
" 7. COMMANDS
" =============================================================================

" Search commands
command! RgCurrentWord cexpr system(s:rg_command . shellescape(expand('<cword>')) . ' ' . FindGitRoot() . ' |sort') | copen
command! -nargs=+ RgForWord cexpr system(s:rg_command . shellescape(join([<f-args>], ' . ')) . ' ' . FindGitRoot() . ' |sort') | copen
command! RgPromptWord call s:rg_prompt_word()
command! -nargs=? Fd if empty(<q-args>) | call SearchWithFd(input('Enter search pattern: ')) | else | call SearchWithFd(<q-args>) | endif
command! ListBuffers call ListMRUBuffers()
command! -nargs=? SearchCommands call SearchVimCommands(<q-args>)
command! RgCurrentWordInBuffer call RgCurrentWordInBuffer()
command! RgSearchBuffer call RgSearchInBuffer()
command! RgSearchChecklist call RgSearchChecklist()
command! RgSearchWaitingChecklist call RgSearchWaitingChecklist()
command! SearchTag call SearchTag()

" Utility commands
command! ClearQuickfixList cexpr []

" Run to quickfix
command! -nargs=1 RunToQuickfix cexpr system(<q-args>) | copen

" =============================================================================
" 8. PLUGIN CONFIGURATIONS
" =============================================================================

" ===== Simple Commenter =====
let g:scomment_default_mapping = 1
map <silent>,, <Plug>(one-line-comment)

" ===== Vim Navigator =====
let g:navigator = {'prefix':'<tab><tab>'}
nnoremap <silent><tab><tab> :Navigator g:navigator<cr>
vnoremap <silent><tab><tab> :Navigator g:navigator_visual<cr>

let g:navigator = {}
let g:navigator.s = { 'name' : '+search' }
let g:navigator.s.f = [':Fd', 'search-file']
let g:navigator.s.w = [":RgCurrentWord ", 'search-current-word']
let g:navigator.s.W = [":RgPromptWord", 'search-any-Word']
let g:navigator.s.b = [':ListBuffers','search-buffers']
let g:navigator.s.c = [':SearchCommands', 'search-commands']
let g:navigator.s.t = [":RgSearchChecklist", 'search-tasks-todo']
let g:navigator.s.T = [":RgSearchWaitingChecklist", 'search-tasks-waiting']

let g:navigator.b = { 'name' : '+Buffer' }
let g:navigator.b.w = [":execute 'RgCurrentWordInBuffer'", 'search-current-word-in-buffer']
let g:navigator.b.W = ["RgSearchBuffer", "search-word-in-buffer"]

let g:navigator.c = { 'name' : '+code' }
let g:navigator.c.d = [':ALEGoToDefinition','go-to-definition']
let g:navigator.c.h = [':ALEHover','hover']
let g:navigator.c.r = [':ALEFindReferences','find-references']
let g:navigator.c.s = [":execute 'ALESymbolSearch ' . expand('<cword>')",'symbol-search']
let g:navigator.c.c = ['<Plug>(one-line-comment)','Comment-out/toggle']
let g:navigator.c.t = [":TagbarToggle",'TagBar']
let g:navigator.c.t = [':SearchTag','search-tags']

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

let g:navigator_visual = {}
let g:navigator_visual.c = { 'name' : '+code' }
let g:navigator_visual.c.c = ['<Plug>(one-line-comment)','Comment-out/toggle']

" ===== EasyMotion =====
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
let g:EasyMotion_landing_highlight = 0
nmap <Leader>bm <Plug>(easymotion-in-f2)

" ===== GutenTags =====
let g:guttentags_enabled=1
let g:guttentags_ctags_executable='ctags'

" ===== VimWiki =====
let g:vimwiki_list = [{'path': '~/vimwiki/',
    \ 'syntax': 'markdown', 'ext': 'md'}]
let g:vimwiki_global_ext = 0

" ===== Vim Magit =====
let g:magit_git_cmd = 'git'

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

" ===== coc.nvim =====
let g:coc_global_extensions = [
    \ 'coc-go',
    \ 'coc-pyright',
    \ 'coc-tsserver',
    \ 'coc-json',
    \ 'coc-yaml',
    \ 'coc-html',
    \ 'coc-css',
    \ 'coc-vimlsp',
    \ 'coc-texlab',
    \ 'coc-eslint',
    \ 'coc-java'
    \ ]

let g:coc_user_config = {
    \ 'diagnostic.enable': v:true,
    \ 'diagnostic.displayByAle': v:false,
    \ 'diagnostic.enableSign': v:true,
    \ 'diagnostic.enableMessage': 'always',
    \ 'diagnostic.messageTarget': 'float',
    \ 'diagnostic.signOffset': 1,
    \ 'diagnostic.errorSign': 'E>',
    \ 'diagnostic.warningSign': 'W>',
    \ 'diagnostic.infoSign': 'I>',
    \ 'diagnostic.hintSign': 'H>',
    \ 'suggest.enablePreselect': v:true,
    \ 'suggest.noselect': v:false,
    \ 'suggest.enablePreview': v:true,
    \ 'suggest.maxCompleteItemCount': 50,
    \ 'suggest.triggerCompletionWait': 50,
    \ 'suggest.minTriggerInputLength': 1,
    \ 'codeLens.enable': v:true,
    \ 'codeLens.position': 'eol',
    \ 'colors.enable': v:true,
    \ 'colors.highlightPriority': 10,
    \ 'coc.preferences.formatOnSaveFiletypes': [
    \   'javascript', 'typescript', 'python', 'go', 'json', 'yaml'
    \ ],
    \ 'go.goplsOptions': {
    \   'staticcheck': v:true,
    \   'usePlaceholders': v:true
    \ },
    \ 'python.linting.enabled': v:true,
    \ 'python.linting.pylintEnabled': v:true,
    \ 'python.linting.mypyEnabled': v:true,
    \ 'python.formatting.provider': 'black',
    \ 'terraform': {
    \   'languageServer': {
    \     'enabled': v:true,
    \     'path': 'terraform-ls',
    \     'args': ['serve'],
    \     'maxFileSize': 1048576
    \   }
    \ }
    \ }

" coc.nvim key mappings
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<Tab>" : coc#refresh()
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~# '\s'
endfunction

if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . " " . expand('<cword>')
    endif
endfunction

nmap <leader>rn <Plug>(coc-rename)
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)
xmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>ac <Plug>(coc-codeaction)
nmap <leader>qf <Plug>(coc-fix-current)

xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)

nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call CocAction('fold', <f-args>)
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

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
autocmd VimEnter * call ChangeToGitRoot()

" Statusline updates
autocmd OptionSet paste redrawstatus
autocmd InsertEnter,InsertLeave * redrawstatus
autocmd ModeChanged * redrawstatus
autocmd User CocDiagnosticChange redrawstatus

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
" END OF VIMRC
" =============================================================================

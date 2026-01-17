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
    " NEW PLUGINS - Replace coc.nvim
    call GitCloneDepth1('https://github.com/dense-analysis/ale.git', 'ale')
    call GitCloneDepth1('https://github.com/prabirshrestha/asyncomplete.vim.git', 'asyncomplete.vim')
    call GitCloneDepth1('https://github.com/prabirshrestha/vim-lsp.git', 'vim-lsp')
    call GitCloneDepth1('https://github.com/prabirshrestha/asyncomplete-lsp.vim.git', 'asyncomplete-lsp.vim')

    call GitCloneDepth1('https://github.com/metakirby5/codi.vim.git', 'codi.vim')
    call GitCloneDepth1('https://github.com/editorconfig/editorconfig-vim.git', 'editorconfig-vim')
    call GitCloneDepth1('https://github.com/preservim/nerdtree.git', 'nerdtree')
    call GitCloneDepth1('https://github.com/NLKNguyen/papercolor-theme.git', 'papercolor-theme')
    call GitCloneDepth1('https://github.com/preservim/tagbar.git', 'tagbar')
    call GitCloneDepth1('https://github.com/morhetz/gruvbox.git', 'gruvbox')
    call GitCloneDepth1('https://github.com/vimagit/vimagit.git', 'vimagit')
    call GitCloneDepth1('https://github.com/easymotion/vim-easymotion.git', 'vim-easymotion')
    call GitCloneDepth1('https://github.com/airblade/vim-gitgutter.git', 'vim-gitgutter')
    call GitCloneDepth1('https://github.com/fatih/vim-go.git', 'vim-go')

    call GitCloneDepth1('https://github.com/skywind3000/vim-navigator.git', 'vim-navigator')
    call GitCloneDepth1('https://github.com/sheerun/vim-polyglot.git', 'vim-polyglot')
    call GitCloneDepth1('https://github.com/mhinz/vim-startify.git', 'vim-startify')
    call GitCloneDepth1('https://github.com/Exafunction/windsurf.vim.git', 'windsurf.vim')
    call GitCloneDepth1('https://github.com/preservim/vimspector.git', 'vimspector')
    call GitCloneDepth1('https://github.com/tpope/vim-fugitive.git', 'vim-fugitive')
    call GitCloneDepth1('https://github.com/preservim/vimux.git', 'vimux')
    call GitCloneDepth1('https://github.com/lervag/wiki.vim.git', 'wiki')
    call GitCloneDepth1('https://github.com/mhinz/vim-grepper', 'vim-grepper')
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

    " ALE integration (show errors/warnings)
    let l:right .= ' | ' . GetALEStatus()

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

" ALE status function
function! GetALEStatus()
    if exists('g:loaded_ale')
        let l:errors = 0
        let l:warnings = 0

        " Get ALE loclist for current buffer
        let l:loclist = getloclist(0)
        for l:entry in l:loclist
            if l:entry.bufnr == bufnr('%')
                let l:type = get(l:entry, 'type', '')
                if l:type == 'E'
                    let l:errors += 1
                elseif l:type == 'W'
                    let l:warnings += 1
                endif
            endif
        endfor

        if l:errors == 0 && l:warnings == 0
            return ''
        endif

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

" Auto-closing delimiters (replaces DelimitMate)
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
inoremap " ""<Left>
inoremap ' ''<Left>

" Background toggle
nmap <leader>bg :call ToggleBackground()<CR>

" ===== LSP AND ALE KEY MAPPINGS =====
" Diagnostic Navigation (ALE)
nmap <silent> [g <Plug>(ale_previous_wrap)
nmap <silent> ]g <Plug>(ale_next_wrap)

" LSP Navigation (vim-lsp)
nmap <silent> gd <Plug>(lsp-definition)
nmap <silent> gy <Plug>(lsp-type-definition)
nmap <silent> gi <Plug>(lsp-implementation)
nmap <silent> gr <Plug>(lsp-references)

" Hover Documentation
nnoremap <silent> K :call LspHover()<CR>

" Rename
nmap <leader>rn <Plug>(lsp-rename)

" Code Actions
nmap <leader>ca :LspCodeAction<CR>
xmap <leader>ca :LspCodeAction<CR>

" Format
nmap <leader>f :ALEFix<CR>
xmap <leader>f :ALEFix<CR>

" Organize Imports
command! -nargs=0 OR :call LspCodeAction('source.organizeImports')

" Document Symbols
nmap <silent> gs :LspDocumentSymbol<CR>

" Workspace Symbols
nmap <silent> gS :LspWorkspaceSymbol<CR>

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







" =============================================================================
" 7. COMMANDS
" =============================================================================

" Search commands
command! -nargs=? Fd if empty(<q-args>) | call SearchWithFd(input('Enter search pattern: ')) | else | call SearchWithFd(<q-args>) | endif
command! ListBuffers call ListMRUBuffers()
command! -nargs=? SearchCommands call SearchVimCommands(<q-args>)

" Utility commands
command! ClearQuickfixList cexpr []

" Run to quickfix
command! -nargs=1 RunToQuickfix cexpr system(<q-args>) | copen

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
    \ 'java': ['javac']
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


" ===== ASYNCOMPLETE CONFIGURATION =====
" Enable auto-popup on typing
let g:asyncomplete_auto_popup = 1

" Helper function to check if we should trigger completion
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Tab completion mappings
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Force completion refresh with Ctrl-Space
inoremap <silent><expr> <c-space> asyncomplete#force_refresh()


" ===== VIM-LSP CONFIGURATION =====
" Register language servers
function! s:lsp_settings() abort
    " Python
    if executable('pylsp')
        call lsp#register_server({
            \ 'name': 'pylsp',
            \ 'cmd': {server_info->['pylsp']},
            \ 'whitelist': ['python'],
            \ })
    endif

    " Go
    if executable('gopls')
        call lsp#register_server({
            \ 'name': 'gopls',
            \ 'cmd': {server_info->['gopls']},
            \ 'whitelist': ['go'],
            \ })
    endif

    " TypeScript/JavaScript
    if executable('typescript-language-server')
        call lsp#register_server({
            \ 'name': 'typescript-language-server',
            \ 'cmd': {server_info->['typescript-language-server', '--stdio']},
            \ 'whitelist': ['javascript', 'typescript', 'javascriptreact', 'typescriptreact'],
            \ })
    endif

    " JSON
    if executable('vscode-json-language-server')
        call lsp#register_server({
            \ 'name': 'vscode-json-language-server',
            \ 'cmd': {server_info->['vscode-json-language-server', '--stdio']},
            \ 'whitelist': ['json'],
            \ })
    endif

    " YAML
    if executable('yaml-language-server')
        call lsp#register_server({
            \ 'name': 'yaml-language-server',
            \ 'cmd': {server_info->['yaml-language-server', '--stdio']},
            \ 'whitelist': ['yaml'],
            \ })
    endif

    " HTML
    if executable('vscode-html-language-server')
        call lsp#register_server({
            \ 'name': 'vscode-html-language-server',
            \ 'cmd': {server_info->['vscode-html-language-server', '--stdio']},
            \ 'whitelist': ['html'],
            \ })
    endif

    " CSS
    if executable('vscode-css-language-server')
        call lsp#register_server({
            \ 'name': 'vscode-css-language-server',
            \ 'cmd': {server_info->['vscode-css-language-server', '--stdio']},
            \ 'whitelist': ['css', 'scss'],
            \ })
    endif

    " Vim
    if executable('vim-language-server')
        call lsp#register_server({
            \ 'name': 'vim-language-server',
            \ 'cmd': {server_info->['vim-language-server', '--stdio']},
            \ 'whitelist': ['vim'],
            \ })
    endif

    " TeX
    if executable('texlab')
        call lsp#register_server({
            \ 'name': 'texlab',
            \ 'cmd': {server_info->['texlab']},
            \ 'whitelist': ['tex', 'plaintex'],
            \ })
    endif

    " Java
    if executable('jdtls')
        call lsp#register_server({
            \ 'name': 'jdtls',
            \ 'cmd': {server_info->['jdtls']},
            \ 'whitelist': ['java'],
            \ })
    endif
endfunction

autocmd User lsp_setup call s:lsp_settings()


" ===== ASYNCOMPLETE-LSP CONFIGURATION =====
if exists('g:loaded_asyncomplete')
    call asyncomplete#register_source({
        \ 'name': 'lsp',
        \ 'allowlist': ['*'],
        \ 'completor': function('asyncomplete#sources#lsp#completor'),
        \ 'config': {
        \    'show_context': 1,
        \ },
        \ })
endif


" ===== Comment Toggle (replaces Simple Commenter) =====
fun! s:def(name,value)
  if ! exists(a:name)
    let {a:name} = a:value
  endif
endf

fun! s:select(a,e)
  if g:scomment_reselect && a:a != a:e
    normal gv
  endif
endf

fun! s:ensureOnelineBlock(pattern,a,e)
  let succ = 1
  for i in range(a:a,a:e)
    if getline(i) !~ a:pattern
      let succ = 0
    endif
  endfor
  return succ
endf

fun! s:trimCommentLines(pattern,a,e)
  for i in range(a:a,a:e)
    let line = substitute(getline(i),a:pattern,'','')
    cal setline(i,line)
  endfor
endf

fun! s:getCommentMarks()
  let oneline_mark = ''
  let mark1 = ''
  let mark2 = ''

  let cs = split(&comments,',')
  for c in cs
    if c =~ '^s1:'
      let mark1 = strpart(c,3)
    elseif c =~ '^ex:'
      let mark2 = strpart(c,3)
    elseif c =~ '^:'
      let oneline_mark = strpart(c,1) . ' '
    endif
  endfor

  if mark1 =~ 'XCOMM'
    let mark1 = '/*'
  endif
  if mark2 =~ 'XCOMM'
    let mark2 = '*/'
  endif
  if oneline_mark =~ 'XCOMM'
    let oneline_mark = '//'
  endif

  let ft = &filetype
  if !g:scomment_prefer_commentstring && strlen(oneline_mark) == 0
    if ft == 'vim'
      let oneline_mark = '" '
    elseif ft == 'sh'
      let oneline_mark = '# '
    elseif ft == 'php' || ft == 'go'
      let oneline_mark = '// '
    endif
  endif
  if strlen(mark1) == 0 && strlen(mark2) == 0
    if ft == 'python'
      let [ mark1 , mark2 ] = [ '"""' ,'"""' ]
    elseif ft == 'perl'
      let [ mark1 , mark2 ] = [ '=pod' ,'=cut' ]
    elseif ft == 'php' || ft == 'go'
      let [ mark1 , mark2 ] = [ '/*' , '*/' ]
    endif
  endif
  return [ mark1 , mark2 , oneline_mark ]
endf

fun! s:doComment(force_oneline,a,e)
  let cs = &commentstring
  let css = split( cs , '%s' )
  let mark1 = ''
  let mark2 = ''

  let [m1,m2,s1] = s:getCommentMarks()

  let onlyoneline = strlen(m1)==0 && strlen(m2)==0
        \ && (strlen(s1)>0 || len(css)==1)

  let onlyblock   = strlen(m1)>0 && strlen(m2)>0
        \ && (strlen(s1)==0 || len(css)==2)

  if a:force_oneline || onlyoneline
    let mark = ''
    if len(css) == 2 && strlen(s1) > 0
      let mark = s1
    elseif len(css) == 1
      let mark = strlen(s1) > 0 ? s1 : css[0]
      let mark = g:scomment_prefer_commentstring ? css[0] : mark
    endif

    if strlen(mark) > 0
      for i in range(a:a,a:e)
        cal setline(i, mark . g:oneline_comment_padding . getline(i) )
      endfor
      cal s:select(a:a,a:e)
      return
    endif
  endif

  if (len(css) == 2 && g:scomment_prefer_commentstring && &filetype != 'python')
    let mark1 = css[0]
    let mark2 = css[1]
  else
    let mark1 = m1
    let mark2 = m2
  endif

  let sep = a:a == a:e ? g:block_comment_padding : ""

  cal setline(a:a,  mark1 . sep . getline(a:a)  )
  cal setline(a:e, getline(a:e) . sep . mark2 )
endf

fun! s:_unComment(m1,m2,a,e)
  let mark1 = s:escape_cm( a:m1 )
  let mark2 = s:escape_cm( a:m2 )

  let line1 = getline(a:a)
  let line2 = getline(a:e)

  if strlen(matchstr( line1 ,'^\s*' . mark1)) > 0
        \ && strlen(matchstr( line2 , mark2 .'\s*$')) > 0

    let sep = a:a == a:e ? g:block_comment_padding : ""

    let line1 = getline(a:a)
    let line = substitute(line1,'^\s*'. mark1 . sep ,'','')
    cal setline(a:a,line)

    let line2 = getline(a:e)
    let line = substitute( line2, sep . mark2.'\s*$','','')
    cal setline(a:e,line)
    return 1
  endif
  return 0
endf

fun! s:unComment(a,e)
  let cs = &commentstring
  let css = split( cs , '%s' )
  let mark1 = ''
  let mark2 = ''

  let [m1,m2,s1] = s:getCommentMarks()
  let onlyoneline = strlen(m1)==0 && strlen(m2)==0
        \ && (strlen(s1) || len(css)==1)

  if len(css) == 2
    let succ =  s:_unComment(css[0],css[1],a:a,a:e)
    if succ
      cal s:select(a:a,a:e)
      return
    endif
  endif

  if strlen(m1) > 0 && strlen(m2) > 0
    let succ =  s:_unComment(m1,m2,a:a,a:e)
    if succ
      cal s:select(a:a,a:e)
      return
    endif
  endif

  if g:scomment_prefer_commentstring && len(css) == 1
    let succ = s:ensureOnelineBlock( '^\s*' . s:escape_cm(css[0]) . g:oneline_comment_padding,a:a,a:e)
    if succ
      cal s:trimCommentLines( '^\s*' . s:escape_cm(css[0]) . g:oneline_comment_padding , a:a , a:e )
      cal s:select(a:a,a:e)
      return
    endif
  endif

  if strlen(s1) > 0
    let succ = s:ensureOnelineBlock( '^\s*'. s:escape_cm(s1) . g:oneline_comment_padding ,a:a,a:e)
    if succ
      cal s:trimCommentLines( '^\s*' . s:escape_cm(s1) . g:oneline_comment_padding , a:a , a:e )
      cal s:select(a:a,a:e)
      return
    endif
  endif

  if len(css) == 1
    let succ = s:ensureOnelineBlock( '^\s*' . s:escape_cm(css[0]) . g:oneline_comment_padding,a:a,a:e)
    if succ
      cal s:trimCommentLines( '^\s*' . s:escape_cm(css[0]) . g:oneline_comment_padding , a:a , a:e )
      cal s:select(a:a,a:e)
      return
    endif
  endif
endf

fun! s:escape_cm(mark)
  return escape( a:mark , '.*/!"' )
endf

fun! s:onelineComment(a,e)
  let css = split(&commentstring,'%s')
  let [m1,m2,s1] = s:getCommentMarks()

  if getline(a:a) =~ '^\s*' . s:escape_cm(css[0])
        \ || strlen(s1) > 0 && getline(a:a) =~ '^\s*' . s:escape_cm(s1)
        \ || strlen(m1) > 0 && getline(a:a) =~ '^\s*' . s:escape_cm(m1)
    cal s:unComment(a:a,a:e)
  else
    cal s:doComment(1,a:a,a:e)
  endif
  cal s:select(a:a,a:e)
endf

cal s:def('g:oneline_comment_padding',' ')
cal s:def('g:block_comment_padding', ' ')

cal s:def('g:scomment_prefer_commentstring', 1)
cal s:def('g:scomment_reselect',1)
cal s:def('g:scomment_default_mapping',1)

fun! s:init_pov()
  let g:scomment_prefer_commentstring = 1
  setlocal comments+=s1:/*,ex:*/,://
endf

fun! s:init_python()
  let g:scomment_prefer_commentstring = 1
  setlocal comments+=s1:\"\"\",ex:\"\"\",:#
endf

fun! s:init_perl()
  setlocal comments=s1:=pod,ex:=cut,:#
endf

aug CommentFix
  au!
  au filetype pov :cal s:init_pov()
  au filetype python :cal s:init_python()
  au filetype perl   :cal s:init_perl()
aug END

com!        CommentReselectEnable    :let g:scomment_reselect = 1 | echo "Comment reselecting On"
com!        CommentReselectDisable   :let g:scomment_reselect = 0 | echo "Comment reselecting Off"

com! -range DoComment :cal s:doComment(0,<line1>,<line2>)
com! -range UnComment :cal s:unComment(<line1>,<line2>)
com! -range OneLineComment :cal s:onelineComment(<line1>,<line2>)

map <silent> <Plug>(do-comment)  :DoComment<CR>
map <silent> <Plug>(un-comment)  :UnComment<CR>
map <silent> <Plug>(one-line-comment) :OneLineComment<CR>

if g:scomment_default_mapping
  map <silent>   ,c    <Plug>(do-comment)
  map <silent>   ,C    <Plug>(un-comment)
  map <silent>   ,,    <Plug>(one-line-comment)
endif

" ===== Vim Navigator =====
let g:navigator = {'prefix':'<tab><tab>'}
nnoremap <silent><tab><tab> :Navigator g:navigator<cr>
vnoremap <silent><tab><tab> :Navigator g:navigator_visual<cr>

let g:navigator = {}
let g:navigator.s = { 'name' : '+search' }
let g:navigator.s.f = [':Fd', 'search-file']
let g:navigator.s.w = [':Grepper -cword -noprompt', 'search-current-word']
let g:navigator.s.W = [':Grepper', 'search-prompt']
let g:navigator.s.b = [':ListBuffers', 'search-buffers']
let g:navigator.s.c = [':SearchCommands', 'search-commands']
let g:navigator.s.t = [':SearchChecklist', 'search-tasks-todo']
let g:navigator.s.T = [':SearchTodo', 'search-tasks-waiting']

let g:navigator.b = { 'name' : '+Buffer' }
let g:navigator.b.w = [':Grepper -buffers -cword -noprompt', 'search-word-in-buffer']
let g:navigator.b.W = [':Grepper -buffers', 'search-prompt-in-buffer']

let g:navigator.c = { 'name' : '+code' }
let g:navigator.c.d = ['<Plug>(lsp-definition)','go-to-definition']
let g:navigator.c.h = ['<Plug>(lsp-hover)','hover']
let g:navigator.c.r = ['<Plug>(lsp-references)','find-references']
let g:navigator.c.s = ['execute "ALESymbolSearch " . expand("<cword>")','symbol-search']
let g:navigator.c.c = ['<Plug>(one-line-comment)','Comment-out/toggle']
let g:navigator.c.t = [":TagbarToggle",'TagBar']
let g:navigator.c.g = [':SearchTag','search-tags']

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

let g:navigator_visual = {}
let g:navigator_visual.c = { 'name' : '+code' }
let g:navigator_visual.c.c = ['<Plug>(one-line-comment)','Comment-out/toggle']

" ===== EasyMotion =====
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
let g:EasyMotion_landing_highlight = 0
nmap <Leader>bm <Plug>(easymotion-in-f2)


" ===== Tag Generation (replaces GutenTags) =====
let g:tag_job_running = 0
function! TagJobExit(job, status)
    let g:tag_job_running = 0
endfunction
function! GenerateTagsAsync()
    if !executable('ctags') || g:tag_job_running
        return
    endif
    let git_root = system('git rev-parse --show-toplevel 2>/dev/null')
    let dir = empty(git_root) ? '.' : trim(git_root)
    let g:tag_job_running = 1
    let g:tag_job_id = job_start(['ctags', '-R', dir], {'exit_cb': 'TagJobExit', 'out_io': 'null', 'err_io': 'null'})
endfunction
autocmd BufWritePost * call GenerateTagsAsync()
set tags=./tags;,tags

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
let g:grepper.tools         = ['rg', 'ag', 'ack', 'git', 'grep']
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
command! -nargs=0 SearchChecklist :Grepper -noprompt -query '\\[ \\]' -dir ~/vimwiki
command! -nargs=0 SearchTodo :Grepper -noprompt -query ':WAIT:' -dir ~/vimwiki
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
autocmd User ALELint redrawstatus
autocmd User lsp_float_open redrawstatus


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
" 11. UNIX HELPERS (replaces vim-eunuch)
" =============================================================================

let s:slash_pat = exists('+shellslash') ? '[\/]' : '/'

function! s:separator() abort
  return !exists('+shellslash') || &shellslash ? '/' : '\'
endfunction

function! s:ffn(fn, path) abort
  return get(get(g:, 'io_' . matchstr(a:path, '^\a\a\+\ze:'), {}), a:fn, a:fn)
endfunction

function! s:fcall(fn, path, ...) abort
  return call(s:ffn(a:fn, a:path), [a:path] + a:000)
endfunction

function! s:AbortOnError(cmd) abort
  try
    exe a:cmd
  catch '^Vim(\w\+):E\d'
    return 'return ' . string('echoerr ' . string(matchstr(v:exception, ':\zsE\d.*')))
  endtry
  return ''
endfunction

function! s:MinusOne(...) abort
  return -1
endfunction

function! EunuchRename(src, dst) abort
  if a:src !~# '^\a\a\+:' && a:dst !~# '^\a\a\+:'
    return rename(a:src, a:dst)
  endif
  try
    let fn = s:ffn('writefile', a:dst)
    let copy = call(fn, [s:fcall('readfile', a:src, 'b'), a:dst])
    if copy == 0
      let delete = s:fcall('delete', a:src)
      if delete == 0
        return 0
      else
        call s:fcall('delete', a:dst)
        return -1
      endif
    endif
  catch
    return -1
  endtry
endfunction

function! s:MkdirCallable(name) abort
  let ns = matchstr(a:name, '^\a\a\+\ze:')
  if !s:fcall('isdirectory', a:name) && s:fcall('filewritable', a:name) !=# 2
    if exists('g:io_' . ns . '.mkdir')
      return [g:io_{ns}.mkdir, [a:name, 'p']]
    elseif empty(ns)
      return ['mkdir', [a:name, 'p']]
    endif
  endif
  return ['s:MinusOne', []]
endfunction

function! s:Delete(path) abort
  if has('patch-7.4.1107') && isdirectory(a:path)
    return delete(a:path, 'd')
  else
    return s:fcall('delete', a:path)
  endif
endfunction

command! -bar -bang -nargs=? -complete=dir Mkdir
      \ let s:dst = empty(<q-args>) ? expand('%:h') : <q-args> |
      \ if call('call', s:MkdirCallable(s:dst)) == -1 |
      \   echohl WarningMsg |
      \   echo "Directory already exists: " . s:dst |
      \   echohl NONE |
      \ elseif empty(<q-args>) |
      \    silent keepalt execute 'file' fnameescape(@%) |
      \ endif |
      \ unlet s:dst

function! s:DeleteError(file) abort
  if empty(s:fcall('getftype', a:file))
    return 'Could not find "' . a:file . '" on disk'
  else
    return 'Failed to delete "' . a:file . '"'
  endif
endfunction

command! -bar -bang Unlink
      \ if <bang>1 && &undoreload >= 0 && line('$') >= &undoreload |
      \   echoerr "Buffer too big for 'undoreload' (add ! to override)" |
      \ elseif s:Delete(@%) |
      \   echoerr s:DeleteError(@%) |
      \ else |
      \   edit! |
      \   silent exe 'doautocmd <nomodeline> User FileUnlinkPost' |
      \ endif

command! -bar -bang Remove Unlink<bang>

command! -bar -bang Delete
      \ if <bang>1 && !(line('$') == 1 && empty(getline(1)) || s:fcall('getftype', @%) !=# 'file') |
      \   echoerr "File not empty (add ! to override)" |
      \ else |
      \   let s:file = expand('%:p') |
      \   execute 'bdelete<bang>' |
      \   if !bufloaded(s:file) && s:Delete(s:file) |
      \     echoerr s:DeleteError(s:sfile) |
      \   endif |
      \   unlet s:file |
      \ endif

function! s:FileDest(q_args) abort
  let file = a:q_args
  if file =~# s:slash_pat . '$'
    let file .=  expand('%:t')
  elseif s:fcall('isdirectory', file)
    let file .= s:separator() .  expand('%:t')
  endif
  return substitute(file, '^\.' . s:slash_pat, '', '')
endfunction

command! -bar -nargs=1 -bang -complete=file Copy
      \ let s:dst = s:FileDest(<q-args>) |
      \ call call('call', s:MkdirCallable(fnamemodify(s:dst, ':h'))) |
      \ let s:dst = s:fcall('simplify', s:dst) |
      \ exe expand('<mods>') 'saveas<bang>' fnameescape(remove(s:, 'dst')) |
      \ filetype detect

function! s:Move(bang, arg) abort
  let dst = s:FileDest(a:arg)
  exe s:AbortOnError('call call("call", s:MkdirCallable(' . string(fnamemodify(dst, ':h')) . '))')
  let dst = s:fcall('simplify', dst)
  if !a:bang && s:fcall('filereadable', dst)
    let confirm = &confirm
    try
      if confirm | set noconfirm | endif
      exe s:AbortOnError('keepalt saveas ' . fnameescape(dst))
    finally
      if confirm | set confirm | endif
    endtry
  endif
  if s:fcall('filereadable', @%) && EunuchRename(@%, dst)
    return 'echoerr ' . string('Failed to rename "'.@%.'" to "'.dst.'"')
  else
    let last_bufnr = bufnr('$')
    exe s:AbortOnError('silent keepalt file ' . fnameescape(dst))
    if bufnr('$') != last_bufnr
      exe bufnr('$') . 'bwipe'
    endif
    setlocal modified
    return 'write!|filetype detect'
  endif
endfunction

command! -bar -nargs=1 -bang -complete=file Move exe s:Move(<bang>0, <q-args>)

let s:absolute_pat = '^[~$#%]\|^' . s:slash_pat . '\|^\a\+:'

function! s:RenameComplete(A, L, P) abort
  let sep = s:separator()
  if a:A =~# s:absolute_pat
    let prefix = ''
  else
    let prefix = expand('%:h') . sep
  endif
  let files = split(glob(prefix.a:A.'*'), "\n")
  call map(files, 'fnameescape(strpart(v:val, len(prefix))) . (isdirectory(v:val) ? sep : "")')
  return files
endfunction

function! s:RenameArg(arg) abort
  if a:arg =~# s:absolute_pat
    return a:arg
  else
    return '%:h/' . a:arg
  endif
endfunction

command! -bar -nargs=1 -bang -complete=customlist,s:RenameComplete Duplicate
      \ exe 'Copy<bang>' escape(s:RenameArg(<q-args>), '"|')

command! -bar -nargs=1 -bang -complete=customlist,s:RenameComplete Rename
      \ exe 'Move<bang>' escape(s:RenameArg(<q-args>), '"|')

let s:permlookup = ['---','--x','-w-','-wx','r--','r-x','rw-','rwx']
function! s:Chmod(bang, perm, ...) abort
  let autocmd = 'silent doautocmd <nomodeline> User FileChmodPost'
  let file = a:0 ? expand(join(a:000, ' ')) : @%
  if !a:bang && exists('*setfperm')
    let perm = ''
    if a:perm =~# '^\0*[0-7]\{3\}$'
      let perm = substitute(a:perm[-3:-1], '.', '\=s:permlookup[submatch(0)]', 'g')
    elseif a:perm ==# '+x'
      let perm = substitute(s:fcall('getfperm', file), '\(..\).', '\1x', 'g')
    elseif a:perm ==# '-x'
      let perm = substitute(s:fcall('getfperm', file), '\(..\).', '\1-', 'g')
    endif
    if len(perm) && file =~# '^\a\a\+:' && !s:fcall('setfperm', file, perm)
      return autocmd
    endif
  endif
  if !executable('chmod')
    return 'echoerr "No chmod command in path"'
  endif
  let out = get(split(system('chmod '.(a:bang ? '-R ' : '').a:perm.' '.shellescape(file)), "\n"), 0, '')
  return len(out) ? 'echoerr ' . string(out) : autocmd
endfunction

command! -bar -bang -nargs=+ Chmod
      \ exe s:Chmod(<bang>0, <f-args>)

function! s:FindPath() abort
  if !has('win32')
    return 'find'
  elseif !exists('s:find_path')
    let s:find_path = 'find'
    for p in split($PATH, ';')
      let prg_path = p ..'/find'
      if p !~? '\<System32\>' && executable(prg_path)
        let s:find_path = prg_path
        break
      endif
    endfor
  endif
  return s:find_path
endf

command! -bang -complete=file -nargs=+ Cfind   exe s:Grep(<q-bang>, <q-args>, s:FindPath(), '')
command! -bang -complete=file -nargs=+ Clocate exe s:Grep(<q-bang>, <q-args>, 'locate', '')
command! -bang -complete=file -nargs=+ Lfind   exe s:Grep(<q-bang>, <q-args>, s:FindPath(), 'l')
command! -bang -complete=file -nargs=+ Llocate exe s:Grep(<q-bang>, <q-args>, 'locate', 'l')
function! s:Grep(bang, args, prg, type) abort
  let grepprg = &l:grepprg
  let grepformat = &l:grepformat
  let shellpipe = &shellpipe
  try
    let &l:grepprg = a:prg
    setlocal grepformat=%f
    if &shellpipe ==# '2>&1| tee' || &shellpipe ==# '|& tee'
      let &shellpipe = "| tee"
    endif
    execute a:type.'grep! '.a:args
    if empty(a:bang) && !empty(getqflist())
      return 'cfirst'
    else
      return ''
    endif
  finally
    let &l:grepprg = grepprg
    let &l:grepformat = grepformat
    let &shellpipe = shellpipe
  endtry
endfunction

function! s:SilentSudoCmd(editor) abort
  let cmd = 'env SUDO_EDITOR=' . a:editor . ' VISUAL=' . a:editor . ' sudo -e'
  let local_nvim = has('nvim') && len($DISPLAY . $SECURITYSESSIONID . $TERM_PROGRAM)
  if !local_nvim && (!has('gui_running') || &guioptions =~# '!')
    redraw
    echo
    return ['silent', cmd]
  elseif !empty($SUDO_ASKPASS) ||
        \ filereadable('/etc/sudo.conf') &&
        \ len(filter(readfile('/etc/sudo.conf', '', 50), 'v:val =~# "^Path askpass "'))
    return ['silent', cmd . ' -A']
  else
    return [local_nvim ? 'silent' : '', cmd]
  endif
endfunction

augroup eunuch_sudo
augroup END

function! s:SudoSetup(file, resolve_symlink) abort
  let file = a:file
  if a:resolve_symlink && getftype(file) ==# 'link'
    let file = resolve(file)
    if file !=# a:file
      silent keepalt exe 'file' fnameescape(file)
    endif
  endif
  let file = substitute(file, s:slash_pat, '/', 'g')
  if file !~# '^\a\+:\|^/'
    let file = substitute(getcwd(), s:slash_pat, '/', 'g') . '/' . file
  endif
  if !filereadable(file) && !exists('#eunuch_sudo#BufReadCmd#'.fnameescape(file))
    execute 'autocmd eunuch_sudo BufReadCmd ' fnameescape(file) 'exe s:SudoReadCmd()'
  endif
  if !filewritable(file) && !exists('#eunuch_sudo#BufWriteCmd#'.fnameescape(file))
    execute 'autocmd eunuch_sudo BufReadPost' fnameescape(file) 'set noreadonly'
    execute 'autocmd eunuch_sudo BufWriteCmd' fnameescape(file) 'exe s:SudoWriteCmd()'
  endif
endfunction

let s:error_file = tempname()

function! s:SudoError() abort
  let error = join(readfile(s:error_file), " | ")
  if error =~# '^sudo' || v:shell_error
    return len(error) ? error : 'Error invoking sudo'
  else
    return error
  endif
endfunction

function! s:SudoReadCmd() abort
  if &shellpipe =~ '|&'
    return 'echoerr ' . string('eunuch.vim: no sudo read support for csh')
  endif
  silent %delete_
  silent doautocmd <nomodeline> BufReadPre
  let [silent, cmd] = s:SilentSudoCmd('cat')
  execute silent 'read !' . cmd . ' "%" 2> ' . s:error_file
  let exit_status = v:shell_error
  silent 1delete_
  setlocal nomodified
  if exit_status
    return 'echoerr ' . string(s:SudoError())
  else
    return 'silent doautocmd BufReadPost'
  endif
endfunction

function! s:SudoWriteCmd() abort
  silent doautocmd <nomodeline> BufWritePre
  let [silent, cmd] = s:SilentSudoCmd(shellescape('sh -c cat>"$0"'))
  execute silent 'write !' . cmd . ' "%" 2> ' . s:error_file
  let error = s:SudoError()
  if !empty(error)
    return 'echoerr ' . string(error)
  else
    setlocal nomodified
    return 'silent doautocmd <nomodeline> BufWritePost'
  endif
endfunction

command! -bar -bang -complete=file -nargs=? SudoEdit
      \ let s:arg = resolve(<q-args>) |
      \ call s:SudoSetup(fnamemodify(empty(s:arg) ? @% : s:arg, ':p'), empty(s:arg) && <bang>0) |
      \ if !&modified || !empty(s:arg) || <bang>0 |
      \   exe 'edit<bang>' fnameescape(s:arg) |
      \ endif |
      \ if empty(<q-args>) || expand('%:p') ==# fnamemodify(s:arg, ':p') |
      \   set noreadonly |
      \ endif |
      \ unlet s:arg

if exists(':SudoWrite') != 2
command! -bar -bang SudoWrite
      \ call s:SudoSetup(expand('%:p'), <bang>0) |
      \ setlocal noreadonly |
      \ write!
endif

command! -bar Wall call s:Wall()
if exists(':W') !=# 2
  command! -bar W Wall
endif
function! s:Wall() abort
  let tab = tabpagenr()
  let win = winnr()
  let seen = {}
  if !&readonly && &buftype =~# '^\%(acwrite\)\=$' && expand('%') !=# ''
    let seen[bufnr('')] = 1
    write
  endif
  tabdo windo if !&readonly && &buftype =~# '^\%(acwrite\)\=$' && expand('%') !=# '' && !has_key(seen, bufnr('')) | silent write | let seen[bufnr('')] = 1 | endif
  execute 'tabnext '.tab
  execute win.'wincmd w'
endfunction

let s:interpreters = {
      \ '.': '/bin/sh',
      \ 'sh': '/bin/sh',
      \ 'bash': 'bash',
      \ 'csh': 'csh',
      \ 'tcsh': 'tcsh',
      \ 'zsh': 'zsh',
      \ 'tcl': 'tclsh',
      \ 'expect': 'expect',
      \ 'gnuplot': 'gnuplot',
      \ 'make': 'make -f',
      \ 'pike': 'pike',
      \ 'lua': 'lua',
      \ 'perl': 'perl',
      \ 'php': 'php',
      \ 'python': 'python3',
      \ 'groovy': 'groovy',
      \ 'raku': 'raku',
      \ 'ruby': 'ruby',
      \ 'javascript': 'node',
      \ 'bc': 'bc',
      \ 'sed': 'sed',
      \ 'ocaml': 'ocaml',
      \ 'awk': 'awk',
      \ 'wml': 'wml',
      \ 'scheme': 'scheme',
      \ 'cfengine': 'cfengine',
      \ 'erlang': 'escript',
      \ 'haskell': 'haskell',
      \ 'scala': 'scala',
      \ 'clojure': 'clojure',
      \ 'pascal': 'instantfpc',
      \ 'fennel': 'fennel',
      \ 'routeros': 'rsc',
      \ 'fish': 'fish',
      \ 'forth': 'gforth',
      \ }

function! s:NormalizeInterpreter(str) abort
  if empty(a:str) || a:str =~# '^[ /]'
    return a:str
  elseif a:str =~# '[ \''"#]'
    return '/usr/bin/env -S ' . a:str
  else
    return '/usr/bin/env ' . a:str
  endif
endfunction

function! s:FileTypeInterpreter() abort
  try
    let ft = get(split(&filetype, '\.'), 0, '.')
    let configured = get(g:, 'eunuch_interpreters', {})
    if type(get(configured, ft)) == type(function('tr'))
      return call(configured[ft], [])
    elseif get(configured, ft) is# 1 || get(configured, ft) is# get(v:, 'true', 1)
      return ft ==# '.' ? s:interpreters['.'] : '/usr/bin/env ' . ft
    elseif empty(get(configured, ft, 1))
      return ''
    elseif type(get(configured, ft)) == type('')
      return s:NormalizeInterpreter(get(configured, ft))
    endif
    return s:NormalizeInterpreter(get(s:interpreters, ft, ''))
  endtry
endfunction

let s:shebang_pat = '^#!\s*[/[:alnum:]_-]'

function! EunuchNewLine(...) abort
  if a:0 && type(a:1) == type('')
    return a:1 . (a:1 =~# "\r" && empty(&buftype) ? "\<C-R>=EunuchNewLine()\r" : "")
  endif
  if !empty(&buftype) || getline(1) !~# '^#!$\|' . s:shebang_pat || line('.') != 2 || getline(2) !~# '^#\=$'
    return ""
  endif
  let b:eunuch_chmod_shebang = 1
  let inject = ''
  let detect = 0
  let ret = empty(getline(2)) ? "" : "\<C-U>"
  if getline(1) ==# '#!'
    let inject = s:FileTypeInterpreter()
    let detect = !empty(inject) && empty(&filetype)
  else
    filetype detect
    if getline(1) =~# '^#![^ /].\{-\}[ \''"#]'
      let inject = '/usr/bin/env -S '
    elseif getline(1) =~# '^#![^ /]'
      let inject = '/usr/bin/env '
    endif
  endif
  if len(inject)
    let ret .= "\<Up>\<Right>\<Right>" . inject . "\<Home>\<Down>"
  endif
  if detect
    let ret .= "\<C-\>\<C-O>:filetype detect\r"
  endif
  return ret
endfunction

function! s:MapCR() abort
  imap <silent><script> <SID>EunuchNewLine <C-R>=EunuchNewLine()<CR>
  let map = maparg('<CR>', 'i', 0, 1)
  let rhs = substitute(get(map, 'rhs', ''), '\c<sid>', '<SNR>' . get(map, 'sid') . '_', 'g')
  if get(g:, 'eunuch_no_maps') || rhs =~# 'Eunuch' || get(map, 'desc') =~# 'Eunuch' || get(map, 'buffer')
    return
  endif
  let imap = get(map, 'script', rhs !~? '<plug>') || get(map, 'noremap') ? 'imap <script>' : 'imap'
  if get(map, 'expr') && type(get(map, 'callback')) == type(function('tr'))
    lua local m = vim.fn.maparg('<CR>', 'i', 0, 1); vim.api.nvim_set_keymap('i', '<CR>', m.rhs or '', { expr = true, silent = true, callback = function() return vim.fn.EunuchNewLine(vim.api.nvim_replace_termcodes(m.callback(), true, true, m.replace_keycodes)) end, desc = "EunuchNewLine() wrapped around " .. (m.desc or "Lua function") })
  elseif get(map, 'expr') && !empty(rhs)
    exe imap '<silent><expr> <CR> EunuchNewLine(' . rhs . ')'
  elseif rhs =~? '^\%(<c-\]>\)\=<cr>' || rhs =~# '<[Pp]lug>\w\+CR'
    exe imap '<silent> <CR>' rhs . '<SID>EunuchNewLine'
  elseif empty(rhs)
    imap <script><silent><expr> <CR> EunuchNewLine("<Bslash>035<Bslash>r")
  endif
endfunction
call s:MapCR()

augroup eunuch
  autocmd!
  autocmd BufNewFile  * let b:eunuch_chmod_shebang = 1
  autocmd BufReadPost * if getline(1) !~# '^#!\s*\S' | let b:eunuch_chmod_shebang = 1 | endif
  autocmd BufWritePost,FileWritePost * nested
        \ if exists('b:eunuch_chmod_shebang') && getline(1) =~# s:shebang_pat |
        \   call s:Chmod(0, '+x', '<afile>') |
        \   edit |
        \ endif |
        \ unlet! b:eunuch_chmod_shebang
  autocmd InsertLeave * nested if line('.') == 1 && getline(1) ==# @. && @. =~# s:shebang_pat |
        \ filetype detect | endif
  autocmd User FileChmodPost,FileUnlinkPost "
  autocmd VimEnter * call s:MapCR() |
        \ if has('patch-8.1.1113') || has('nvim-0.4') |
        \   exe 'autocmd eunuch InsertEnter * ++once call s:MapCR()' |
        \ endif
augroup END


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

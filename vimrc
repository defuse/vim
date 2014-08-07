" ============= FUNCTIONALITY =============
    " This is not a virus. It is required by pathogen.vim, which does something
    " or other with plugins.
    execute pathogen#infect()

    set nocompatible

    " Don't leak shit to the .viminfo file in my home directory.
    set viminfo="NONE"

    " Make j,k move by screen lines instead of file lines.
    " WARNING: If you use this vimrc, make sure you understand the implications
    " of the following two mappings, especially if you use macros frequently.
    " A temporary workaround for writing macros is to go into insert mode, use
    " the up/down arrow keys, then exit to normal mode.
    map j gj
    map k gk

    " TODO: Uncomment these lines to enable clipboard-over-ssh with a headless
    " server. Both ends must have xclip installed and X forwarding must be ON.
    " Add 'ForwardX11 yes' to /etc/ssh/ssh_config to avoid having to type
    " ssh -X so much.
    "vmap "+y :!xclip -f -sel clip<CR>
    "map "+p :r!xclip -o -sel clip<CR>

    " backspace and cursor keys wrap to previous/next line
    "set backspace=indent,eol,start whichwrap+=<,>,[,]

    " backspace in Visual mode deletes selection
    vnoremap <BS> d

    " Alt-Space is System menu
    if has("gui")
      noremap <M-Space> :simalt ~<CR>
      inoremap <M-Space> <C-O>:simalt ~<CR>
      cnoremap <M-Space> <C-C>:simalt ~<CR>
    endif

    " Make indenting and unindenting in visual mode retain the selection so
    " you don't have to re-select or type gv every time.
    vnoremap > ><CR>gv
    vnoremap < <<CR>gv

    " Make CTRL+u and CTRL+d less confusing
    map <C-u> 10<C-Y>10k
    map <C-d> 10<C-E>10j
    " Scroll the /screen/ with ALT+{j,k}
    map <A-j> 2<C-E>
    map <A-k> 2<C-Y>

    " Switch windows quickly with CTRL+{h,j,k,l}
    " This breaks backspace in a terminal, but I never use backspace in normal mode
    map <C-h> <C-W>h
    map <C-j> <C-W>j
    map <C-k> <C-W>k
    map <C-l> <C-W>l
    " This would break in a terminal where ^H is backspace.
    if has("gui_running")
        imap <C-h> <Esc><C-W>h
    endif
    imap <C-j> <Esc><C-W>j
    imap <C-k> <Esc><C-W>k
    imap <C-l> <Esc><C-W>l

    " Quickly switch between buffers with CTRL+b
    map <C-b> :b#<Cr> 

    " Easy save from any mode
    imap <C-\> <Esc>:w<Cr>
    map <C-\> <Esc>:w<Cr>
    " So both C-[ and C-] are equivalent to <Esc> (widen the target area)
    " Note that in normal mode, C-] means follow link, so you should train 
    " yourself to use C-[, this is just here in case you screw up once.
    imap <C-]> <Esc>
    vmap <C-]> <Esc>

    " FIXME: this breaks c-u for scrolling
    " " Make <C-y> behave as "+y so that in visual mode it copies to the clipboard
    " " and in normal mode it sets it up to copy the next movement.
    " vmap <C-y> "+y
    " nmap <C-y> "+y
    " " Can't use C-p for paste since it overlaps with CtrlP plugin and completion
    " " so paste from the clipboard by doing a C-y in insert mode.
    " " FIXME: sometimes the stuff is in * and sometimes its in " wtf...
    " imap <C-y> <F5><C-r>*<F5>
    " " Note: <F5> is the paste toggle set below.

    set listchars=tab:>-,eol:$
    set foldmethod=marker
    set tabstop=4
    set shiftwidth=4
    set autoindent
    set expandtab
    " Allow middle-click pasting of large texts in terminal
    set pastetoggle=<F5>
    " Clear paste mode when going back to normal mode
    au InsertLeave * set nopaste
    set sidescrolloff=20
    set wrap linebreak textwidth=0
    " Automatic indentation based on file type
    filetype indent on
    filetype plugin on
    set backspace=2
    set history=1000
    " First tab completes as much as possible and shows the list if there is
    " more than one matching item. Next tabs iterate through the list.
    set wildmode=list:longest,full
    set wildmenu
    set incsearch
    set hidden
    set splitright
    set splitbelow 
    set shiftround
    set nostartofline
    set smarttab

    set nobackup
    set nowb
    set noswapfile

    " By default, J and gq put two spaces after a period.
    " I like one space after a period, so turn that off.
    set nojoinspaces

    " More intuitive selecting in visual mode
    set selection=exclusive

    " Visual mode pressing * or # searches for the current selection
    " Super useful! From an idea by Michael Naumann
    vnoremap <silent> * :call VisualSelection('f')<CR>
    vnoremap <silent> # :call VisualSelection('b')<CR>

    " Double slash -> Case insensitive search
    map // /\c
    map ?? ?\c

    " Easy access to NERDTree
    nmap ,e :NERDTreeToggle<CR>
    if(!exists('vimrc_already_sourced'))
        command Nt NERDTree
        command Nc NERDTreeClose
    endif

    " Fix annoying surround.vim message
    vmap s S

    "let g:EasyMotion_leader_key = '<Leader>'
    let g:EasyMotion_leader_key = 'z'

    " ----------------------- Diff Commands ---------------------------------
    function! s:DiffWithSaved()
      let filetype=&ft
      diffthis
      vnew | r # | normal! 1Gdd
      diffthis
      exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
    endfunction
    com! DiffSaved call s:DiffWithSaved()

    function! s:DiffWithCVSCheckedOut()
      let filetype=&ft
      diffthis
      vnew | r !cvs up -pr BASE #
      1,6d
      diffthis
      exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
    endfunction
    com! DiffCVS call s:DiffWithCVSCheckedOut()

    function! s:DiffWithSVNCheckedOut()
      let filetype=&ft
      diffthis
      vnew | exe "%!svn cat " . expand("#:p:h")
      diffthis
      exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
    endfunction
    com! DiffSVN call s:DiffWithSVNCheckedOut()
    " ----------------------- End Diff Commands ------------------------------

    " tab navigation like firefox
    nmap <C-S-tab> :tabprevious<CR>
    nmap <C-tab> :tabnext<CR>
    map <C-S-tab> :tabprevious<CR>
    map <C-tab> :tabnext<CR>
    imap <C-S-tab> <Esc>:tabprevious<CR>i
    imap <C-tab> <Esc>:tabnext<CR>i
    "nmap <C-t> :tabnew<CR>
    "imap <C-t> <Esc>:tabnew<CR>

    " TAB on select indents:
    " Note: Using > and < is a lot easier!
    smap <Tab> <Esc>:'<,'> > <CR>
    vmap <Tab> <Esc>:'<,'> > <CR>gv

    " Omnicomplete
    " TODO: Windows needs CTAGS http://vim.wikia.com/wiki/Omni_completion
    " apt-get install exuberant-ctags
    " set ofu=syntaxcomplete#Complete

    " Don't auto-wrap long lines that are already longer
    set formatoptions+=l
    " Don't wrap before a one-letter word.
    set formatoptions+=1
    set lbr

    set ttyfast

    " ---- PRINTING ----
    set popt=left:1in,right:1in,top:1in,bottom:1in,header:2,syntax:a,paper:letter
    " On PostScript systems, Vim ignores the font but NOT the size.
    " So this will make us print in 8-pt (but not necessarily courier)
    set printfont=courier:h8
    set printoptions+=duplex:off
    "set printoptions+=duplex:long

    " Make snipmate HTML snippets work in php and eruby files
    au BufRead,BufNewFile *.php set filetype=php.html
    au BufRead,BufNewFile *.erb set filetype=eruby.html
    au BufRead,BufNewFile *.md set filetype=markdown

    set iskeyword +=-,_

    " Use unix line endings (LF) unless the file already has DOS line endings
    set fileformats=unix,dos
    " Set the initial buffer to unix line endings
    set fileformat=unix

    " Don't comment the new line when pressing o or O on a commented line
    " This block must come after the other filetype lines in this file.
    set formatoptions -=o
    augroup myft
      au!
      au FileType * setlocal formatoptions-=o
    augroup END

    " Use strong encryption
    set cm=blowfish

    " Use vim's current working directory but fall back to the file directory
    " if it's way off.
    let g:ctrlp_working_path_mode = 'a'

    " Fast buffer search
    nmap ; :CtrlPBuffer<CR>
    nmap ,b :CtrlP<CR>

    set wildignore+=*.aux,*.log,*.class
    let g:ctrlp_custom_ignore = {
        \ 'dir': '\v[\/]\.(git|hg|svn)$',
        \ 'file': '\v\.(exe|so|dll|class|aux|log)$',
      \ }

    set tw=80

    " Highlight other references to the variable under the cursor
    " autocmd CursorMoved * exe printf('match NonText /\V\<%s\>/', escape(expand('<cword>'), '/\'))

    autocmd BufNewFile,BufReadPost *.ino,*.pde set filetype=cpp

    " Make sure we don't syntax check when a file is open as doing so might lead
    " to vulnerabilities or performance issues.
    let g:syntastic_check_on_open = 0
    " Always stick detected errors into the location list.
    let g:syntastic_always_populate_loc_list=1
    " Automatically open when errors are detected and close when there are none.
    let g:syntastic_auto_loc_list=1
    " Default only to 5 lines instead of 10 (better when in the terminal)
    let g:syntastic_loc_list_height = 5

    " For easy updating of work standup log
    command Standup !git commit -a -m "update Taylor's standup log"; git push

" ================ VISUAL =================

    colorscheme dw_cyan
    set background=dark
    syntax on

    " gnome-terminal really does support 256 colors, and jellybeans looks nice
    "in 256 colors. The &t_Co==8 is a hack to detect gnome-terminal vs
    "console2 (which does not support 256 color)
    if !has("gui_running") && &t_Co==8
        set t_Co=256
        colorscheme jellybeans
        " Make spelling mistake highlighting easier on the eyes.
        hi clear SpellBad
        hi SpellBad cterm=underline ctermfg=red
        hi clear SpellCap
        hi SpellCap cterm=underline ctermfg=blue
        hi clear SpellLocal
        hi SpellLocal cterm=underline ctermfg=blue
        hi clear SpellRare
        hi SpellRare cterm=underline ctermfg=blue
    else
        " dw_cyan modifications
        hi CursorLine cterm=NONE ctermbg=black guibg=#101520
        hi CursorColumn cterm=NONE ctermbg=black guibg=#101520
        highlight Cursor guifg=black guibg=yellow
        highlight iCursor guifg=black guibg=yellow
        set guicursor+=a:blinkon0
    end

    if has("gui_running")
        " Make statusline color depend on the current mode
        " TODO: make visual/select mode dark green
        function! InsertStatuslineColor(mode)
        if a:mode == 'i'
            hi statusline guibg=#005151 ctermbg=darkgray
        elseif a:mode == 'r'
            hi statusline guibg=#000071
        else
            hi statusline guibg=#710000
        endif
        endfunction

        au InsertEnter * call InsertStatuslineColor(v:insertmode)
        " Default status line color (the following two 'hi' should be the same)
        au InsertLeave * hi StatusLine cterm=NONE ctermbg=NONE ctermfg=gray guibg=#202020 guifg=white
    end
    hi StatusLine cterm=NONE ctermbg=NONE ctermfg=gray guibg=#202020 guifg=white 

    " Highlight column 80 (color set here because most themes don't specify it)
    if v:version >= 703
        set cc=80
        hi ColorColumn ctermbg=Gray ctermfg=Black guibg=#404040
        if(!exists('vimrc_already_sourced'))
            command Skinny set cc=73
            command Wide set cc=80
        endif
    endif

    " Highlight unwanted whitespace
    highlight TrailingWhitespace ctermbg=red guibg=red
    highlight TabWhitespace ctermbg=darkgreen guibg=darkgreen
    autocmd Syntax * syn match TrailingWhitespace /\s\+$/
    autocmd Syntax * syn match TabWhitespace /[\t]/

    " Highlight the line the cursor is on
    set cursorline

    " Always show the last line on the screen, even when it's too long (gets
    " rid of the annoying @@@@@ crap)
    set display+=lastline

    " Always show the status line
    set laststatus=2
    " Status line content
    "set statusline=%n:\ %F\ [%{&ff}]%y%m%h%w%r\ %=char=0x%B\ \ \ x=%v\ y=%l/%L\ -\ %p%%\ 
    set statusline=%n:\ %F\ [%{&ff}]%y%m%h%w%r\ %=[char:\ 0x%B]\ \[column:\ %v]\ [line:\ %l\ of\ %L\ \(%p%%\)]\ 

    " Make the default window size bigger
    if has("gui_running") && !exists('vimrc_already_sourced')
        set lines=32 columns=120
    endif

    " Use forward slashes in windows
    set shellslash

    " No annoying flashes
    set novb

    " Fix GNOME disappearing mouse bug
    set nomousehide

    set mouse=nicr

    "Hide the toolbar
    set guioptions-=T
    " Hide the menu bar
    set guioptions-=m
    " Scroll bars are for noobs
    set guioptions-=r
    set guioptions-=l
    set guioptions-=L
    " Make visual selection copy to the middle click buffer.
    " If enabled on Windows, this will make selection copy to the Windows
    " clipboard, which can be a pain if you need to select something and
    " delete it before pasting.
    if has("unix")
      set guioptions+=a
    endif
    " When in gui mode, don't open an entire messagebox to ask a question
    set guioptions+=c

    " Quickly jump to opening brace and back to avoid mistakes
    set showmatch
    set matchtime=1

    " Line numbers
    set nu

    if has("unix")
        set guifont=Monospace\ 8
    else
        set guifont=Lucida_Console:h10:cANSI
    endif

    " $ for change command instead of deleting word then insert
    set cpoptions+=$

    " Highlight search terms
    set hlsearch

    " Skip the splash screen
    set shortmess+=I

    " Don't update the display while executing macros
    set lazyredraw

    " When the page starts to scroll, keep the cursor 4 lines from the top and 8
    " lines from the bottom
    set scrolloff=4

    " Show the command as it's being typed in the lower right
    set showcmd

    " Spell checking
    setglobal spell spelllang=en_ca
    " By default spelling is off...
    set nospell
    " ...but enable it for the English text files I use a lot.
    au BufRead,BufNewFile,BufWrite *.txt,*.tex,*.latex set spell 

    " Keep more context when editing PHP files so Vim doesn't try to highlight
    " PHP as HTML and vice-versa.
    let php_minlines=500

    " Rainbow parentheses colors.
    " Left column is for terminal environment.
    " Right column is for GUI environment.
    " Outermost is determined by last.
    let g:rbpt_colorpairs = [
        \ ['blue',       '#FF6000'],
        \ ['cyan', '#00FFFF'],
        \ ['darkmagenta',    '#CC00FF'],
        \ ['yellow',   '#FFFF00'],
        \ ['red',     '#FF0000'],
        \ ['darkgreen',    '#00FF00'],
        \ ['White',         '#c0c0c0'], 
        \ ['blue',       '#FF6000'],
        \ ['cyan', '#00FFFF'],
        \ ['darkmagenta',    '#CC00FF'],
        \ ['yellow',   '#FFFF00'],
        \ ['red',     '#FF0000'],
        \ ['darkgreen',    '#00FF00'],
        \ ['White',         '#c0c0c0'], 
        \ ['blue',       '#FF6000'],
        \ ['cyan', '#00FFFF'],
        \ ['darkmagenta',    '#CC00FF'],
        \ ['yellow',   '#FFFF00'],
        \ ['red',     '#FF0000'],
        \ ['darkgreen',    '#00FF00'],
        \ ['White',         '#c0c0c0'], 
        \ ]

    " Update this with the amount of supported colors
    "let g:rbpt_max = 21
    let g:rbpt_max = 21

    " Turn rainbow parenthesis script on
    au VimEnter * RainbowParenthesesToggle
    " These are necessary to re-load the stuff when syntax changes.
    au Syntax * RainbowParenthesesLoadRound
    " I don't anything but ( and ) colored, so don't bother loading these
    "au Syntax * RainbowParenthesesLoadSquare
    "au Syntax * RainbowParenthesesLoadBraces

    let vimrc_already_sourced = 1


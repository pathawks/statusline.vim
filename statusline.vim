set laststatus=2
set statusline=%{StatusLineChangeColor()}
" set statusline+=%#StatusLin1#
" set statusline+=\ %{get(mode_map,mode())} " Mode
" set statusline+=\ %#StatusSep1#%#StatusLin2#
set statusline+=%#StatusLin2#
set statusline+=%{StatusLineGitBranch()}
set statusline+=\ %f                      " Filename
set statusline+=\ %#StatusSep2#%#StatusLin3#
set statusline+=%{StatusLineIcon()}       " Read-only or modified
set statusline+=%#StatusLin3#%=           " Seperator
set statusline+=%{&ff}                    " File Format
set statusline+=%{StatusLineFileTypeSep()}
set statusline+=%{&ft}\                   " File Type
set statusline+=%#StatusSep3#%#StatusLin4#
set statusline+=%3p%%                     " Percent through file
set statusline+=\ 
set statusline+=\ %3l\:%-3c               " Line and column
hi StatusLin1 ctermfg=239 ctermbg=109
hi StatusSep1 ctermfg=109 ctermbg=239
hi StatusLin2 ctermfg=151 ctermbg=239
hi StatusSep2 ctermfg=239 ctermbg=236
hi StatusLin3 ctermfg=245 ctermbg=236
hi StatusSep3 ctermfg=102 ctermbg=236
hi StatusLin4 ctermfg=237 ctermbg=102
hi StatusRuf0 ctermfg=239 ctermbg=000
hi StatusRuf1 ctermfg=102 ctermbg=239
"      

set laststatus=1
set ruler
set ruf=%30(%=%#StatusRuf0#%#StatusLin2#%{StatusLineRulerGitBranch()}%#StatusRuf1#%#StatusLin4#%3p%%\ %4l:%-3c%)

function! StatusLineIcon()
  if &readonly || !&modifiable
    return ' '
  elseif &modified
    return ' +'
  else
    return '  '
endfunction

function! StatusLineFileTypeSep()
  if empty(&ft)
    return ''
  else
    return '   '
endfunction

function! StatusLineChangeColor()
  if (mode() =~# 'n')
    exe 'hi M ctermfg=237 ctermbg=109'
"   exe 'hi! StatusLin1 ctermfg=237 ctermbg=109'
"   exe 'hi! StatusSep1 ctermfg=109 ctermbg=239'
  elseif (mode() ==? 'v' || mode() =~# 't')
    exe 'hi M ctermfg=000 ctermbg=139'
"   exe 'hi! StatusLin1 ctermfg=000 ctermbg=139'
"   exe 'hi! StatusSep1 ctermfg=139 ctermbg=239'
  elseif (mode() ==# 'i')
    exe 'hi M ctermfg=000 ctermbg=186'
"   exe 'hi! StatusLin1 ctermfg=000 ctermbg=186'
"   exe 'hi! StatusSep1 ctermfg=186 ctermbg=239'
  else
    exe 'hi M ctermfg=239 ctermbg=109'
"   exe 'hi! StatusLin1 ctermfg=239 ctermbg=109'
"   exe 'hi! StatusSep1 ctermfg=109 ctermbg=239'
  endif
  return ''
endfunction

let s:gitBranch = ''
function! StatusLineSetGitBranch()
  let b:dir = expand('%:h')
  let b:branch = system(expand('git -C "'.b:dir.'" rev-parse --abbrev-ref HEAD'))
  if b:branch !~# 'fatal: '
    let s:gitBranch = "\uE0A0".substitute(b:branch, '[\w\n#]', '', 'g')
    let s:gitBranchSep = ' '
  else
    let s:gitBranch = ''
    let s:gitBranchSep = ''
  endif
endfunction
function! StatusLineGitBranch()
  return "  ".s:gitBranch.s:gitBranchSep
endfunction
function! StatusLineRulerGitBranch()
  return s:gitBranch
endfunction
autocmd BufEnter,ShellCmdPost * call StatusLineSetGitBranch()

let mode_map = {
\ 'n': 'NORMAL', 'i': 'INSERT', 'R': 'REPLACE', 'v': 'VISUAL', 'V': 'V-LINE', "\<C-v>": 'V-BLOCK',
\ 'c': 'COMMAND', 's': 'SELECT', 'S': 'S-LINE', "\<C-s>": 'S-BLOCK', 't': 'TERMINAL'
\}

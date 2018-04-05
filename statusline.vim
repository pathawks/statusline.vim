set laststatus=2
" set statusline=%{StatusLineChangeColor()}
" set statusline+=%#StatusLin1#
" set statusline+=\ %{get(mode_map,mode())} " Mode
" set statusline+=\ %#StatusSep1#%#StatusLin2#
" set statusline+=%#StatusLin2#
set statusline=%#StatusLin2#
set statusline+=%{StatusLineGitBranch()}
set statusline+=\ %f                      " Filename
set statusline+=\ %#StatusSep2#%#StatusLin3#
set statusline+=%{StatusLineIcon()}       " Read-only or modified
set statusline+=%#StatusLin3#%=           " Seperator
set statusline+=%{&ff}                    " File Format
set statusline+=%{StatusLineFileTypeSep()}
set statusline+=%{&ft}\                   " File Type
set statusline+=%#StatusSep3#%#StatusLin4#
set statusline+=\ %{StatusLineGetPercent()} " Percent through file
set statusline+=%3l\:%-3c               " Line and column
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
set ruf=%32(%=%#StatusRuf0#%#StatusLin2#%{StatusLineRulerGitBranch()}%#StatusRuf1#%#StatusLin4#\ %{StatusLineGetPercent()}%3l:%-3c%)

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
function! s:StatusLineSetGitBranch()
  let b:dir = expand('%:h')
  let b:branch = system(expand('git -C "'.b:dir.'" rev-parse --abbrev-ref HEAD'))
  if b:branch !~# 'fatal: '
    let l:branch = substitute(b:branch, '[\w\n#]', '', 'g')
    if strwidth(l:branch) > 13
      let l:branch = strpart(l:branch,0,12).'…'
    endif
    let b:gitBranchRul = "\uE0A0".l:branch
    let b:gitBranchStat = '  '.b:gitBranchRul.' '
    hi StatusRuf0 ctermfg=239 ctermbg=000
    hi StatusRuf1 ctermfg=102 ctermbg=239
  else
    let b:gitBranchRul = ''
    let b:gitBranchStat = ''
    hi StatusRuf0 ctermfg=000 ctermbg=000
    hi StatusRuf1 ctermfg=102 ctermbg=000
  endif
endfunction
function! StatusLineGitBranch()
  if !exists("b:gitBranchStat")
    call s:StatusLineSetGitBranch()
  endif
  return b:gitBranchStat
endfunction
function! StatusLineRulerGitBranch()
  if !exists("b:gitBranchRul")
    call s:StatusLineSetGitBranch()
  endif
  return b:gitBranchRul
endfunction
autocmd ShellCmdPost * call s:StatusLineSetGitBranch()

function! s:SetPercent()
  let l:percent = line('.')*100/line('$')
  if line('w$')==line('$')
    if line('w0')<=1
      let b:StatusLinePercent = ''
    else
      let b:StatusLinePercent = 'Bot  '
    endif
  elseif line('w0')<=1
    let b:StatusLinePercent = 'Top  '
  elseif l:percent < 10
    let b:StatusLinePercent = ' '.l:percent.'%  '
  else
    let b:StatusLinePercent = l:percent.'%  '
  endif
endfunction
function! StatusLineGetPercent()
  if !exists("b:StatusLinePercent")
    call s:SetPercent()
  endif
  return b:StatusLinePercent
endfunction
autocmd CursorMoved,CursorMovedI * call s:SetPercent()

let mode_map = {
\ 'n': 'NORMAL', 'i': 'INSERT', 'R': 'REPLACE', 'v': 'VISUAL', 'V': 'V-LINE', "\<C-v>": 'V-BLOCK',
\ 'c': 'COMMAND', 's': 'SELECT', 'S': 'S-LINE', "\<C-s>": 'S-BLOCK', 't': 'TERMINAL'
\}

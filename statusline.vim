set statusline=%#StatusLin2#
set statusline+=%{StatusLineGitBranch()}
set statusline+=\ %f                      " Filename
set statusline+=\ %#StatusSep2#%#StatusLin3#
set statusline+=%{StatusLineIcon()}       " Read-only or modified
set statusline+=%#StatusLin3#%=           " Seperator
set statusline+=%{&ff}\                   " File Format
set statusline+=%{StatusLineFileType()}   " File Type
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

set ruf=%32(%=%#StatusRuf0#%#StatusLin2#%{StatusLineRulerGitBranch()}%#StatusRuf1#%#StatusLin4#\ %{StatusLineGetPercent()}%3l:%-3c%)

function! StatusLineIcon()
  if &readonly || !&modifiable
    return ' '
  elseif &modified
    return ' +'
  else
    return '  '
endfunction

function! StatusLineFileType()
  if empty(&ft)
    return ''
  else
    return ' '.&ft.' '
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
  if line('w$')==line('$')
    if line('w0')<=1
      let b:StatusLinePercent = ''
    else
      let b:StatusLinePercent = 'Bot  '
    endif
  elseif line('w0')<=1
    let b:StatusLinePercent = 'Top  '
  else
    let l:percent = line('.')*100/line('$')
    if l:percent < 10
      let b:StatusLinePercent = ' '.l:percent.'%  '
    else
      let b:StatusLinePercent = l:percent.'%  '
    endif
  endif
endfunction
function! StatusLineGetPercent()
  if !exists("b:StatusLinePercent")
    call s:SetPercent()
  endif
  return b:StatusLinePercent
endfunction
autocmd CursorMoved,CursorMovedI * call s:SetPercent()

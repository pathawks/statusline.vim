set laststatus=2
set statusline=%{StatusLineChangeColor()}
set statusline+=%#StatusLin1#
set statusline+=\ %{get(mode_map,mode())}
set statusline+=\ %#StatusSep1#%#StatusLin2#
set statusline+=%#StatusLin2#
set statusline+=\ %f  " Filename
set statusline+=\%{StatusLineReadOnly()}  " Readonly?
set statusline+=\ %#StatusSep2#%#StatusLin3#
set statusline+=%=  " Seperator
set statusline+=%{&ff}     " File Format
set statusline+=%{StatusLineFileTypeSep()}
set statusline+=%{&ft}\    " File Type
set statusline+=%#StatusSep3#%#StatusLin4#
set statusline+=\ %2p%% " Percent through file
set statusline+=\ 
set statusline+=\ %3l\:%-3c " Line and column
hi StatusLin1 ctermfg=239 ctermbg=109
hi StatusSep1 ctermfg=109 ctermbg=239
hi StatusLin2 ctermfg=151 ctermbg=239
hi StatusSep2 ctermfg=239 ctermbg=236
hi StatusLin3 ctermfg=245 ctermbg=236
hi StatusSep3 ctermfg=102 ctermbg=236
hi StatusLin4 ctermfg=237 ctermbg=102
"      

function! StatusLineReadOnly()
  if &readonly || !&modifiable
    return ' '
  else
    return ''
endfunction

function! StatusLineFileTypeSep()
  if empty(&ft)
    return ''
  else
    return '   '
endfunction

function! StatusLineChangeColor()
  if (mode() =~# 'n')
    exe 'hi! StatusLin1 ctermfg=237 ctermbg=109'
    exe 'hi! StatusSep1 ctermfg=109 ctermbg=239'
  elseif (mode() ==? 'v' || mode() =~# 't')
    exe 'hi! StatusLin1 ctermfg=000 ctermbg=139'
    exe 'hi! StatusSep1 ctermfg=139 ctermbg=239'
  elseif (mode() ==# 'i')
    exe 'hi! StatusLin1 ctermfg=000 ctermbg=186'
    exe 'hi! StatusSep1 ctermfg=186 ctermbg=239'
  else
    exe 'hi! StatusLin1 ctermfg=239 ctermbg=109'
    exe 'hi! StatusSep1 ctermfg=109 ctermbg=239'
  endif
  return ''
endfunction

let mode_map = {
\ 'n': 'NORMAL', 'i': 'INSERT', 'R': 'REPLACE', 'v': 'VISUAL', 'V': 'V-LINE', "\<C-v>": 'V-BLOCK',
\ 'c': 'COMMAND', 's': 'SELECT', 'S': 'S-LINE', "\<C-s>": 'S-BLOCK', 't': 'TERMINAL'
\}

" MIT License. Copyright (c) 2013-2018 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

if !exists(':Neomake')
  finish
endif

let s:error_symbol = get(g:, 'airline#extensions#robmake#error_symbol', 'E:')
let s:warning_symbol = get(g:, 'airline#extensions#robmake#warning_symbol', 'W:')

function! s:get_counts()
  let l:allCounts = neomake#statusline#LoclistCounts('all')
  let l:counts = {}
  for l:bufferCount in values(l:allCounts)
    for k in ['E', 'W']
      let l:count = get(l:bufferCount, k, 0)
      if l:count
        let l:counts[k] = get(l:counts, k, 0) + l:count
      endif
    endfor
  endfor

  if empty(l:counts)
    return neomake#statusline#QflistCounts()
  else
    return l:counts
  endif
endfunction

function! airline#extensions#robmake#get_warnings()
  let counts = s:get_counts()
  let warnings = get(counts, 'W', 0)
  return warnings ? s:warning_symbol : ''
endfunction

function! airline#extensions#robmake#get_errors()
  let counts = s:get_counts()
  let errors = get(counts, 'E', 0)
  return errors ? s:error_symbol : ''
endfunction

function! airline#extensions#robmake#init(ext)
  call airline#parts#define_function('robmake_warning_count', 'airline#extensions#robmake#get_warnings')
  call airline#parts#define_function('robmake_error_count', 'airline#extensions#robmake#get_errors')

  " Need to set this *after* the above functions have been created.
  " This is a mess.
  let g:airline_section_error = airline#section#create(['robmake_error_count'])
endfunction

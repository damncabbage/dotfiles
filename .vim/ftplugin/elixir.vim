" Run 'mix format' on save.
" (Clunky, but works for now.)
augroup MixFormat
  autocmd!
  autocmd BufWritePost *.ex,*.esx call system('mix format', '%:.')
  autocmd BufWritePost * edit
augroup end

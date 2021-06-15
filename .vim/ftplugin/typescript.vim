" Lint Fix
nnoremap <leader>ll :!eslint --fix %<CR>

" Culture Amp 'frontend-ops'-specific D:
" (frontend-ops has package/* and example/* workspaces set up, so I want to be
" able to quickly run jest and other commands on things within those
" workspaces.)
nnoremap <leader>yy :!yarn <C-R>=expand("%:gs?\\([^/][^/]*/[^/][^/]*\\)/.*?\\1?") . ' '<CR>
nnoremap <leader>yj :!yarn <C-R>=expand("%:gs?\\([^/][^/]*/[^/][^/]*\\)/.*?\\1?") . ' jest %'<CR>
nnoremap <leader>ys :!yarn <C-R>=expand("%:gs?\\([^/][^/]*/[^/][^/]*\\)/.*?\\1?") . ' jest %'<CR><CR>


" Indentation
set autoindent
set tabstop=4
set shiftwidth=4

" Colours
syntax on
set t_Co=256
colorscheme zenburn

" Shortcuts
cmap cmt <esc>^Da}<esc>%k/function<return>1wyt(j%a//end <esc>pa()<esc>

" Quick Markup
let g:user_zen_settings = {
\  'indentation' : '  ',
\  'perl' : {
\    'aliases' : {
\      'req' : 'require '
\    },
\    'snippets' : {
\      'use' : "use strict\nuse warnings\n\n",
\      'warn' : "warn \"|\";",
\    }
\  }
\}
let g:user_zen_expandabbr_key = '<c-y>'
let g:use_zen_complete_tag = 1

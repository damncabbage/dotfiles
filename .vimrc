" Indentation
set autoindent
set tabstop=4
set shiftwidth=4

" Colours
syntax on
set t_Co=256
colorscheme zenburn

" Search Highlights; press space to clear highlight.
set hlsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" Whitespace Stripping (disabled for the moment.)
"set listchars=tab:>.,trail:.,extends:#,nbsp:.
"autocmd filetype html,xml set listchars-=tab:>.
function StripTrailingWhitespace()
	if !&binary && &filetype != 'diff'
		normal mz
		normal Hmy
		%s/\s\+$//e
		normal 'yz<CR>
		normal `z
	endif
endfunction

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

" Indentation
set nocompatible
set autoindent
set tabstop=4
set shiftwidth=4

" Defer to plugins later for filetype-specific rules
filetype plugin on

" Plugin settings
au FileType vim,rb,ruby,rails filetype indent on " Only switch on indentation for a few types.
let g:omni_sql_no_default_maps = 1 " Stops Omni from grabbing left/right keys

" Colours
syntax on
set t_Co=256
colorscheme zenburn
hi Visual    ctermbg=232 " Colourscheme hacks; originally 235.
hi VisualNOS ctermbg=232

" Search Highlights; press space to clear highlight.
set hlsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" Tab shortcuts
nnoremap <C-h> :tabp<CR>
nnoremap <C-l> :tabn<CR>

" NERDTree
nnoremap ^ :NERDTree<CR>

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
\	'aliases' : {
\	  'req' : 'require '
\	},
\	'snippets' : {
\	  'use' : "use strict\nuse warnings\n\n",
\	  'warn' : "warn \"|\";",
\	}
\  }
\}
let g:user_zen_expandabbr_key = '<c-y>'
let g:use_zen_complete_tag = 1


" Source: http://stackoverflow.com/questions/164847/what-is-in-your-vimrc/1219104#1219104
" Filename
set statusline=%f\ 

" Display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

" Display a warning if file encoding isnt UTF-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

set statusline+=%h "help file flag
"set statusline+=%y "filetype
set statusline+=%r "read only flag
set statusline+=%m "modified flag

" Display a warning if the expandtab setting (&et) is wrong,
" or if we have mixed-indenting
set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*

set statusline+=%{StatuslineTrailingSpaceWarning()}

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Display a warning if we're in paste mode
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*

set statusline+=%= "left/right separator

" Show what type of symbol we're highlighting
set statusline+=%{StatuslineCurrentHighlight()}\ \ "
set statusline+=%c, "cursor column
set statusline+=%l/%L "cursor line/total lines
set statusline+=\ %P "percent through file
set laststatus=2

" Recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

" Return '[trailing]' if trailing white space is detected
" Return '' otherwise
function! StatuslineTrailingSpaceWarning()
	if !exists("b:statusline_trailing_space_warning")
		if search('\s\+$', 'nw') != 0
			let b:statusline_trailing_space_warning = '[trailing]'
		else
			let b:statusline_trailing_space_warning = ''
		endif
	endif
	return b:statusline_trailing_space_warning
endfunction

" Return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
	let name = synIDattr(synID(line('.'),col('.'),1),'name')
	if name == ''
		return ''
	else
		return '[' . name . ']'
	endif
endfunction

" Recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

" Return '[&et]' if &et is set wrong
" Return '[mixed-indenting]' if spaces and tabs are used to indent
" Return an empty string if everything is fine
function! StatuslineTabWarning()
	if !exists("b:statusline_tab_warning")
		let tabs = search('^\t', 'nw') != 0
		let spaces = search('^ ', 'nw') != 0

		if tabs && spaces
			let b:statusline_tab_warning = '[mixed-indenting]'
		elseif (spaces && !&et) || (tabs && &et)
			let b:statusline_tab_warning = '[&et]'
		else
			let b:statusline_tab_warning = ''
		endif
	endif
	return b:statusline_tab_warning
endfunction


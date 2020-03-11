:scriptencoding utf-8

function! AddJsDebug()
  let debug_method_name = "dbg"

  let debug_method_code = []
  call add(debug_method_code, "function " . debug_method_name . "(val, name, file, num){")
  " TODO: debounce?
  call add(debug_method_code, "  var cl = (new Error).stack.split(\"\\n\")[2]")
  call add(debug_method_code, "  var index = cl.indexOf('at ')")
	call add(debug_method_code, "  var clClean = cl.slice(index+3, cl.length)")
  call add(debug_method_code, "  console.log('[' + clClean + '] [' + name + ']:', val)")
  call add(debug_method_code, "  return val")
  call add(debug_method_code, "}")
  let minified_debug = join(map(debug_method_code, "trim(v:val)"), ";")

  " Save cursor position to restore at the end of the function.
  let save_cursor = getcurpos()

  " 1) Add the debug line to the top of the Ruby file, so it's available in
  "    later code, if we haven't already added it.
  call cursor(1, 1)
  let debug_find_result = search('\V' . minified_debug, 'c')
  if debug_find_result == 0
    call append(1, minified_debug)
    call setpos('.', save_cursor) " Restore cursor position
    execute 'normal j'
    let save_cursor = getcurpos() " Re-save; this is the new 'original', now we've inserted that line.
  else
    call setpos('.', save_cursor) " Restore cursor position
  endif

  " 1) Look for beginning of word \w, get position
  " 2) Look for end of word \w, get position
  " 3) insert at end of word
  " 4) insert at beginning of word

  " eg. abc_foo.bar(123)
  " ... with cursor on 'b', turns into:
  "   dbg!(abc_foo, 'abc_foo')
  "

  ""let b_search = search('\([^0-9A-Za-z_:@]\|^\)', 'bp')
  ""if b_search == 0
  ""  call setpos('.', save_cursor) " Restore cursor position
  ""  echom "Could not find beginning edge of word!"
  ""  return
  ""endif
  ""let [b_line, b_col] = getcurpos()[1:2]
  ""if b_search == 1
  ""  let b_col += 1
  ""endif

  ""let e_search = search('\([^0-9A-Za-z_:@]\|$\)', 'p')
  ""if e_search == 0
  ""  call setpos('.', save_cursor) " Restore cursor position
  ""  echom "Could not find end edge of word!"
  ""  return
  ""endif
  ""let [e_line, e_col] = getcurpos()[1:2]
  ""if e_search == 1
  ""  let e_col -= 1
  ""endif

  ""echo [b_line, b_col, e_line, e_col]
  ""let var_name = strcharpart(getline(b_line), b_col, e_col - b_col)
  ""echo var_name
  ""return

  "execute "normal bidbg(\<Esc> e"
  "call search('\\b')
  "execute "normal wi)\<Esc>"

  execute "normal ?[^0-9A-Za-z_[\\]'\"]\<Enter>adbg(\<Esc>"
  let [b_col] = getcurpos()[2:2]
  execute "normal /[^0-9A-Za-z_[\\]'\"]/e-1\<Enter>"
  let [e_col] = getcurpos()[2:2]
  let var_name = strcharpart(getline('.'), b_col, e_col - b_col)
  let sanitized_var_name = substitute(var_name, "[^0-9A-Za-z_[\]']", "_", "g")
  execute "normal a,\"" . sanitized_var_name . "\")\<Esc>"
  nohlsearch

  " Restore cursor position
  call setpos('.', save_cursor)

  " Move it to the right to compensate for the added 'dbg!('
  execute "normal 5l"

  "let y = substitute(

  " vim doesn't seem to notice file changes applied by a script:
  "let &modified = 1
endfunction

nnoremap <leader>dd :call AddJsDebug()<CR>

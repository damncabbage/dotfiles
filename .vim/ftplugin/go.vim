set listchars=tab:\ \ ,extends:→,precedes:→,nbsp:\◦

autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()

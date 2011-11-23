if !has('python')
    echo "Error: Required vim compiled with +python"
    finish
endif

exec("pyfile ".fnameescape(fnamemodify(expand("<sfile>"), ":h")."/google_closure.py"))

command! -nargs=0 JSInterface exec "python createInterface()"
command! -nargs=0 JSClass exec "python createClass()"
command! -nargs=0 JSCurr exec "python insertCurrent()"

map <C-S-I> :exec "python createInterface()"<CR>
imap <C-S-I> <Esc>:exec "python createInterface()"<CR>i

map <C-C> :exec "python createClass()"<CR>
imap <C-C> <Esc>:exec "python createClass()"<CR>i

map <C-r> :exec "python insertCurrent()"<CR>
imap <C-r> <Esc>:exec "python insertCurrent()"<CR>a

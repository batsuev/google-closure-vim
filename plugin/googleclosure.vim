if !has('python')
    echo "Error: Required vim compiled with +python"
    finish
endif

exec("pyfile ".fnameescape(fnamemodify(expand("<sfile>"), ":h")."/google_closure.py"))

command! -nargs=0 JSInterface exec "python createInterface()"
command! -nargs=0 JSClass exec "python createClass()"
command! -nargs=0 JSCurr exec "python insertCurrent()"

imap <C-r> <Esc>:exec "python insertCurrent()"<CR>a

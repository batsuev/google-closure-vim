if !has('python')
    echo "Error: Required vim compiled with +python"
    finish
endif

exec("pyfile ".fnameescape(fnamemodify(expand("<sfile>"), ":h")."/google_closure.py"))

command! -nargs=0 JSInterface exec "python createInterface()"
command! -nargs=0 JSClass exec "python createClass()"

nmap <C-S-I> :exec "python createInterface()"<CR>
imap <C-S-I> <Esc>:exec "python createInterface()"<CR>i
nmap <C-S-C> :exec "python createClass()"<CR>
imap <C-S-C> <Esc>:exec "python createClass()"<CR>i

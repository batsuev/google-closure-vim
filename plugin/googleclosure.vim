" Requirements:
" 1. g:ProjectSourceBasePath
" 2. g:GoogleClosureBasePath
" E.g. in project .vimrc:
" let g:ProjectSourceBasePath = '/Users/alex/Documents/work/sampleProject/src/'
" let g:GoogleClosureBasePath = 'goog/base.js'

function! GoogleClosure_GetBaseJSPath()
    let currentFolder = expand('%:p:h')
    let currentFolder = substitute(currentFolder, g:ProjectSourceBasePath, '', 'g')
    let pos = match(currentFolder, '/')
    let res = './'
    while pos != -1
        let pos = match(currentFolder, '/', pos+1)
        let res = res.'../'
    endwhile
    return res.g:GoogleClosureBasePath
endfunction

function! GoogleClosure_GetTestFile()
    return expand('%:r').'_test.html'
endfunction

function! GoogleClosure_MakeTest()
    if (expand('%:e') != 'js')
        echo 'Current file is not js file.'
    elseif (filereadable(GoogleClosure_GetTestFile()))
        execute "e ".GoogleClosure_GetTestFile()
        echo 'Test package opened'
    else
        let sourceContent = join(readfile(expand('%')))
        let testContent = join(readfile(expand('<sfile>:p:h').'/test_template.html'),'__SEPARATOR__')
        
        " path to js file for tests
        let testContent = substitute(testContent, '$PACKAGEFILE\$', expand('%:r'), 'g')

        " package name for tests
        let packageName = matchlist(sourceContent,'goog\.provide([\s"'']\+\([^"'']\+\)')[1]
        let testContent = substitute(testContent, '$PACKAGENAME\$', packageName, 'g')
        
        " closure base.js path
        let testContent = substitute(testContent, '$CLOSUREBASE\$', GoogleClosure_GetBaseJSPath(), 'g')
        execute "e ".GoogleClosure_GetTestFile()
        call setline(1,split(testContent, '__SEPARATOR__'))
    endif
endfunction

command! GoogleClosureTestCreateSuite :call GoogleClosure_MakeTest()

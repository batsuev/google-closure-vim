" Requirements:
" 1. g:ProjectSourceBasePath
" 2. g:GoogleClosureBasePath
" 3. g:GoogleClosureBin
" 4. g:GoogleClosureModule
" E.g. in project .vimrc:
" let g:ProjectSourceBasePath = '/Users/alex/Documents/work/sampleProject/src'
" let g:GoogleClosureBasePath = 'goog'
" let g:GoogleClosureModule = 'myModule'
" let g:GoogleClosureBin = '/Users/alex/Documents/tools/closure/bin'

let g:GoogleClosureTestTemplate = ['<!DOCTYPE html>','<html>','<head>','    <title>Google Closure Unit Tests - $PACKAGENAME$</title>','    <script src="$CLOSUREBASE$"></script>','    <script>','        goog.require("$PACKAGENAME$");','        goog.require("goog.testing.asserts");', '        goog.require("goog.testing.jsunit");', '    </script>','</head>','<body>','<script type="text/javascript">', '','</script>','</body>','</html>']

function! GoogleClosure_GetBasePath()
    let currentFolder = expand('%:p:h')
    let currentFolder = substitute(currentFolder, g:ProjectSourceBasePath.'/', '', 'g')
    let pos = match(currentFolder, '/')
    let res = './'
    while pos != -1
        let pos = match(currentFolder, '/', pos+1)
        let res = res.'../'
    endwhile
    return res.g:GoogleClosureBasePath.'/'
endfunction

function! GoogleClosure_CalcDeps()
    let calcDeps = 'python '.g:GoogleClosureBin.'/calcdeps.py'
    let calcDeps = calcDeps.' -p '.g:ProjectSourceBasePath.'/'.g:GoogleClosureBasePath
    let calcDeps = calcDeps.' -p '.g:ProjectSourceBasePath.'/'.g:GoogleClosureModule
    let calcDeps = calcDeps.' -o deps'
    let calcDeps = calcDeps.' --output_file='.g:ProjectSourceBasePath.'/'.g:GoogleClosureBasePath.'/deps.js'
    system(calcDeps)
    echo 'Deps file rebuilt'
endfunction


function! GoogleClosure_GetTestFile()
    return expand('%:r').'_test.html'
endfunction

function! GoogleClosure_MakeTest()
    if (expand('%:e') != 'js')
        echo 'Current file is not js file.'
    elseif (filereadable(GoogleClosure_GetTestFile()))
        execute 'e '.GoogleClosure_GetTestFile()
        echo 'Test package opened'
    else
        let sourceContent = join(readfile(expand('%')))
        let testContent = join(g:GoogleClosureTestTemplate,'__SEPARATOR__')
        
        let packageName = matchlist(sourceContent,'goog\.provide([\s"'']\+\([^"'']\+\)')[1]
        let testContent = substitute(testContent, '$PACKAGENAME\$', packageName, 'g')
        let testContent = substitute(testContent, '$CLOSUREBASE\$', GoogleClosure_GetBasePath().'/base.js', 'g')
        execute 'e '.GoogleClosure_GetTestFile()
        call setline(1,split(testContent, '__SEPARATOR__'))
    endif
endfunction

command! GoogleClosureTestCreateSuite :call GoogleClosure_MakeTest()
command! GoogleClosureCalcDeps :call GoogleClosure_CalcDeps()

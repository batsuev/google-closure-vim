import re
import vim
import os
from string import Template

PROVIDE_RE = re.compile('goog\.provide\s*\(\s*[\'\"]([^\)]+)[\'\"]\s*\)')
PLUGIN_DIR = vim.eval('fnameescape(fnamemodify(expand("<sfile>"), ":h"))')

TMPL_INTERFACE = Template(open(os.path.join(PLUGIN_DIR,"templates/interface.js"), "r").read())
TMPL_CLASS = Template(open(os.path.join(PLUGIN_DIR,"templates/class.js"), "r").read())

def __getPackage():
    package = None
    for line in vim.current.buffer:
        if re.match(PROVIDE_RE, line):
            package = re.search(PROVIDE_RE, line).group(1)
            break

    if not package:
        raise Exception('goog.provide not found')

    return package

def __getCurrentWord():
    return vim.eval("expand('<cword>')")

def __replaceAndAppendCurrentLine(content):
    b = vim.current.buffer
    line = vim.current.window.cursor[0] - 1
    del b[line]
    b.append(content.split("\n"), line)

def createInterface():
    name = "%s.%s" % (__getPackage(), __getCurrentWord())
    if not name:
        raise Exception('You should place cursor on interface name')

    __replaceAndAppendCurrentLine(TMPL_INTERFACE.substitute(name = name))

def createClass():
    name = "%s.%s" % (__getPackage(), __getCurrentWord())
    if not name:
        raise Exception('You should place cursor on class name')

    __replaceAndAppendCurrentLine(TMPL_CLASS.substitute(name = name))

-- Vimtex (LaTeX) setup — vimscript plugin configured via global variables

-- Viewer: sioyek (SyncTeX forward/backward search)
vim.g.vimtex_view_method = 'sioyek'

-- Compiler: latexmk (respects a project .latexmkrc if present)
vim.g.vimtex_compiler_method = 'latexmk'

-- Quickfix: auto-open on errors only, keep warnings out
vim.g.vimtex_quickfix_mode = 1
vim.g.vimtex_quickfix_open_on_warning = 0

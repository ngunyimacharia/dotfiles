vim.cmd([[
  autocmd BufWritePost *.php silent! call PhpCsFixerFixFile()
]])

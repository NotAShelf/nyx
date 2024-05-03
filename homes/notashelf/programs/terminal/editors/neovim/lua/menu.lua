-- disable the "how to disable mouse" message
-- in right click popups
vim.cmd.aunmenu([[PopUp.How-to\ disable\ mouse]])
vim.cmd.aunmenu([[PopUp.-1-]])

vim.cmd.amenu([[PopUp.Inspect <Cmd>Inspect<CR>]])
vim.cmd.amenu([[PopUp.Telescope <Cmd>Telescope<CR>]])
vim.cmd.amenu([[PopUp.Code\ action <Cmd>lua vim.lsp.buf.code_action()<CR>]])
vim.cmd.amenu([[PopUp.LSP\ Hover <Cmd>lua vim.lsp.buf.hover()<CR>]])

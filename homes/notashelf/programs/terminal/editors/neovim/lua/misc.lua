-- disable the "how to disable mouse" message
-- in right click popups
vim.cmd.aunmenu [[PopUp.How-to\ disable\ mouse]]
vim.cmd.aunmenu [[PopUp.-1-]]

local abbreviations = {
	Wq = 'wq',
	WQ = 'wq',
	Wqa = 'wqa',
	W = 'w',
	Q = 'q',
	Qa = 'qa',
	Bd = 'bd',
	E = 'e'
}

-- add more abbreviations
for left, right in pairs(abbreviations) do
	vim.cmd.cnoreabbrev(('%s %s'):format(left, right))
end

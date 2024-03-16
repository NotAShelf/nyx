local options = {
	-- disable the -- STATUS -- line
	showmode = false,

	-- spellchecking
	spell = true,

	-- spell langs
	spelllang = { "en" },
}


-- iterate over the options table and set the options
-- for each key = value pair
for key, value in pairs(options) do
	vim.opt[key] = value
end

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "toggleterm" },
	callback = function()
		vim.opt_local.wrap = false
		vim.opt_local.spell = false
	end,
})

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

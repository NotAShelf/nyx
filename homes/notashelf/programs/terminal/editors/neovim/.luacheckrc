-- vim: ft=lua tw=80

max_comment_line_length = false
codes = true

-- Don't report unused self arguments of methods.
self = false

-- Rerun tests only if their modification time changed.
cache = true

ignore = {
	"212", -- Unused argument
	"631", -- Line is too long
	"121", -- setting read-only global variable 'vim'
	"122", -- setting read-only field of global variable 'vim'
	"542", -- Empty if branch
	"581", -- negation of a relational operator- operator can be flipped (not for tables)
}

globals = {
	"vim.g",
	"vim.b",
	"vim.w",
	"vim.o",
	"vim.bo",
	"vim.wo",
	"vim.go",
	"vim.env"
}

read_globals = {
	"vim",
	"a",
	"assert",
}

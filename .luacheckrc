std = "min"
files["**/neovim/**/*.lua"] = {
	read_globals = {
		vim = {
			fields = {
				api = {
					other_fields = true,
					read_only = true,
				},
				cmd = {
					other_fields = true,
					read_only = true,
				},
				defer_fn = {
					read_only = true,
				},
				diagnostic = {
					other_fields = true,
					read_only = true,
				},
				fn = {
					other_fields = true,
					read_only = true,
				},
				fs = {
					other_fields = true,
					read_only = true,
				},
				g = {
					other_fields = true,
					read_only = false,
				},
				keymap = {
					other_fields = true,
					read_only = true,
				},
				loop = {
					other_fields = true,
					read_only = true,
				},
				lsp = {
					fields = {
						handlers = {
							other_fields = true,
							read_only = false,
						}
					},
					other_fields = true,
					read_only = true,
				},
				notify = {
					read_only = false,
				},
				o = {
					other_fields = true,
					read_only = false,
				},
				opt = {
					other_fields = true,
					read_only = false,
				},
				v = {
					other_fields = true,
					read_only = true,
				},
			},
		},
	},
}

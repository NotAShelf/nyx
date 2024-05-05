local noice = require('noice')
local no_top_text = {
  opts = {
    border = {
      text = { top = '' },
    },
  },
}

-- luacheck: ignore
noice.setup({
  cmdline = {
    format = {
      cmdline = no_top_text,
      filter = no_top_text,
      lua = no_top_text,
      search_down = no_top_text,
      search_up = no_top_text,
    },
  },

  lsp = {
    override = {
      ['cmp.entry.get_documentation'] = true,
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
    },
    progress = {
      enabled = false,
    },
  },

  popupmenu = {
    backend = 'cmp',
  },

  routes = {
    {
      filter = {
        event = 'msg_show',
        kind = 'search_count',
      },
      opts = { skip = true },
    },
    {
      -- skip progress messages from noisy servers
      filter = {
        event = 'lsp',
        kind = 'progress',
        cond = function(message)
          local client = vim.tbl_get(message.opts, 'progress', 'client')
          return client == 'ltex'
        end,
      },
      opts = { skip = true },
    },
  },

  views = {
    cmdline_popup = {
      border = {
        style = 'single',
      },
    },
    confirm = {
      border = {
        style = 'single',
        text = { top = '' },
      },
    },
  },
})

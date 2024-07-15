{
  programs.nvf.settings.vim.maps = {
    normal = {
      # General
      "<leader>fd".action = ":lua vim.g.formatsave = not vim.g.formatsave<CR>";
      "<leader>zt".action = ":<C-U>let g:default_terminal = v:count1<CR>";
      "<leader>e".action = ":NvimTreeToggle<CR>";
      "<leader>ld".action = ":lua vim.diagnostic.setqflist({open = true})<CR>";
      "<leader>lf".action = ":lua vim.lsp.buf.format()<CR>";
      "<leader>li".action = ":lua vim.lsp.buf.implementation()<CR>";

      # Diffview
      "<leader>gdq".action = ":DiffviewClose<CR>";
      "<leader>gdd".action = ":DiffviewOpen ";
      "<leader>gdm".action = ":DiffviewOpen<CR>";
      "<leader>gdh".action = ":DiffviewFileHistory %<CR>";
      "<leader>gde".action = ":DiffviewToggleFiles<CR>";

      # Git
      "<leader>gu".action = "<cmd>Gitsigns undo_stage_hunk<CR>";
      "<leader>g<C-w>".action = "<cmd>Gitsigns preview_hunk<CR>";
      "<leader>gp".action = "<cmd>Gitsigns prev_hunk<CR>";
      "<leader>gn".action = "<cmd>Gitsigns next_hunk<CR>";
      "<leader>gP".action = "<cmd>Gitsigns preview_hunk_inline<CR>";
      "<leader>gR".action = "<cmd>Gitsigns reset_buffer<CR>";
      "<leader>gb".action = "<cmd>Gitsigns blame_line<CR>";
      "<leader>gD".action = "<cmd>Gitsigns diffthis HEAD<CR>";
      "<leader>gw".action = "<cmd>Gitsigns toggle_word_diff<CR>";

      # Telescope
      "<M-f>".action = ":Telescope resume<CR>";
      "<leader>fq".action = ":Telescope quickfix<CR>";
      "<leader>f/".action = ":Telescope live_grep<cr>";

      # Aerial
      "<S-O>".action = ":AerialToggle<CR>";

      # vsnip
      #"<C-jn>".action = "<Plug>(vsnip-jump-next)";
      #"<C-jp>".action = "<Plug>(vsnip-jump-prev)";
    };

    normalVisualOp = {
      "<leader>gs".action = ":Gitsigns stage_hunk<CR>";
      "<leader>gr".action = ":Gitsigns reset_hunk<CR>";
      "<leader>lr".action = "<cmd>lua vim.lsp.buf.references()<CR>";

      # ssr.nvim
      "<leader>sr".action = ":lua require('ssr').open()<CR>";

      # Toggleterm
      "<leader>ct" = {
        # action = ":<C-U>ToggleTermSendVisualLines v:count<CR>";
        action = "':ToggleTermSendVisualLines ' . v:count == 0 ? g:default_terminal : v:count";
        expr = true;
      };
    };
  };
}

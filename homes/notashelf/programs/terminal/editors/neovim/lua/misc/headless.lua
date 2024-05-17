local M = {}
M.load_headless_options = function()
  vim.opt.shortmess = '' -- try to prevent echom from cutting messages off or prompting
  vim.opt.more = false -- don't pause listing when screen is filled
  vim.opt.cmdheight = 9999 -- helps avoiding |hit-enter| prompts.
  vim.opt.columns = 9999 -- set the widest screen possible
  vim.opt.swapfile = false -- don't use a swap file
end

-- Check if we are in headless mode
-- and load the options designated for headless mode
-- if we are.
M.check_headless = function()
  if #vim.api.nvim_list_uis() == 0 then
    M.load_headless_options()
    return
  end
end

return M

local cmd = vim.cmd

-- luacheck: ignore
local abbreviations = {
  Wq = 'wq', -- keep making those typos
  WQ = 'wq',
  Wqa = 'wqa',
  W = 'w',
  Q = 'q',
  Qa = 'qa',
  Bd = 'bd',
  E = 'e',
  q1 = 'q!', -- this is for when I don't want to reach to shift
  qa1 = 'qa!',
  mk = 'mark', -- make marks faster
  st = 'sort', -- sort
}

-- add more abbreviations
for left, right in pairs(abbreviations) do
  cmd.cnoreabbrev(('%s %s'):format(left, right))
end

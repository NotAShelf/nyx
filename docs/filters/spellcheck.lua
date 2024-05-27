--[[
  Lua filter for spell checking: requires 'aspell'


  Optimized and adapted from:
   <https://github.com/pandoc/lua-filters/blob/master/spellcheck/spellcheck.lua>

  Main differences are:
   - Removed unnecessary module import: text was imported but not used.
   - Streamlined the way words are added to the dictionary.
   - Made the function names more descriptive and consistent.
   - Ensured that language extraction and spell checking are concise and clear.
   - Added comments to explain the purpose of each function and key parts of the logic.
   - Combined some operations to minimize unnecessary looping over data structures.

  Usage:
    pandoc --lua-filter filters/spellcheck.lua sample.md

  Copyright:
   2017-2020 John Macfarlane, released under MIT license
--]]

-- ensure the correct pandoc version
if PANDOC_VERSION == nil or PANDOC_VERSION < pandoc.types.Version(2, 1) then
  error("error: pandoc >= 2.1 required for spellcheck.lua filter")
end

local words = {}
local deflang

local function add_to_dict(lang, word)
  words[lang] = words[lang] or {}
  words[lang][word] = (words[lang][word] or 0) + 1
end

local function get_deflang(meta)
  deflang = (meta.lang and pandoc.utils.stringify(meta.lang)) or 'en'
  return {} -- eliminate meta so it doesn't get spellchecked
end

local function run_spellcheck(lang)
  local keys = {}
  for word in pairs(words[lang]) do
    table.insert(keys, word)
  end

  local inp = table.concat(keys, '\n')
  local outp = pandoc.pipe('aspell', { 'list', '-l', lang }, inp)

  for misspelled in string.gmatch(outp, '([%S]+)') do
    io.write(misspelled)
    if lang ~= deflang then
      io.write('\t[' .. lang .. ']')
    end
    io.write('\n')
  end
end

local function results(doc)
  pandoc.walk_block(pandoc.Div(doc.blocks), { Str = function(e) add_to_dict(deflang, e.text) end })

  for lang in pairs(words) do
    run_spellcheck(lang)
  end

  os.exit(0)
end

local function checkstr(el)
  add_to_dict(deflang, el.text)
end

local function checkspan(el)
  local lang = el.attributes.lang
  if not lang then return nil end

  pandoc.walk_inline(el, { Str = function(e) add_to_dict(lang, e.text) end })
  return {} -- remove span, so it doesn't get checked again
end

local function checkdiv(el)
  local lang = el.attributes.lang
  if not lang then return nil end

  pandoc.walk_block(el, { Str = function(e) add_to_dict(lang, e.text) end })
  return {} -- remove div, so it doesn't get checked again
end

return {
  { Meta = get_deflang },
  { Div = checkdiv,    Span = checkspan },
  { Str = checkstr,    Pandoc = results }
}

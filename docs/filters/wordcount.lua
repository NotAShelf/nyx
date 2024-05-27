--[[
  Optimized and adapted from:
   <https://github.com/pandoc/lua-filters/blob/master/wordcount/wordcount.lua>

  Main differences are:
   - Combines similar functions like Code and CodeBlock
   - Utilizes Pandoc’s built-in methods where applicable
   - Perform operations like removing spaces more efficiently

  Usage:
   $ pandoc -s -L filters/wordcount.lua -M wordcount=process notes/cheatsheet.md -o output.html
--]]


local words = 0
local characters = 0
local characters_and_spaces = 0
local process_anyway = false

-- safely get the utf8 length, handling invalid sequences
local function safe_utf8_len(text)
  local success, len = pcall(function() return utf8.len(text) end)
  if success then
    return len
  else
    return 0
  end
end

local wordcount = {
  Str = function(el)
    -- count words only if there is a non-punctuation character
    if el.text:match("%P") then
      words = words + 1
    end
    local len = safe_utf8_len(el.text)
    characters = characters + len
    characters_and_spaces = characters_and_spaces + len
  end,

  Space = function(el)
    characters_and_spaces = characters_and_spaces + 1
  end,

  Code = function(el)
    -- use a single pattern to count non-space sequences
    local _, n = el.text:gsub("%S+", "")
    words = words + n
    local text_nospace = el.text:gsub("%s", "")
    characters = characters + safe_utf8_len(text_nospace)
    characters_and_spaces = characters_and_spaces + safe_utf8_len(el.text)
  end,

  CodeBlock = function(el)
    -- use a single pattern to count non-space sequences
    local _, n = el.text:gsub("%S+", "")
    words = words + n
    local text_nospace = el.text:gsub("%s", "")
    characters = characters + safe_utf8_len(text_nospace)
    characters_and_spaces = characters_and_spaces + safe_utf8_len(el.text)
  end
}

-- check if the `wordcount` variable is set to `process-anyway`
function Meta(meta)
  if meta.wordcount and (meta.wordcount == "process-anyway" or meta.wordcount == "process" or meta.wordcount == "convert") then
    process_anyway = true
  end
end

function Pandoc(el)
  -- skip metadata, just count body:
  pandoc.walk_block(pandoc.Div(el.blocks), wordcount)
  print(words .. " words")
  print(characters .. " characters")
  print(characters_and_spaces .. " characters (including spaces)")
  if not process_anyway then
    os.exit(0)
  end
end

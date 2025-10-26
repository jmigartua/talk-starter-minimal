-- Filter: ::: divider ... ::: -> Header (Reveal slide)
local function has_class(el, cls)
  for _, c in ipairs(el.classes or {}) do if c == cls then return true end end
  return false
end

local function stringify_blocks(blocks)
  if pandoc.utils and pandoc.utils.stringify then
    return pandoc.utils.stringify(blocks or {})
  end
  return "Section"
end

local function read_css()
  local css_path = "_extensions/thermomat-dividers/dividers.css"
  local fh = io.open(css_path, "r")
  if not fh then return nil end
  local content = fh:read("*a")
  fh:close()
  if content == "" then return nil end
  return "<style>" .. content .. "</style>"
end

local function ensure_meta_list(val)
  if val == nil then
    return pandoc.MetaList({})
  end
  if val.t == "MetaList" then
    return val
  end
  return pandoc.MetaList({ val })
end

local colors = {
  red     = "#D7433B",
  salmon  = "#F06A63",
  accent  = "#FF8E5E",
  saffron = "#FFCC3D",
  mint    = "#95CAA6",
  teal    = "#008D98"
}

local function variant_from_classes(classes)
  if not classes then return nil end
  for _, c in ipairs(classes) do
    local v = c:match("^ustwo%-(.+)$")
    if v then return v end
  end
  return nil
end

function Div(el)
  if not has_class(el, 'divider') then return nil end
  local title   = (el.attributes and el.attributes.title) or stringify_blocks(el.content) or 'Section'
  local variant = (el.attributes and el.attributes.variant) or 'saffron'
  local text    = (el.attributes and el.attributes.text) or ''
  local level   = tonumber((el.attributes and el.attributes.level) or '1') or 1

  -- Allow both 'dark'/'light' and explicit 'dark-text'/'light-text' values for text color.
  if text == 'dark-text' then text = 'dark' end
  if text == 'light-text' then text = 'light' end
  local classes = { 'section-divider', 'ustwo-' .. variant }
  if text == 'dark'  then table.insert(classes, 'dark-text')  end
  if text == 'light' then table.insert(classes, 'light-text') end

  local attrs = { ['data-background-color'] = colors[variant] or colors['saffron'] }
  return { pandoc.Header(level, title, pandoc.Attr('', classes, attrs)) }
end

function Header(el)
  if not has_class(el, 'section-divider') then return nil end
  local variant = variant_from_classes(el.classes) or (el.attributes and el.attributes.variant) or 'saffron'
  el.attributes = el.attributes or {}
  if not el.attributes['data-background-color'] then
    el.attributes['data-background-color'] = colors[variant] or colors['saffron']
  end
  return el
end

function Meta(meta)
  local css = read_css()
  if not css then return meta end

  local includes = ensure_meta_list(meta["header-includes"])
  table.insert(includes, pandoc.MetaBlocks({ pandoc.RawBlock("html", css) }))
  meta["header-includes"] = includes
  return meta
end

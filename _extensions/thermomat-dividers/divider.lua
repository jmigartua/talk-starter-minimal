-- Shortcode: {{< divider title="..." variant="..." text="dark|light" >}}
-- Uses manual HTML escaping to support Pandoc 3.x (pandoc.text.escape no longer available).

local function esc_html(s)
  s = tostring(s or "")
  s = s:gsub("&", "&amp;")
  s = s:gsub("<", "&lt;")
  s = s:gsub(">", "&gt;")
  s = s:gsub('"', "&quot;")
  s = s:gsub("'", "&#39;")
  return s
end

return {
  ["divider"] = function(args, kwargs, meta)
    local util = pandoc.utils
    local function S(x)
      if util and util.stringify then return util.stringify(x or "") end
      if x == nil then return "" end
      return tostring(x)
    end
    local title   = S(kwargs["title"]); if title == "" then title = "Section" end
    local variant = S(kwargs["variant"]); if variant == "" then variant = "saffron" end
    local text    = S(kwargs["text"])    -- "" | "dark" | "light" | "dark-text" | "light-text"

    if text == "dark-text" then text = "dark" end
    if text == "light-text" then text = "light" end

    local colors = {
      red     = "#D7433B",
      salmon  = "#F06A63",
      accent  = "#FF8E5E",
      saffron = "#FFCC3D",
      mint    = "#95CAA6",
      teal    = "#008D98"
    }

    local classes = { "section-divider", "ustwo-" .. variant }
    if text == "dark" then
      table.insert(classes, "dark-text")
    elseif text == "light" then
      table.insert(classes, "light-text")
    end

    local attrs = { ["data-background-color"] = colors[variant] or colors["saffron"] }
    return pandoc.Header(1, title, pandoc.Attr("", classes, attrs))
  end
}

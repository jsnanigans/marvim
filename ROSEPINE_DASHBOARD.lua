-- Rosé Pine inspired dashboard header for MARVIM
-- All natural pine, faux fur and a bit of soho vibes for the classy minimalist

return {
  header = {
    "                                                                     ",
    "  ███╗   ███╗ █████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗                ",
    "  ████╗ ████║██╔══██╗██╔══██╗██║   ██║██║████╗ ████║                ",
    "  ██╔████╔██║███████║██████╔╝██║   ██║██║██╔████╔██║                ",
    "  ██║╚██╔╝██║██╔══██║██╔══██╗╚██╗ ██╔╝██║██║╚██╔╝██║                ",
    "  ██║ ╚═╝ ██║██║  ██║██║  ██║ ╚████╔╝ ██║██║ ╚═╝ ██║                ",
    "  ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝                ",
    "                                                                     ",
    "    🌹 All natural pine, faux fur and a bit of soho vibes           ",
    "                                                                     ",
  },
  
  shortcuts = {
    { key = "f", desc = "󰈞  Find Files", action = "Snacks picker files" },
    { key = "r", desc = "󰊄  Recent Files", action = "Snacks picker recent" },
    { key = "g", desc = "󰊢  Find Text", action = "Snacks picker grep" },
    { key = "c", desc = "  Config", action = "edit ~/.config/nvim/init.lua" },
    { key = "l", desc = "󰒲  Lazy", action = "Lazy" },
    { key = "q", desc = "󰗼  Quit", action = "qa" },
  },
  
  footer = function()
    local stats = require("lazy").stats()
    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
    return {
      "                                                                     ",
      "  ⚡ " .. stats.loaded .. "/" .. stats.count .. " plugins loaded in " .. ms .. "ms",
      "                                                                     ",
      "        Even paranoid androids can appreciate good design           ",
      "                          - Marvin                                   ",
      "                                                                     ",
    }
  end,
}
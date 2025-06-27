return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "LazyVim", words = { "LazyVim" } },
        { path = "lazy.nvim", words = { "lazy" } },
        { path = "mini.nvim", words = { "mini" } },
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
      enabled = function(root_dir)
        local lua_indicators = {
          ".luarc.json",
          ".luarc.jsonc",
          "lua",
          "init.lua",
          "lazy-lock.json",
          ".stylua.toml",
          "selene.toml",
        }
        for _, indicator in ipairs(lua_indicators) do
          if vim.uv.fs_stat(root_dir .. "/" .. indicator) then
            return true
          end
        end
        local nvim_config_indicators = {
          "lua/config",
          "lua/plugins",
          "init.lua",
        }
        for _, indicator in ipairs(nvim_config_indicators) do
          if vim.uv.fs_stat(root_dir .. "/" .. indicator) then
            return true
          end
        end
        return false
      end,
    },
    dependencies = {
      { "Bilal2453/luvit-meta", lazy = true },
    },
  },
}

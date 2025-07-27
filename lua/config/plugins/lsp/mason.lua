return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        "google-java-format",
        "json-lsp",
        "prettier",
        "ruff",
        "eslint_d",
        "codelldb",
        "js-debug-adapter",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        require("lazy.core.handler.event").trigger({
          event = "FileType",
          buf = vim.api.nvim_get_current_buf(),
        })
      end)

      -- Defer package installation to avoid blocking startup
      vim.defer_fn(function()
        local function ensure_installed()
          for _, tool in ipairs(opts.ensure_installed) do
            local p = mr.get_package(tool)
            if not p:is_installed() then
              p:install()
            end
          end
        end
        if mr.refresh then
          mr.refresh(ensure_installed)
        else
          ensure_installed()
        end
      end, 100)
    end,
  },
}

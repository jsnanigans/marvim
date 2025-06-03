-- Nvim-lint - Asynchronous linting for better code quality
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- Configure linters by filetype
    lint.linters_by_ft = {
      -- NOTE: JavaScript/TypeScript linting is handled by ESLint LSP server
      -- No need for eslint_d linter as it would create duplicate diagnostics
      python = { "pylint", "flake8" },
      dockerfile = { "hadolint" },
      yaml = { "yamllint" },
      json = { "jsonlint" },
      -- lua linting is conditionally enabled below if luacheck is installed
      bash = { "shellcheck" },
      sh = { "shellcheck" },
      zsh = { "shellcheck" },
    }

    -- Custom linter configurations
    -- NOTE: Removed eslint_d configuration since we use ESLint LSP server

    -- Custom luacheck config for Neovim (only configure if luacheck is installed)
    if vim.fn.executable("luacheck") == 1 then
      lint.linters.luacheck.args = {
        "--globals",
        "vim",
        "--no-color",
        "--codes",
        "--ranges",
        "--formatter",
        "plain",
        "-",
      }
      -- Enable lua linting if luacheck is available
      lint.linters_by_ft.lua = { "luacheck" }
    end

    -- Create autocommand for linting
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        -- Only lint if file is readable and has a valid filetype
        local bufnr = vim.api.nvim_get_current_buf()
        local filetype = vim.bo[bufnr].filetype
        
        -- Skip linting for certain buffer types
        if vim.bo[bufnr].buftype ~= "" then
          return
        end
        
        -- Skip if no linters configured for this filetype
        if not lint.linters_by_ft[filetype] then
          return
        end
        
        lint.try_lint()
      end,
    })

    -- Manual lint command
    vim.api.nvim_create_user_command("Lint", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })

    -- Keymaps
    local keymap = vim.keymap.set
    keymap("n", "<leader>ll", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
} 
-- Debugging support with nvim-dap
return {
  -- Debug Adapter Protocol client
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      -- Installs debug adapters
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mason.nvim",
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
          automatic_installation = true,
          handlers = {},
          ensure_installed = {
            "js-debug-adapter",
            "codelldb",
          },
        },
      },

      -- Better UI for debugging
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        opts = {},
        config = function(_, opts)
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup(opts)

          -- Automatically open/close UI
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open({})
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close({})
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close({})
          end
        end,
      },

      -- Virtual text for debugging
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },

      -- TypeScript/JavaScript specific debug adapter
      {
        "mxsdev/nvim-dap-vscode-js",
        opts = {
          debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
          debugger_cmd = { "js-debug-adapter" },
          adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
        },
      },
    },
    config = function()
      local dap = require("dap")
      local dap_vscode_js = require("dap-vscode-js")

      -- Configure TypeScript/JavaScript debugging
      dap_vscode_js.setup({
        debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
        debugger_cmd = { "js-debug-adapter" },
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
      })

      -- TypeScript/JavaScript configurations
      -- Note: DAP also supports VS Code launch.json files automatically
      -- Place a .vscode/launch.json in your project root to use custom configurations
      for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        dap.configurations[language] = {
          -- Debug single nodejs file
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
          },
          -- Debug nodejs process
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
          },
          -- Debug web app (client-side)
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch Chrome",
            url = function()
              local co = coroutine.running()
              return coroutine.create(function()
                vim.ui.input({
                  prompt = "Enter URL: ",
                  default = "http://localhost:3000",
                }, function(url)
                  if url == nil or url == "" then
                    return
                  else
                    coroutine.resume(co, url)
                  end
                end)
              end)
            end,
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
            protocol = "inspector",
            port = 9222,
            skipFiles = {
              "<node_internals>/**",
              "node_modules/**",
              "**/*.min.js",
            },
          },
          -- Debug jest tests
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Jest Tests",
            -- trace = true, -- include debugger info
            runtimeExecutable = "node",
            runtimeArgs = {
              "./node_modules/jest/bin/jest.js",
              "--runInBand",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
          },
          -- Debug vitest tests
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Vitest Tests",
            program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
            args = { "run", "${file}" },
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
          },
          -- Debug with npm scripts
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch via NPM",
            runtimeExecutable = "npm",
            runtimeArgs = {
              "run-script",
              "dev",
            },
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
          },
        }
      end

      -- Set up breakpoint icons
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "●", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" }
      )
      vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DiagnosticSignInfo", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapStopped",
        { text = "󰁕", texthl = "DiagnosticSignWarn", linehl = "DapStoppedLine", numhl = "" }
      )
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" }
      )

      -- Highlight for stopped line
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
    end,
    keys = function()
      return require("config.keymaps").dap_keys
    end,
  },
}

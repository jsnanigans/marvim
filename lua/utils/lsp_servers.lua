-- Heavy LSP server configurations extracted for lazy loading
-- This reduces initial startup time by deferring complex configurations

local M = {}

-- TypeScript/JavaScript server configuration
M.vtsls = function()
  return {
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
    root_dir = function(fname)
      local util = require("lspconfig.util")
      return util.root_pattern("tsconfig.json", "package.json", ".git")(fname)
    end,
    single_file_support = false,
    settings = {
      complete_function_calls = true,
      vtsls = {
        enableMoveToFileCodeAction = true,
        autoUseWorkspaceTsdk = true,
        experimental = {
          maxInlayHintLength = 30,
          completion = {
            enableServerSideFuzzyMatch = false,
          },
        },
      },
      typescript = {
        updateImportsOnFileMove = { enabled = "always" },
        suggest = {
          completeFunctionCalls = true,
        },
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          parameterNames = { enabled = "literals" },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = false },
        },
        implementationsCodeLens = {
          enabled = true,
        },
        referencesCodeLens = {
          enabled = true,
          showOnAllFunctions = true,
        },
      },
      javascript = {
        updateImportsOnFileMove = { enabled = "always" },
        suggest = {
          completeFunctionCalls = true,
        },
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          parameterNames = { enabled = "literals" },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = false },
        },
        implementationsCodeLens = {
          enabled = true,
        },
        referencesCodeLens = {
          enabled = true,
          showOnAllFunctions = true,
        },
      },
    },
  }
end

-- ESLint server configuration
M.eslint = function()
  return {
    settings = {
      workingDirectories = { mode = "auto" },
      experimental = {
        useFlatConfig = false,
      },
      validate = "on",
      packageManager = "npm",
      useESLintClass = false,
      codeActionOnSave = {
        enable = false,
        mode = "all",
      },
      format = false,
      quiet = false,
      onIgnoredFiles = "off",
      rulesCustomizations = {},
      run = "onType",
      problems = {
        shortenToSingleLine = false,
      },
      nodePath = "",
      enable = true,
    },
  }
end

-- JSON server configuration
M.jsonls = function()
  return {
    on_new_config = function(new_config)
      new_config.settings.json.schemas = new_config.settings.json.schemas or {}
      vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
    end,
    settings = {
      json = {
        format = {
          enable = true,
        },
        validate = { enable = true },
      },
    },
  }
end

-- Lua server configuration
M.lua_ls = function()
  return {
    settings = {
      Lua = {
        workspace = {
          checkThirdParty = false,
        },
        codeLens = {
          enable = true,
        },
        completion = {
          callSnippet = "Replace",
        },
        doc = {
          privateName = { "^_" },
        },
        hint = {
          enable = true,
          setType = false,
          paramType = true,
          paramName = "Disable",
          semicolon = "Disable",
          arrayIndex = "Disable",
        },
      },
    },
  }
end

-- C++ server configuration
M.clangd = function()
  return {
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--header-insertion=iwyu",
      "--completion-style=detailed",
      "--function-arg-placeholders",
      "--fallback-style=llvm",
    },
    init_options = {
      usePlaceholders = true,
      completeUnimported = true,
      clangdFileStatus = true,
    },
    root_dir = function(fname)
      local util = require("lspconfig.util")
      return util.root_pattern(
        ".clangd",
        ".clang-tidy",
        ".clang-format",
        "compile_commands.json",
        "compile_flags.txt",
        "configure.ac",
        ".git"
      )(fname)
    end,
  }
end

-- Python server configuration
M.pyright = function()
  return {
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = true,
          typeCheckingMode = "basic",
        },
      },
    },
  }
end

-- Dart server configuration
M.dartls = function()
  return {
    cmd = { "dart", "language-server", "--protocol=lsp" },
    filetypes = { "dart" },
    mason = false,
    init_options = {
      onlyAnalyzeProjectsWithOpenFiles = true,
      suggestFromUnimportedLibraries = true,
      closingLabels = true,
      outline = true,
      flutterOutline = true,
    },
    root_dir = function(fname)
      local util = require("lspconfig.util")
      return util.root_pattern("pubspec.yaml", ".git")(fname)
    end,
    settings = {
      dart = {
        completeFunctionCalls = true,
        showTodos = true,
      },
    },
  }
end

-- Get server configuration by name
function M.get_server_config(server_name)
  if M[server_name] and type(M[server_name]) == "function" then
    return M[server_name]()
  end
  return {}
end

return M

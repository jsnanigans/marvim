-- Telescope - The ultimate fuzzy finder for power users
return {
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "nvim-tree/nvim-web-devicons" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")

    -- Store the initial workspace root (where nvim was opened)
    local INITIAL_WORKSPACE_ROOT = vim.fn.getcwd()

    -- Helper function to find the nearest package.json directory within initial workspace
    local function find_project_root()
      local current_dir = vim.fn.expand('%:p:h')
      local root_patterns = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' }
      
      -- Start from current file's directory and go up
      local function find_root(path)
        -- Stop if we've reached the initial workspace root's parent
        local initial_parent = vim.fn.fnamemodify(INITIAL_WORKSPACE_ROOT, ':h')
        if path == initial_parent or vim.fn.fnamemodify(path, ':h') == initial_parent then
          return INITIAL_WORKSPACE_ROOT
        end
        
        for _, pattern in ipairs(root_patterns) do
          if vim.fn.filereadable(path .. '/' .. pattern) == 1 or vim.fn.isdirectory(path .. '/' .. pattern) == 1 then
            return path
          end
        end
        
        local parent = vim.fn.fnamemodify(path, ':h')
        if parent == path then
          return INITIAL_WORKSPACE_ROOT -- Return initial workspace root instead of nil
        end
        
        -- Don't go beyond the initial workspace root
        if vim.fn.stridx(path, INITIAL_WORKSPACE_ROOT) ~= 0 then
          return INITIAL_WORKSPACE_ROOT
        end
        
        return find_root(parent)
      end
      
      -- If current dir is outside initial workspace, use initial workspace
      if vim.fn.stridx(current_dir, INITIAL_WORKSPACE_ROOT) ~= 0 then
        return INITIAL_WORKSPACE_ROOT
      end
      
      return find_root(current_dir)
    end

    -- Helper function to get current file's directory
    local function get_current_dir()
      local current_file = vim.fn.expand('%:p')
      if current_file == '' then
        return vim.fn.getcwd()
      end
      return vim.fn.fnamemodify(current_file, ':h')
    end

    -- Helper function to find all package.json locations in workspace (for monorepos)
    local function find_monorepo_packages()
      local packages = {}
      
      -- Use find command to locate all package.json files from initial workspace root
      local cmd = "find " .. INITIAL_WORKSPACE_ROOT .. " -name 'package.json' -not -path '*/node_modules/*' 2>/dev/null"
      local handle = io.popen(cmd)
      
      if handle then
        for line in handle:lines() do
          local dir = vim.fn.fnamemodify(line, ':h')
          table.insert(packages, {
            path = dir,
            name = vim.fn.fnamemodify(dir, ':t'),
            relative = vim.fn.fnamemodify(dir, ':~:.'),
          })
        end
        handle:close()
      end
      
      return packages
    end

    -- Custom telescope functions for different scopes
    local function telescope_current_dir_files()
      local current_dir = get_current_dir()
      builtin.find_files({
        prompt_title = "Find Files in Current Dir (" .. vim.fn.fnamemodify(current_dir, ':t') .. ")",
        cwd = current_dir,
        find_command = { "fd", "--type", "f", "--hidden", "--follow", "--exclude", "node_modules", "--exclude", ".git" }
      })
    end

    local function telescope_current_dir_grep()
      local current_dir = get_current_dir()
      builtin.live_grep({
        prompt_title = "Live Grep in Current Dir (" .. vim.fn.fnamemodify(current_dir, ':t') .. ")",
        cwd = current_dir,
      })
    end

    local function telescope_current_dir_grep_string()
      local current_dir = get_current_dir()
      builtin.grep_string({
        prompt_title = "Grep String in Current Dir (" .. vim.fn.fnamemodify(current_dir, ':t') .. ")",
        cwd = current_dir,
      })
    end

    local function telescope_project_files()
      local project_root = find_project_root()
      builtin.find_files({
        prompt_title = "Find Files in Project (" .. vim.fn.fnamemodify(project_root, ':t') .. ")",
        cwd = project_root,
        find_command = { "fd", "--type", "f", "--hidden", "--follow", "--exclude", "node_modules", "--exclude", ".git" }
      })
    end

    local function telescope_project_grep()
      local project_root = find_project_root()
      builtin.live_grep({
        prompt_title = "Live Grep in Project (" .. vim.fn.fnamemodify(project_root, ':t') .. ")",
        cwd = project_root,
      })
    end

    -- Functions for workspace root (where nvim was opened)
    local function telescope_workspace_files()
      builtin.find_files({
        prompt_title = "Find Files in Workspace Root (" .. vim.fn.fnamemodify(INITIAL_WORKSPACE_ROOT, ':t') .. ")",
        cwd = INITIAL_WORKSPACE_ROOT,
        find_command = { "fd", "--type", "f", "--hidden", "--follow", "--exclude", "node_modules", "--exclude", ".git" }
      })
    end

    local function telescope_workspace_grep()
      builtin.live_grep({
        prompt_title = "Live Grep in Workspace Root (" .. vim.fn.fnamemodify(INITIAL_WORKSPACE_ROOT, ':t') .. ")",
        cwd = INITIAL_WORKSPACE_ROOT,
      })
    end

    local function telescope_monorepo_picker()
      local packages = find_monorepo_packages()
      
      if #packages == 0 then
        vim.notify("No packages found in monorepo", vim.log.levels.WARN)
        return
      end
      
      -- If only one package, go directly to it
      if #packages == 1 then
        telescope_project_files()
        return
      end
      
      -- Multiple packages - show picker
      require("telescope.pickers").new({}, {
        prompt_title = "Select Package",
        finder = require("telescope.finders").new_table({
          results = packages,
          entry_maker = function(entry)
            return {
              value = entry,
              display = entry.name .. " (" .. entry.relative .. ")",
              ordinal = entry.name .. " " .. entry.relative,
            }
          end,
        }),
        sorter = require("telescope.config").values.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = require("telescope.actions.state").get_selected_entry()
            builtin.find_files({
              prompt_title = "Find Files in " .. selection.value.name,
              cwd = selection.value.path,
            })
          end)
          
          map("i", "<C-g>", function()
            actions.close(prompt_bufnr)
            local selection = require("telescope.actions.state").get_selected_entry()
            builtin.live_grep({
              prompt_title = "Live Grep in " .. selection.value.name,
              cwd = selection.value.path,
            })
          end)
          
          return true
        end,
      }):find()
    end

    telescope.setup({
      defaults = {
        path_display = { "truncate" },
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        file_ignore_patterns = {
          "^.git/",
          "node_modules",
          "%.lock",
          "__pycache__",
          "%.sqlite3",
          "%.ipynb",
          "vendor/*",
          "%.jpg",
          "%.jpeg",
          "%.png",
          "%.svg",
          "%.otf",
          "%.ttf",
        },
        vimgrep_arguments = {
          "rg",
          "-L",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        },
        prompt_prefix = "   ",
        selection_caret = "  ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        color_devicons = true,
        use_less = true,
        set_env = { ["COLORTERM"] = "truecolor" },
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
        mappings = {
          i = {
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-c>"] = actions.close,
            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-l>"] = actions.complete_tag,
            ["<C-_>"] = actions.which_key,
            ["<c-s>"] = function(prompt_bufnr)
              require("flash").jump({
                pattern = "^",
                label = { after = { 0, 0 } },
                search = {
                  mode = "search",
                  exclude = {
                    function(win)
                      return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
                    end,
                  },
                },
                action = function(match)
                  local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                  picker:set_selection(match.pos[1] - 1)
                end,
              })
            end,
          },
          n = {
            ["<esc>"] = actions.close,
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["H"] = actions.move_to_top,
            ["M"] = actions.move_to_middle,
            ["L"] = actions.move_to_bottom,
            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,
            ["?"] = actions.which_key,
            ["s"] = function(prompt_bufnr)
              require("flash").jump({
                pattern = "^",
                label = { after = { 0, 0 } },
                search = {
                  mode = "search",
                  exclude = {
                    function(win)
                      return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
                    end,
                  },
                },
                action = function(match)
                  local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                  picker:set_selection(match.pos[1] - 1)
                end,
              })
            end,
          },
        },
      },
      pickers = {
        find_files = {
          file_ignore_patterns = { "node_modules", ".git", ".venv" },
          hidden = true,
        },
        -- LSP pickers configuration to handle duplicates
        lsp_references = {
          show_line = false,
          trim_text = true,
          include_declaration = false,
          -- Optionally filter duplicates
          fname_width = 50,
        },
        lsp_definitions = {
          show_line = false,
          trim_text = true,
          fname_width = 50,
        },
        lsp_implementations = {
          show_line = false,
          trim_text = true,
          fname_width = 50,
        },
        lsp_type_definitions = {
          show_line = false,
          trim_text = true,
          fname_width = 50,
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })

    -- Enable extensions
    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")

    -- Keymaps - Enhanced with monorepo support
    local keymap = vim.keymap.set

    -- === FILE SEARCH COMMANDS ===
    -- Project scope (nearest package.json/git root) - most common use case
    keymap("n", "<leader>ff", telescope_project_files, { desc = "Find files in project" })
    keymap("n", "<leader>fr", builtin.oldfiles, { desc = "Find recent files" })
    
    -- Current directory scope (where current file is located)
    keymap("n", "<leader>fd", telescope_current_dir_files, { desc = "Find files in current dir" })
    
    -- Workspace scope (where nvim was opened)
    keymap("n", "<leader>fw", telescope_workspace_files, { desc = "Find files in workspace root" })
    
    -- Monorepo scope (select package first)
    keymap("n", "<leader>fm", telescope_monorepo_picker, { desc = "Find files in monorepo package" })

    -- === STRING SEARCH COMMANDS ===
    -- Project scope (nearest package.json/git root) - most common use case
    keymap("n", "<leader>fs", telescope_project_grep, { desc = "Find string in project" })
    keymap("n", "<leader>fc", function()
      local project_root = find_project_root()
      builtin.grep_string({
        prompt_title = "Grep String in Project (" .. vim.fn.fnamemodify(project_root, ':t') .. ")",
        cwd = project_root,
      })
    end, { desc = "Find string under cursor in project" })
    
    -- Current directory scope
    keymap("n", "<leader>fS", telescope_current_dir_grep, { desc = "Find string in current dir" })
    keymap("n", "<leader>fC", telescope_current_dir_grep_string, { desc = "Find string under cursor in current dir" })
    
    -- Workspace scope (where nvim was opened)
    keymap("n", "<leader>fW", telescope_workspace_grep, { desc = "Find string in workspace root" })
    
    -- Monorepo scope (select package first)
    keymap("n", "<leader>fM", function()
      local packages = find_monorepo_packages()
      if #packages == 0 then
        vim.notify("No packages found in monorepo", vim.log.levels.WARN)
        return
      end
      
      require("telescope.pickers").new({}, {
        prompt_title = "Select Package for Grep",
        finder = require("telescope.finders").new_table({
          results = packages,
          entry_maker = function(entry)
            return {
              value = entry,
              display = entry.name .. " (" .. entry.relative .. ")",
              ordinal = entry.name .. " " .. entry.relative,
            }
          end,
        }),
        sorter = require("telescope.config").values.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = require("telescope.actions.state").get_selected_entry()
            builtin.live_grep({
              prompt_title = "Live Grep in " .. selection.value.name,
              cwd = selection.value.path,
            })
          end)
          return true
        end,
      }):find()
    end, { desc = "Find string in monorepo package" })

    -- === OTHER FIND COMMANDS ===
    keymap("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
    keymap("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
    keymap("n", "<leader>fh", builtin.help_tags, { desc = "Find help" })
    keymap("n", "<leader>fk", builtin.keymaps, { desc = "Find keymaps" })
    keymap("n", "<leader>fq", builtin.commands, { desc = "Find commands" })
    keymap("n", "<leader>f:", builtin.command_history, { desc = "Find command history" })
    keymap("n", "<leader>f/", builtin.search_history, { desc = "Find search history" })

    keymap("n", "<leader>gc", builtin.git_commits, { desc = "Find git commits" })
    keymap("n", "<leader>gfc", builtin.git_bcommits, { desc = "Find git commits for current buffer" })
    keymap("n", "<leader>gb", builtin.git_branches, { desc = "Find git branches" })
    keymap("n", "<leader>gst", builtin.git_status, { desc = "Find git status (telescope)" })

    keymap("n", "<leader>lds", builtin.lsp_document_symbols, { desc = "Find document symbols" })
    keymap("n", "<leader>lws", builtin.lsp_dynamic_workspace_symbols, { desc = "Find workspace symbols" })
    keymap("n", "<leader>lr", builtin.lsp_references, { desc = "Find references" })
    -- LSP telescope functions - using 'lf' prefix to avoid conflicts with main LSP commands
    keymap("n", "<leader>lfi", builtin.lsp_implementations, { desc = "Find implementations" })
    keymap("n", "<leader>lfd", builtin.lsp_definitions, { desc = "Find definitions" })
    keymap("n", "<leader>lft", builtin.lsp_type_definitions, { desc = "Find type definitions" })
  end,
} 
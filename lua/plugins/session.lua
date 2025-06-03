-- Session management for project persistence
return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {
    dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
    options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
    pre_save = nil,
    save_empty = false,
    branch = false, -- Don't use git branch, use directory-based sessions
  },
  config = function(_, opts)
    local persistence = require("persistence")
    persistence.setup(opts)
    
    -- Create autocmd group for session management
    local session_group = vim.api.nvim_create_augroup("SessionManagement", { clear = true })
    
    -- Track the initial working directory to ensure we don't overwrite sessions
    local initial_cwd = vim.fn.getcwd()
    
    -- Flag to prevent saving too early (give time for session to load)
    local session_ready = false
    
    -- Mark session as ready after a delay to prevent immediate overwrites
    vim.defer_fn(function()
      session_ready = true
    end, 1000) -- Wait 1 second before allowing saves
    
    -- Auto-save session on exit
    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = session_group,
      callback = function()
        -- Only save if we're still in the same directory and session is ready
        if vim.fn.getcwd() == initial_cwd and session_ready then
          persistence.save()
        end
      end,
      desc = "Save session on exit for current directory",
    })
    
    -- Auto-save session periodically (every 5 minutes instead of on every buffer write)
    local timer = vim.loop.new_timer()
    timer:start(300000, 300000, vim.schedule_wrap(function()
      -- Only save if we're still in the same directory and session is ready
      if vim.fn.getcwd() == initial_cwd and session_ready then
        persistence.save()
      end
    end))
    
    -- Clean up timer on exit
    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = session_group,
      callback = function()
        timer:stop()
        timer:close()
      end,
      desc = "Clean up session timer",
    })
    
    -- Update initial_cwd when directory changes
    vim.api.nvim_create_autocmd("DirChanged", {
      group = session_group,
      callback = function()
        -- When directory changes, update the initial_cwd to prevent saving to wrong session
        initial_cwd = vim.fn.getcwd()
        vim.notify("Session context changed to: " .. initial_cwd, vim.log.levels.INFO)
      end,
      desc = "Update session context on directory change",
    })
    
    -- Auto-load session for the current directory on startup
    vim.api.nvim_create_autocmd("VimEnter", {
      group = session_group,
      nested = true,
      callback = function()
        -- Only auto-load if no files were specified
        if vim.fn.argc() == 0 then
          -- Check if a session exists for the current directory
          local session_file = persistence.current()
          if session_file and vim.fn.filereadable(session_file) == 1 then
            persistence.load()
            vim.notify("Session loaded for: " .. vim.fn.getcwd(), vim.log.levels.INFO)
          end
        end
      end,
      desc = "Auto-load session on startup",
    })
  end,
  keys = {
    {
      "<leader>ps",
      function() require("persistence").load() end,
      desc = "Restore Session for Current Directory",
    },
    {
      "<leader>pl",
      function() require("persistence").load({ last = true }) end,
      desc = "Restore Last Session",
    },
    {
      "<leader>pd",
      function() require("persistence").stop() end,
      desc = "Stop Session Recording",
    },
    {
      "<leader>pS",
      function() require("persistence").save() end,
      desc = "Save Current Session",
    },
    {
      "<leader>pc",
      function() 
        local session_file = require("persistence").current()
        if session_file and vim.fn.filereadable(session_file) == 1 then
          vim.fn.delete(session_file)
          vim.notify("Session deleted for " .. vim.fn.getcwd(), vim.log.levels.INFO)
        else
          vim.notify("No session found for " .. vim.fn.getcwd(), vim.log.levels.WARN)
        end
      end,
      desc = "Clear Session for Current Directory",
    },
  },
}
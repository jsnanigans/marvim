-- Custom command aliases and utilities
local M = {}

function M.setup()
  -- Create command aliases for common typos
  vim.api.nvim_create_user_command('Q', 'q', { bang = true })
  vim.api.nvim_create_user_command('Qa', 'qa', { bang = true })
  vim.api.nvim_create_user_command('QA', 'qa', { bang = true })
  
  -- Also add :W for :w since it's another common typo
  vim.api.nvim_create_user_command('W', 'w', { bang = true })
  vim.api.nvim_create_user_command('Wa', 'wa', { bang = true })
  vim.api.nvim_create_user_command('WA', 'wa', { bang = true })
  
  -- :Wq and :WQ for :wq
  vim.api.nvim_create_user_command('Wq', 'wq', { bang = true })
  vim.api.nvim_create_user_command('WQ', 'wq', { bang = true })
  vim.api.nvim_create_user_command('Wqa', 'wqa', { bang = true })
  vim.api.nvim_create_user_command('WQa', 'wqa', { bang = true })
  vim.api.nvim_create_user_command('WQA', 'wqa', { bang = true })
end

return M
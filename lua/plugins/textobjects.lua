-- Mini.ai - Enhanced text objects for better navigation and editing
return {
  "echasnovski/mini.ai",
  version = "*",
  event = "VeryLazy",
  config = function()
    local mini_ai = require("mini.ai")
    
    mini_ai.setup({
      -- Table with textobject id as fields, textobject specification as values.
      -- Also use this to disable builtin textobjects. See |MiniAi.config|.
      custom_textobjects = {
        -- Enhanced function textobjects
        F = mini_ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
        
        -- Class textobjects  
        C = mini_ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
        
        -- Conditional textobjects (if/else)
        o = mini_ai.gen_spec.treesitter({
          a = { "@conditional.outer", "@loop.outer" },
          i = { "@conditional.inner", "@loop.inner" },
        }),
        
        -- Comment textobjects
        c = mini_ai.gen_spec.treesitter({ a = "@comment.outer", i = "@comment.inner" }),
        
        -- Parameter/argument textobjects
        a = mini_ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
        
        -- Assignment textobjects
        A = mini_ai.gen_spec.treesitter({ a = "@assignment.outer", i = "@assignment.inner" }),
        
        -- Call textobjects (function calls)
        v = mini_ai.gen_spec.treesitter({ a = "@call.outer", i = "@call.inner" }),
        
        -- Return statement textobjects
        R = mini_ai.gen_spec.treesitter({ a = "@return.outer", i = "@return.inner" }),
        
        -- Number textobjects
        n = mini_ai.gen_spec.treesitter({ a = "@number", i = "@number" }),
        
        -- String content (inside quotes)
        S = mini_ai.gen_spec.treesitter({ a = "@string.outer", i = "@string.inner" }),
        
        -- Type textobjects
        T = mini_ai.gen_spec.treesitter({ a = "@type.outer", i = "@type.inner" }),
        
        -- Block textobjects
        B = mini_ai.gen_spec.treesitter({ a = "@block.outer", i = "@block.inner" }),
        
        -- Entire buffer
        g = function()
          local from = { line = 1, col = 1 }
          local to = {
            line = vim.fn.line("$"),
            col = math.max(vim.fn.getline("$"):len(), 1)
          }
          return { from = from, to = to }
        end,
        
        -- Line textobject (enhanced)
        l = function()
          local line_num = vim.fn.line(".")
          local line = vim.fn.getline(line_num)
          local from = { line = line_num, col = 1 }
          local to = { line = line_num, col = line:len() }
          return { from = from, to = to }
        end,
        
        -- Indent textobject
        i = function()
          local line_num = vim.fn.line(".")
          local indent = vim.fn.indent(line_num)
          local start_line = line_num
          local end_line = line_num
          
          -- Find start of block
          for i = line_num - 1, 1, -1 do
            local line_indent = vim.fn.indent(i)
            local line_content = vim.fn.getline(i):gsub("^%s*", "")
            if line_content == "" then
              goto continue
            end
            if line_indent < indent then
              break
            end
            start_line = i
            ::continue::
          end
          
          -- Find end of block
          for i = line_num + 1, vim.fn.line("$") do
            local line_indent = vim.fn.indent(i)
            local line_content = vim.fn.getline(i):gsub("^%s*", "")
            if line_content == "" then
              goto continue
            end
            if line_indent < indent then
              break
            end
            end_line = i
            ::continue::
          end
          
          local from = { line = start_line, col = 1 }
          local to = { line = end_line, col = vim.fn.getline(end_line):len() }
          return { from = from, to = to }
        end,
      },
      
      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        -- Main textobject prefixes
        around = 'a',
        inside = 'i',
        
        -- Next/last variants
        around_next = 'an',
        inside_next = 'in',
        around_last = 'al',
        inside_last = 'il',
        
        -- Move cursor to corresponding edge of `a` textobject
        goto_left = 'g[',
        goto_right = 'g]',
      },
      
      -- Number of lines within which textobject is searched
      n_lines = 500,
      
      -- How to search for object (first inside current line, then inside
      -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
      -- 'cover_or_nearest', 'next', 'previous', 'nearest'.
      search_method = 'cover_or_next',
      
      -- Whether to disable showing non-error feedback
      silent = false,
    })
  end,
} 
return {
  'rcarriga/nvim-dap-ui',
  dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
  config = function()
    local dap, dapui = require 'dap', require 'dapui'

    -- One layout per view, all on the RIGHT, full height
    dapui.setup {
      layouts = {
        { elements = { { id = 'scopes', size = 1.0 } }, size = 0.33, position = 'right' }, -- 1
        { elements = { { id = 'breakpoints', size = 1.0 } }, size = 0.33, position = 'right' }, -- 2
        { elements = { { id = 'stacks', size = 1.0 } }, size = 0.33, position = 'right' }, -- 3
        { elements = { { id = 'watches', size = 1.0 } }, size = 0.33, position = 'right' }, -- 4
        { elements = { { id = 'repl', size = 1.0 } }, size = 0.33, position = 'right' }, -- 5
        { elements = { { id = 'console', size = 1.0 } }, size = 0.33, position = 'right' }, -- 6
        {
          elements = { { id = 'watches', size = 0.66 }, { id = 'repl', size = 0.34 } },
          size = 0.33,
          position = 'right',
        }, -- 7: Watches+REPL
      },
      controls = { enabled = false },
      floating = { border = 'rounded' },
      expand_lines = true,
    }

    -- ----- Single-panel switcher -----
    local L = { scopes = 1, breakpoints = 2, stacks = 3, watches = 4, repl = 5, console = 6, watches_repl = 7 }
    local current -- currently open layout index, or nil

    local function close_all()
      for idx = 1, 7 do
        pcall(dapui.close, { layout = idx })
      end
    end

    local function toggle_layout(idx)
      if current == idx then
        pcall(dapui.close, { layout = idx })
        current = nil
      else
        close_all()
        pcall(dapui.open, { layout = idx })
        current = idx
      end
    end

    -- NEW: refresh current panel (or Watches if none) to update views
    local function refresh_panel()
      local idx = current or L.watches
      pcall(dapui.close, { layout = idx })
      -- tiny defer to let UI settle before reopening
      vim.defer_fn(function()
        pcall(dapui.open, { layout = idx })
      end, 10)
    end

    -- Keymaps: swap between panels (press again to hide)
    local map = vim.keymap.set
    map('n', '<leader>Ds', function()
      toggle_layout(L.scopes)
    end, { desc = 'Scopes' })
    map('n', '<leader>Db', function()
      toggle_layout(L.breakpoints)
    end, { desc = 'Breakpoints' })
    map('n', '<leader>Dt', function()
      toggle_layout(L.stacks)
    end, { desc = 'Stacks' })
    map('n', '<leader>Dw', function()
      toggle_layout(L.watches)
    end, { desc = 'Watches' })
    map('n', '<leader>Dr', function()
      toggle_layout(L.repl)
    end, { desc = 'REPL' })
    map('n', '<leader>Dc', function()
      toggle_layout(L.console)
    end, { desc = 'Console' })
    map('n', '<leader>Dd', function()
      toggle_layout(L.watches_repl)
    end, { desc = 'Watches+REPL (66/33)' })
    map('n', '<leader>Dx', function()
      close_all()
      current = nil
    end, { desc = 'Close all' })

    local function dapui_add_watch()
      local expr = vim.fn.input 'Add to watch: '
      if vim.fn.empty(expr) ~= 0 then
        return
      end
      dapui.elements.watches.add(expr)
    end

    local function dapui_prompt_eval()
      local expr = vim.fn.input 'Expression: '
      if vim.fn.empty(expr) ~= 0 then
        return
      end
      dapui.eval(expr, {})
    end

    -- Eval current line, ignoring "foo =" at the start if present
    local function dapui_eval_line()
      local line = vim.api.nvim_get_current_line()
      line = line:gsub('^%s*[%w_]+%s*=%s*', '')
      if vim.fn.empty(line) ~= 0 then
        return
      end
      dapui.eval(line, {})
    end

    local function dapui_execute_line()
      local line = vim.api.nvim_get_current_line()
      if vim.fn.empty(line) ~= 0 then
        return
      end
      dap.repl.execute(line)
      refresh_panel()
    end

    -- Visual selection → execute directly in REPL
    local function dapui_execute_visual()
      local bufnr = 0
      local srow, scol = unpack(vim.api.nvim_buf_get_mark(bufnr, '<'))
      local erow, ecol = unpack(vim.api.nvim_buf_get_mark(bufnr, '>'))
      srow, scol, erow, ecol = srow - 1, scol, erow - 1, ecol + 1
      local lines = vim.api.nvim_buf_get_text(bufnr, srow, scol, erow, ecol, {})
      local text = table.concat(lines, '\n')
      if vim.fn.empty(text) ~= 0 then
        return
      end
      dap.repl.execute(text)
      refresh_panel()
    end

    map('n', '<leader>ee', dapui_prompt_eval, { desc = 'Evaluate expression', silent = true })
    map('n', '<leader>el', dapui_eval_line, { desc = 'Current line (no declaration)', silent = true })
    map('n', '<leader>eL', dapui_execute_line, { desc = 'Current line', silent = true })
    map('n', '<leader>er', dapui.eval, { desc = 'Regular', silent = true })
    map('n', '<leader>dw', dapui_add_watch, { desc = 'Add Watch', silent = true })
    map('v', '<leader>e', dapui.eval, { desc = 'Evaluate Selection', silent = true })
    map('v', '<leader>E', dapui_execute_visual, { desc = 'Execute Selection', silent = true })
  end,
}

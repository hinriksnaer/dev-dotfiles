return {
  'mfussenegger/nvim-dap',
  config = function()
    local dap = require 'dap'
    local py = vim.fn.exepath 'python' or vim.fn.exepath 'python3' or 'python'

    dap.adapters.python = {
      type = 'executable',
      command = py,
      args = { '-m', 'debugpy.adapter' },
    }

    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Current File Test',
        program = '${file}',
        justMyCode = false,
        pythonPath = function()
          return py
        end,
        --redirectOutput = true, -- capture stdout/stderr in the console
        --showReturnValue = true,
      },
    }

    -- Usual controls
    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>ds', dap.continue, { desc = 'Start/Continue' })
    vim.keymap.set('n', '<leader>dn', dap.step_over, { desc = 'Step Next' })
    vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Step Into' })
    vim.keymap.set('n', '<leader>du', dap.step_out, { desc = 'Step Out' })
    vim.keymap.set('n', '<leader>dR', dap.repl.open, { desc = 'REPL' })
    vim.keymap.set('n', '<leader>dc', dap.run_to_cursor, { desc = 'Run to Cursor' })
    vim.keymap.set('n', '<leader>dS', dap.terminate, { desc = 'Stop' })
  end,
}

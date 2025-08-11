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
        console = 'integratedTerminal',
        justMyCode = false,
        pythonPath = function()
          return py
        end,
        redirectOutput = true, -- capture stdout/stderr in the console
        showReturnValue = true,
      },
    }
  end,
}

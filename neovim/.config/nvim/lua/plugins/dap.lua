return {
  'mfussenegger/nvim-dap',
  config = function()
    local dap = require 'dap'
    local mason_bin = vim.fn.stdpath 'data' .. '/mason/bin'
    local function which(bin)
      local p = vim.fn.exepath(bin)
      return (p ~= '' and p) or nil
    end
    local py = which 'python3' or which 'python' or 'python'
    local gdb = which 'gdb' or 'gdb'

    dap.adapters.python = {
      type = 'executable',
      command = py,
      args = { '-m', 'debugpy.adapter' },
    }

    dap.adapters.cppdbg = {
      id = 'cppdbg',
      type = 'executable',
      command = mason_bin .. '/OpenDebugAD7',
    }

    -- Remember the last Python PID (from debugpy)
    local last_pid = { python = nil }

    -- Capture PID when a session reports its process
    dap.listeners.after.event_process['capture-python-pid'] = function(session, body)
      -- `body.systemProcessId` is the OS PID
      if session.config and session.config.type == 'python' and body and body.systemProcessId then
        last_pid.python = body.systemProcessId
        vim.notify(('debugpy PID: %d'):format(last_pid.python), vim.log.levels.INFO)
      end
    end

    -- Clear it when that Python session ends
    dap.listeners.after.event_terminated['clear-python-pid'] = function(session)
      if session.config and session.config.type == 'python' then
        last_pid.python = nil
      end
    end

    -- 1) Start Python (debugpy) normally — stores PID automatically
    vim.keymap.set('n', '<leader>dpy', function()
      dap.run {
        type = 'python',
        request = 'launch',
        name = 'Python: current file',
        program = '${file}',
        console = 'internalConsole',
        -- optional: track subprocesses too
        subProcess = true,
      }
    end, { desc = 'Debug (Python / debugpy)' })

    -- 2) Start/Attach C++ (GDB) to the remembered Python PID
    vim.keymap.set('n', '<leader>dpp', function()
      if not last_pid.python then
        vim.notify('No Python PID captured yet. Start a Python debug session first.', vim.log.levels.WARN)
        return
      end
      dap.run {
        type = 'cppdbg',
        request = 'attach',
        name = 'GDB → attach to Python',
        processId = last_pid.python, -- <- auto-uses the correct PID
        MIMode = 'gdb',
        miDebuggerPath = gdb,
        program = py,
        setupCommands = {
          { text = 'set breakpoint pending on' },
          { text = '-enable-pretty-printing' },
          { text = 'set stop-on-solib-events 1' },
          { text = 'set solib-search-path /workspaces/tmp-torch-container/pytorch/build/lib' },
        },
      }
    end, { desc = 'Attach GDB to last Python PID' })

    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>ds', dap.continue, { desc = 'Continue' })
    vim.keymap.set('n', '<leader>dn', dap.step_over, { desc = 'Step Next' })
    vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Step Into' })
    vim.keymap.set('n', '<leader>du', dap.step_out, { desc = 'Step Out' })
    vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = 'REPL' })
    vim.keymap.set('n', '<leader>dc', dap.run_to_cursor, { desc = 'Run to Cursor' })
    vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = 'Terminate' })
  end,
}

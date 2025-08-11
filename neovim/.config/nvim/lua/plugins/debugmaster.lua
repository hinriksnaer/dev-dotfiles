return {
  {
    'miroshQa/debugmaster.nvim',
    -- osv is needed if you want to debug neovim lua code. Also can be used
    -- as a way to quickly test-drive the plugin without configuring debug adapters
    dependencies = { 'mfussenegger/nvim-dap', 'jbyuki/one-small-step-for-vimkind' },
    config = function()
      local dm = require 'debugmaster'
      -- make sure you don't have any other keymaps that starts with "<leader>d" to avoid delay
      -- Alternative keybindings to "<leader>d" could be: "<leader>m", "<leader>;"
      vim.keymap.set({ 'n', 'v' }, '<leader>dm', dm.mode.toggle, { nowait = true, desc = 'Debug Mode' })

      dm.plugins.osv_integration.enabled = true -- needed if you want to debug neovim lua code
    end,
  },
}

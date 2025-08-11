return {
  'kdheepak/lazygit.nvim',
  lazy = true,
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'folke/which-key.nvim',
  },

  -- runs at startup (before plugin loads)
  init = function()
    local ok, wk = pcall(require, 'which-key')
    if ok then
      wk.add { { '<leader>g', group = ' git' } }
    end
  end,

  -- let lazy.nvim create a lazy-loaded keymap
  keys = {
    { '<leader>gg', '<cmd>LazyGit<cr>', desc = ' LazyGit' },
  },
}

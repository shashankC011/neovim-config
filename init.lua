require("config.lazy")

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.keymap.set('n', '<leader><Tab>', ':Ex<CR>', { desc = 'Open file explorer' })
vim.opt.number = true
-- or for relative numbers
vim.opt.relativenumber = true
-- highlight current line 
vim.opt.cursorline = true

--scroll Offset
vim.opt.scrolloff = 12
vim.opt.sidescrolloff = 8  
vim.opt.smoothscroll = true

-- Enable system clipboard integration
vim.opt.clipboard = "unnamedplus"

--Clear highlight
vim.keymap.set('n', '<leader><Esc>', ':nohlsearch<CR>', { silent = true })


--Use Tab and Shift-Tab for indenting in visual mode and stay in it
vim.keymap.set('v', '<Tab>', '>gv', { desc = 'Indent right with Tab' })
vim.keymap.set('v', '<S-Tab>', '<gv', { desc = 'Indent left with Shift-Tab' })

require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>d', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
--Find directories
vim.keymap.set('n', '<leader>fd', function()
  builtin.find_files({
    find_command = { 'find', '.', '-type', 'd' }
  })
end, { desc = 'Find directories' })

local configs = require("nvim-treesitter.configs")
configs.setup({
  ensure_installed = { "c", "lua", "javascript", "html","go","typescript" },
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true },  
})

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = true, -- neo-tree will only load when needed
    cmd = "Neotree", -- Load when :Neotree command is used
    keys = {
      { "<C-t>", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-tree" },
    },
  }
}

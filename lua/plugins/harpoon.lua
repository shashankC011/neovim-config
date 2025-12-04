return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local harpoon = require("harpoon")

    -- Setup harpoon
    harpoon.setup()
    -- harpoon:setup({
    --   ui = {
    --     keymaps = {
    --       -- Press 'd' in the menu to delete the selected item
    --       delete_item = "d",
    --       -- You can customize other keys too, e.g., to use 'j' and 'k'
    --       move_down = "j",
    --       move_up = "k",
    --     },
    --   },
    -- })
    -- Keymaps
    vim.keymap.set("n", "<leader>ha", function()
      harpoon:list():add()
    end, { desc = "Harpoon add file" })

    vim.keymap.set("n", "<leader>h<Tab>", function()
      local list = harpoon:list()
      -- Clean up any nil entries before opening menu
      local cleaned_items = {}
      for i = 1, list:length() do
        local item = list:get(i)
        if item and item.value and item.value ~= "" then
          table.insert(cleaned_items, item)
        end
      end

      -- If we have valid items, show the menu
      if #cleaned_items > 0 then
        harpoon.ui:toggle_quick_menu(list)
      else
        print("No files in harpoon list")
      end
    end, { desc = "Harpoon toggle menu" })

    -- Navigate to files (with error handling)
    vim.keymap.set("n", "<leader>h1", function()
      pcall(function()
        harpoon:list():select(1)
      end)
    end, { desc = "Harpoon file 1" })

    vim.keymap.set("n", "<leader>h2", function()
      pcall(function()
        harpoon:list():select(2)
      end)
    end, { desc = "Harpoon file 2" })

    vim.keymap.set("n", "<leader>h3", function()
      pcall(function()
        harpoon:list():select(3)
      end)
    end, { desc = "Harpoon file 3" })

    vim.keymap.set("n", "<leader>h4", function()
      pcall(function()
        harpoon:list():select(4)
      end)
    end, { desc = "Harpoon file 4" })

    -- Navigate between files (with error handling)
    vim.keymap.set("n", "<leader>hn", function()
      pcall(function()
        harpoon:list():next()
      end)
    end, { desc = "Harpoon next" })

    vim.keymap.set("n", "<leader>hp", function()
      pcall(function()
        harpoon:list():prev()
      end)
    end, { desc = "Harpoon prev" })

    -- Remove current file from harpoon
    vim.keymap.set("n", "<leader>hr", function()
      harpoon:list():remove()
    end, { desc = "Harpoon remove current file" })

    -- Clear all harpoon marks
    vim.keymap.set("n", "<leader>hc", function()
      harpoon:list():clear()
    end, { desc = "Harpoon clear all" })

    -- POWER USER: Swap positions of files (FIXED)
    vim.keymap.set("n", "<leader>hs", function()
      local list = harpoon:list()
      local current_file = vim.api.nvim_buf_get_name(0)
      local current_pos = nil

      -- Convert to relative path for comparison
      local cwd = vim.fn.getcwd()
      local relative_current = vim.fn.fnamemodify(current_file, ":.")

      -- Find current file position - try multiple comparison methods
      local items = list.items
      for i, item in ipairs(items) do
        local item_path = item.value
        local relative_item = vim.fn.fnamemodify(item_path, ":.")

        -- Try multiple comparison methods
        if
            item_path == current_file
            or item_path == relative_current
            or relative_item == relative_current
            or vim.fn.resolve(item_path) == vim.fn.resolve(current_file)
        then
          current_pos = i
          break
        end
      end

      if current_pos then
        print("Current file is at position " .. current_pos)
        local swap_pos = vim.fn.input("Swap with position (1-" .. #items .. "): ")
        swap_pos = tonumber(swap_pos)

        if swap_pos and swap_pos > 0 and swap_pos <= #items and swap_pos ~= current_pos then
          -- Perform the swap
          local temp = items[current_pos]
          items[current_pos] = items[swap_pos]
          items[swap_pos] = temp

          print("Swapped positions " .. current_pos .. " and " .. swap_pos)
        else
          print("Invalid position or same as current")
        end
      else
        -- Debug: Show what we're comparing
        print("Current file not found. Debugging:")
        print("Current file: " .. current_file)
        print("Relative: " .. relative_current)
        print("Harpoon items:")
        for i, item in ipairs(items) do
          print("  " .. i .. ": " .. item.value)
        end
      end
    end, { desc = "Swap harpoon positions" })

    -- MULTIPLE TERMINALS: Quick access to different terminal types (with error handling)
    vim.keymap.set("n", "<leader>t1", function()
      -- Main terminal (position 5)
      local list = harpoon:list()
      local term_item = list:get(5)
      if term_item and term_item.value and string.match(term_item.value, "term://") then
        pcall(function()
          harpoon:list():select(5)
        end)
      else
        vim.cmd("split | terminal")
        harpoon:list():replace_at(5, vim.api.nvim_buf_get_name(0))
      end
    end, { desc = "Main terminal" })

    vim.keymap.set("n", "<leader>t2", function()
      -- Secondary terminal (position 6) - for running servers, logs, etc.
      local list = harpoon:list()
      local term_item = list:get(6)
      if term_item and string.match(term_item.value, "term://") then
        pcall(function()
          harpoon:list():select(6)
        end)
      else
        vim.cmd("vsplit | terminal")
        harpoon:list():replace_at(6, vim.api.nvim_buf_get_name(0))
      end
    end, { desc = "Secondary terminal" })

    vim.keymap.set("n", "<leader>t3", function()
      -- Test runner terminal (position 7)
      local list = harpoon:list()
      local term_item = list:get(7)
      if term_item and string.match(term_item.value, "term://") then
        pcall(function()
          harpoon:list():select(7)
        end)
      else
        vim.cmd("split | terminal")
        harpoon:list():replace_at(7, vim.api.nvim_buf_get_name(0))
        -- Auto-run test command if you want
        -- vim.api.nvim_chan_send(vim.bo.channel, "npm test\n")
      end
    end, { desc = "Test terminal" })
  end,
}

local Job = require("plenary.job")

function run_tsc()
  Job:new({
    command = "npx",
    args = { "tsc", "--noEmit" },
    cwd = vim.fn.getcwd(),
    on_exit = function(j, return_val)
      if return_val ~= 0 then
        local result = j:result()

        -- Write errors to the quickfix list
        local qf_entries = {}
        for _, line in ipairs(result) do
          -- Match: path/to/file.ts(5,10): error TS1234: Message
          local filename, lnum, col, text = string.match(line, "([^%(]+)%((%d+),(%d+)%)%: error [^:]+: (.+)")
          if filename and lnum and col and text then
            table.insert(qf_entries, {
              filename = filename,
              lnum = tonumber(lnum),
              col = tonumber(col),
              text = text,
              type = "E"
            })
          end
        end

        vim.schedule(function()
          vim.fn.setqflist(qf_entries, 'r')
          vim.cmd("copen")
          require("telescope.builtin").quickfix()
        end)
      else
        vim.schedule(function()
          vim.notify("✅ No TypeScript errors!", vim.log.levels.INFO)
        end)
      end
    end,
  }):start()
end

vim.api.nvim_create_user_command("TSC", function()
  run_tsc()
end, {})

vim.keymap.set("n", "<leader>ts", "<cmd>TSC<CR>", { desc = "Run tsc with Telescope" })



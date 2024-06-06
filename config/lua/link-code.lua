function get_file_and_line()
    -- Get the current line's text
    local line_text = vim.fn.getline('.')
    -- Get the cursor column position (1-based index)
    local col = vim.fn.col('.')

    -- Extract the word under the cursor
    local start_pos = col
    local end_pos = col

    -- Expand to the left
    while start_pos > 1 and line_text:sub(start_pos - 1, start_pos - 1):match('[^ %s%[%(]') do
        start_pos = start_pos - 1
    end

    -- Expand to the right
    while end_pos <= #line_text and line_text:sub(end_pos, end_pos):match('[^ %s%]%)]') do
        end_pos = end_pos + 1
    end

    -- Extract the full word under the cursor
    local cword = line_text:sub(start_pos, end_pos - 1)
    -- vim.notify("Debug: cword = " .. cword)

    -- Extract file and line number if present
    local line = cword:match(".+:(%d*)$")
    -- vim.notify("Debug: line = " .. (line or "nil"))
    local file = cword:match("([^:]+)")
    -- vim.notify("Debug: file = " .. (file or "nil") .. ", line = " .. (line or "nil"))

    return file, line
end

function get_git_commit_hash(directory)
  -- Change to the specified directory
  local change_dir_command = 'cd ' .. directory .. ' && '

  -- Command to get the latest Git commit hash
  local git_command = 'git rev-parse HEAD'

  -- Run the command and capture the output
  local result = vim.fn.systemlist(change_dir_command .. git_command)

  -- Handle the result
  if #result == 0 then
    return "Error: Unable to get commit hash"
  else
    return result[1]
  end
end

function copy_file_path_and_line()
  -- Get the current file path
  local file_path = vim.fn.fnamemodify(vim.fn.expand('%'), ':.')
  print(file_path)
  -- Get the current line number
  local line_number = vim.fn.line('.')
  -- Format the output string
  local output = file_path .. ':' .. line_number
  -- Copy to the system clipboard
  vim.fn.setreg('+', output)
  -- Optionally, show a message in Neovim
  print('Copied to clipboard: ' .. output)
end


function update_link()
  local file, line = get_file_and_line()
  local current_line_number = vim.fn.line('.') - 1  -- Get the current line number (0-indexed)


  local directory = file:match("([^/]+)")
  local path = file:match("^[^/]+/(.*)")
  local commit_hash = get_git_commit_hash(directory)
  local repo_link = "https://github.com/mpb-com/" .. directory .. "/blob/" .. commit_hash .. "/" .. (path or "nil") .. "#L" .. line
  local new_line = "* [" .. file .. ":" .. line .. "](" .. repo_link .. ")"
  vim.api.nvim_buf_set_lines(0, current_line_number, current_line_number + 1, false, { new_line })
end

function open_file_with_line()

    local file, line = get_file_and_line()
    -- vim.notify("DEBUG: file = " .. (file or "nil") .. ", line = " .. (line or "nil"))

    if file and line then
        vim.cmd("edit " .. file)
        -- vim.notify("line number " .. line)
        vim.api.nvim_win_set_cursor(0, {tonumber(line), 0})
    else
        -- vim.notify("no line number")
        vim.cmd("edit " .. file)
    end
end

vim.api.nvim_set_keymap('n', 'ro', '<cmd>lua open_file_with_line()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'rl', '<cmd>lua update_link()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'rc', '<cmd>lua copy_file_path_and_line()<CR>', { noremap = true, silent = true })

local function run_jira_tools(args)
  local cmd = string.format(
    'cd /Users/tarn.barford/projects/lovelace/projects/jira-tools && source /Users/tarn.barford/projects/lovelace/local.env && poetry run jira-tools %s',
    args or ""
  )

  local handle = io.popen("bash -c '" .. cmd .. "'")
  if not handle then
    vim.api.nvim_err_writeln("Failed to run jira-tools")
    return
  end

  local result = handle:read("*a")
  handle:close()

  -- Create a new empty buffer in the current window
  vim.cmd("enew")
  local buf = vim.api.nvim_get_current_buf()

  -- Write the output to the buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(result, "\n"))
end

local function improve_buffer_with_jira_tools()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local input = table.concat(lines, "\n")

  local cmd = {
    "bash", "-c",
    [[
      cd /Users/tarn.barford/projects/lovelace/projects/jira-tools && \
      source /Users/tarn.barford/projects/lovelace/local.env && \
      poetry run jira-tools improve
    ]]
  }

  vim.system(cmd, { stdin = input }, function(obj)
    if obj.code ~= 0 then
      vim.schedule(function()
        vim.api.nvim_err_writeln("jira-tools failed: " .. (obj.stderr or ""))
      end)
      return
    end

    local output = obj.stdout or ""
    local output_lines = vim.split(output, "\n", { plain = true })

    vim.schedule(function()
      vim.api.nvim_buf_set_lines(0, 0, -1, false, output_lines)
    end)
  end)
end

local function update_with_jira_tools()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local input = table.concat(lines, "\n")

  local cmd = {
    "bash", "-c",
    [[
      cd /Users/tarn.barford/projects/lovelace/projects/jira-tools && \
      source /Users/tarn.barford/projects/lovelace/local.env && \
      poetry run jira-tools update
    ]]
  }

  vim.system(cmd, { stdin = input }, function(obj)
    vim.schedule(function()
      if obj.code ~= 0 then
        local err = obj.stderr or "Unknown error"
        vim.api.nvim_err_writeln("jira-tools update failed: " .. err)
        return
      end

      -- Show first line of output
      local first_line = vim.split(obj.stdout or "", "\n", { plain = true })[1] or "No response"
      vim.api.nvim_echo({{ first_line, "Normal" }}, false, {})
    end)
  end)
end


local function get_jira_ticket_under_cursor()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()

  -- Look for JIRA ticket pattern around cursor column
  local ticket
  for match in line:gmatch("[A-Z]+%-%d+") do
    local start_pos, end_pos = line:find(match, 1, true)
    if start_pos and end_pos and col + 1 >= start_pos and col + 1 <= end_pos then
      ticket = match
      break
    end
  end

  return ticket
end


local function open_ticket_under_cursor()
  local ticket = get_jira_ticket_under_cursor()
  if not ticket then
    vim.api.nvim_err_writeln("No valid JIRA ticket under cursor")
    return
  end

  -- Build URL (customize your domain!)
  local url = "https://mpbphotographic.atlassian.net/browse/" .. ticket

  -- Open in browser (macOS: `open`, Linux: `xdg-open`)
  os.execute(string.format("open '%s'", url))

  -- Optional: echo confirmation
  vim.api.nvim_echo({{ "Opened " .. ticket, "Normal" }}, false, {})
end

local function jira_edit_ticket()
  local ticket = get_jira_ticket_under_cursor()
  if not ticket then
    vim.api.nvim_err_writeln("No valid JIRA ticket under cursor")
    return
  end

  -- Command to run
  local cmd = string.format([[
    cd /Users/tarn.barford/projects/lovelace/projects/jira-tools && \
    source /Users/tarn.barford/projects/lovelace/local.env && \
    poetry run jira-tools get %s
  ]], ticket)

  -- Run command and capture output
  local handle = io.popen("bash -c '" .. cmd .. "'", "r")
  if not handle then
    vim.api.nvim_err_writeln("Failed to run jira-tools get")
    return
  end

  local result = handle:read("*a")
  handle:close()

  -- Open new editable buffer (like :enew)
  vim.cmd("enew")
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(result, "\n"))

  -- Optional: set buffer name
  vim.api.nvim_buf_set_name(buf, "jira-" .. ticket)
end


vim.api.nvim_create_user_command("JiraTools", function(opts)
  run_jira_tools(opts.args)
end, { nargs = "*" })

vim.api.nvim_create_user_command("JiraImprove", function()
  improve_buffer_with_jira_tools()
end, {})

vim.api.nvim_create_user_command("JiraUpdate", function()
  update_with_jira_tools()
end, {})

vim.api.nvim_create_user_command("JiraOpen", function()
  open_ticket_under_cursor()
end, {})

vim.api.nvim_create_user_command("JiraEdit", function()
  jira_edit_ticket()
end, {})

vim.keymap.set("n", "<leader>jo", function()
  open_ticket_under_cursor()
end, { desc = "Open JIRA ticket under cursor" })

vim.keymap.set("n", "<leader>je", function()
  jira_edit_ticket()
end, { desc = "Edirt JIRA ticket under cursor" })

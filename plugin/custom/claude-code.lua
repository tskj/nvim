-- Helper functions for Claude Code integration
local function get_buffer_info()
  local buf = vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(buf)
  local relative_path = vim.fn.fnamemodify(filepath, ":~:.")
  return {
    filepath = filepath,
    relative_path = relative_path,
    filetype = vim.bo.filetype,
  }
end

local function get_visual_selection()
  -- Get visual selection using vim's built-in register
  vim.cmd('normal! "vy')
  return vim.fn.getreg("v")
end

local function show_popup(title, content)
  -- Create a modal popup like gpq does
  local buf = vim.api.nvim_create_buf(false, true)
  local lines = vim.split(content, "\n")
  local line_lengths = {}
  for _, line in ipairs(lines) do
    table.insert(line_lengths, #line)
  end
  local width = math.min(100, 4 + math.max(unpack(line_lengths)))
  local height = math.min(30, 2 + #lines)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  local opts = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    anchor = "NW",
    style = "minimal",
    border = "rounded",
    title = " " .. title .. " ",
    title_pos = "center",
  }
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
  local win = vim.api.nvim_open_win(buf, true, opts)
  vim.keymap.set("n", "q", function() vim.api.nvim_win_close(win, false) end, { buffer = buf, desc = "Close popup" })
  vim.keymap.set("n", "<Esc>", function() vim.api.nvim_win_close(win, false) end, { buffer = buf, desc = "Close popup" })
end

local function get_prompt_template()
  local cwd = vim.fn.getcwd()
  return "You are running headless mode. The current working directory is: " .. cwd .. [[


Look at the following text, it will be a reference to a file in the current project.
The input could be:
- A complete filename (e.g., 'config.lua', 'src/main.js')
- Part of a filename (e.g., 'config', 'main')
- A git diff output showing file changes
- Several lines of code from inside a file
- A single line of code with context

Use your available tools to search for and locate the file. If the input contains code lines, search for those exact lines or similar patterns in the codebase. If it's multiple lines, try to identify a specific line number within the found file.

Examples of input types:
- 'config.lua' → Find file named config.lua
- 'config' → Find files with 'config' in the name
- 'function calculateTotal()' → Search for this function definition
- 'const API_URL = "https://api.example.com"' → Find where this constant is defined
- Git diff showing +/- lines → Find the modified file

Your response must be ONLY the file path in one of these exact formats:
- If you found a specific line: /absolute/path/to/file.ext:123
- If you found the file but no specific line: /absolute/path/to/file.ext
- If no file matches: ERROR_NO_SUCH_FILE

Do NOT include explanatory text like "I found it here:" or "The file is located at:" or "Here's the match:".
Your entire response will be parsed by a script that expects only the formats above.
The input follows:

]]
end

-- Ask Claude to locate a file based on `input`, then open it
-- (shared by ClaudeCodeFind and ClaudeCodeFindPrompt)
local function find_file_from_input(input)
  -- Show a message that we're processing (user can Ctrl-C to abort)
  vim.notify("Asking Claude to find file... (Ctrl-C to abort)", vim.log.levels.INFO)

  -- Combine prompt and input, then properly escape for shell
  local full_prompt = get_prompt_template() .. "\n" .. input
  local escaped_prompt = vim.fn.shellescape(full_prompt)
  local allowed_tools = '--allowedTools "Read Glob Grep LS Agent TodoRead TodoWrite Bash(find:*) Bash(rg:*) Bash(grep:*) Bash(ls:*) Bash(cat:*) Bash(head:*) Bash(tail:*)"'
  local disallowed_tools = '--disallowedTools "Edit MultiEdit Write WebSearch WebFetch NotebookEdit"'
  local cmd = "claude " .. allowed_tools .. " " .. disallowed_tools .. " -p " .. escaped_prompt
  local result = vim.fn.system(cmd)

  -- Check if command was interrupted
  if vim.v.shell_error == 130 then -- 130 is the exit code for SIGINT (Ctrl-C)
    vim.notify("Claude command aborted", vim.log.levels.WARN)
    return
  end

  -- Parse the result
  local clean_result = vim.trim(result)
  if clean_result == "ERROR_NO_SUCH_FILE" then
    vim.notify("No matching file found", vim.log.levels.WARN)
    return
  end

  -- Otherwise try to parse as filename
  local filename, line_num = string.match(clean_result, "^([^:]+):?(%d*)$")
  if not filename then
    vim.notify("Could not parse result: " .. clean_result, vim.log.levels.ERROR)
    return
  end
  if vim.fn.filereadable(filename) == 0 then
    vim.notify("File does not exist: " .. filename, vim.log.levels.ERROR)
    return
  end

  vim.cmd("silent edit " .. filename)
  if line_num and line_num ~= "" then
    vim.cmd("normal! " .. line_num .. "G")
  end
  vim.cmd("redraw")
  vim.cmd("echo ''")
end

local function claude_code_find_file()
  local clipboard_content = vim.fn.getreg("+")
  if clipboard_content == "" then
    vim.notify("Clipboard is empty", vim.log.levels.WARN)
    return
  end
  find_file_from_input(clipboard_content)
end

local function claude_code_find_with_prompt()
  local user_input = vim.fn.input("Describe what you're looking for: ")
  if user_input == "" then
    vim.notify("Search cancelled", vim.log.levels.WARN)
    return
  end
  find_file_from_input(user_input)
end

-- Create user commands
vim.api.nvim_create_user_command("ClaudeCodeFind", claude_code_find_file,
  { desc = "Find file using Claude Code from clipboard" })
vim.api.nvim_create_user_command("ClaudeCodeFindPrompt", claude_code_find_with_prompt,
  { desc = "Find file using Claude Code with custom prompt" })

local function claude_code_rewrite(continue)
  local mode = vim.api.nvim_get_mode()
  local selection = mode.mode == "v" and get_visual_selection() or nil
  local buffer_info = get_buffer_info()

  if not selection then
    vim.notify("No text selected for rewrite", vim.log.levels.WARN)
    return
  end

  vim.notify("Claude is rewriting... (Ctrl-C to abort)", vim.log.levels.INFO)

  local prompt = "Please rewrite the following code. Consider improvements for readability, performance, and best practices. Only return the rewritten code, no explanations.\n\nFile: "
    .. buffer_info.relative_path .. "\nLanguage: " .. buffer_info.filetype .. "\n\nCode to rewrite:\n" .. selection
  local escaped_prompt = vim.fn.shellescape(prompt)
  local continue_flag = continue and " -c" or ""
  local allowed_tools = '--allowedTools "Read Edit MultiEdit Glob Grep LS Bash(find:*) Bash(rg:*)"'
  local disallowed_tools = '--disallowedTools "Write WebSearch WebFetch NotebookEdit"'
  local cmd = "claude" .. continue_flag .. " " .. allowed_tools .. " " .. disallowed_tools .. " -p " .. escaped_prompt
  local result = vim.fn.system(cmd)

  if vim.v.shell_error == 130 then
    vim.notify("Claude command aborted", vim.log.levels.WARN)
    return
  end

  local clean_result = vim.trim(result)
  if clean_result == "" then
    vim.notify("Claude returned empty response", vim.log.levels.ERROR)
    return
  end

  -- Replace the selected text with Claude's rewrite
  vim.cmd("normal! gvd")
  vim.api.nvim_put(vim.split(clean_result, "\n"), "c", true, true)
  vim.notify("Claude: Code rewritten successfully", vim.log.levels.INFO)
end

local function claude_code_append(continue)
  local mode = vim.api.nvim_get_mode()
  local selection = mode.mode == "v" and get_visual_selection() or nil
  local buffer_info = get_buffer_info()

  if not selection then
    vim.notify("No text selected for append", vim.log.levels.WARN)
    return
  end

  vim.notify("Claude is adding code... (Ctrl-C to abort)", vim.log.levels.INFO)

  local prompt = "Please add code after the following selection. Consider what would logically follow or enhance this code. Only return the new code to append, no explanations.\n\nFile: "
    .. buffer_info.relative_path .. "\nLanguage: " .. buffer_info.filetype .. "\n\nExisting code:\n" .. selection
  local escaped_prompt = vim.fn.shellescape(prompt)
  local continue_flag = continue and " -c" or ""
  local allowed_tools = '--allowedTools "Read Edit MultiEdit Glob Grep LS Bash(find:*) Bash(rg:*)"'
  local disallowed_tools = '--disallowedTools "Write WebSearch WebFetch NotebookEdit"'
  local cmd = "claude" .. continue_flag .. " " .. allowed_tools .. " " .. disallowed_tools .. " -p " .. escaped_prompt
  local result = vim.fn.system(cmd)

  if vim.v.shell_error == 130 then
    vim.notify("Claude command aborted", vim.log.levels.WARN)
    return
  end

  local clean_result = vim.trim(result)
  if clean_result == "" then
    vim.notify("Claude returned empty response", vim.log.levels.ERROR)
    return
  end

  -- Move cursor to end of selection and append
  vim.cmd("normal! gv")
  vim.cmd("normal! o")
  vim.api.nvim_put(vim.split(clean_result, "\n"), "l", true, true)
  vim.notify("Claude: Code appended successfully", vim.log.levels.INFO)
end

local function claude_code_question(continue)
  local mode = vim.api.nvim_get_mode()
  local selection = mode.mode == "v" and get_visual_selection() or nil
  local buffer_info = get_buffer_info()

  if not selection then
    vim.notify("No text selected for question", vim.log.levels.WARN)
    return
  end

  vim.notify("Asking Claude... (Ctrl-C to abort)", vim.log.levels.INFO)

  local prompt = "Please analyze and explain the following code. What does it do, how does it work, and are there any potential issues or improvements?\n\nFile: "
    .. buffer_info.relative_path .. "\nLanguage: " .. buffer_info.filetype .. "\n\nCode to analyze:\n" .. selection
  local escaped_prompt = vim.fn.shellescape(prompt)
  local continue_flag = continue and " -c" or ""
  local allowed_tools = '--allowedTools "Read Glob Grep LS Bash(find:*) Bash(rg:*)"'
  local disallowed_tools = '--disallowedTools "Edit MultiEdit Write WebSearch WebFetch NotebookEdit"'
  local cmd = "claude" .. continue_flag .. " " .. allowed_tools .. " " .. disallowed_tools .. " -p " .. escaped_prompt
  local result = vim.fn.system(cmd)

  if vim.v.shell_error == 130 then
    vim.notify("Claude command aborted", vim.log.levels.WARN)
    return
  end

  local clean_result = vim.trim(result)
  if clean_result == "" then
    vim.notify("Claude returned empty response", vim.log.levels.ERROR)
    return
  end

  show_popup("Claude Analysis", clean_result)
end

local function claude_selection_with_prompt()
  local selection = get_visual_selection()

  if not selection or selection == "" then
    vim.notify("No text selected", vim.log.levels.WARN)
    return
  end

  -- Get additional prompt from user
  local prompt = vim.fn.input("Additional prompt: ")
  if prompt == "" then
    return
  end

  -- Get buffer info
  local bufname = vim.api.nvim_buf_get_name(0)
  local relative_path = vim.fn.fnamemodify(bufname, ":~:.")
  local filetype = vim.bo.filetype
  local full_prompt = "Context: File " .. relative_path .. " (" .. filetype .. ")\n\nSelected code:\n"
    .. selection .. "\n\nTask: " .. prompt

  vim.notify("Asking Claude...", vim.log.levels.INFO)

  -- Use Claude CLI directly
  local escaped_prompt = vim.fn.shellescape(full_prompt)
  local cmd = "claude -p " .. escaped_prompt

  -- Run asynchronously and show result in toast
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data and #data > 0 then
        local response = table.concat(data, "\n"):gsub("^%s+", ""):gsub("%s+$", "")
        if response ~= "" then
          vim.notify(response, vim.log.levels.INFO)
        end
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 then
        local error_msg = table.concat(data, "\n")
        vim.notify("Claude error: " .. error_msg, vim.log.levels.ERROR)
      end
    end,
  })
end

-- Create user commands
vim.api.nvim_create_user_command("ClaudeCodeRewrite", function() claude_code_rewrite(false) end,
  { desc = "Rewrite selected code with Claude" })
vim.api.nvim_create_user_command("ClaudeCodeRewriteContinue", function() claude_code_rewrite(true) end,
  { desc = "Rewrite selected code with Claude (continue conversation)" })
vim.api.nvim_create_user_command("ClaudeCodeAppend", function() claude_code_append(false) end,
  { desc = "Append code after selection with Claude" })
vim.api.nvim_create_user_command("ClaudeCodeAppendContinue", function() claude_code_append(true) end,
  { desc = "Append code after selection with Claude (continue conversation)" })
vim.api.nvim_create_user_command("ClaudeCodeQuestion", function() claude_code_question(false) end,
  { desc = "Ask Claude about selected code" })
vim.api.nvim_create_user_command("ClaudeCodeQuestionContinue", function() claude_code_question(true) end,
  { desc = "Ask Claude about selected code (continue conversation)" })
vim.api.nvim_create_user_command("ClaudeSelectionWithPrompt", claude_selection_with_prompt,
  { desc = "Ask Claude about selected code with custom prompt" })

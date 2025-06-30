local utils = require("user.utils")
local function get_buffer_info()
  local buf = vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(buf)
  local relative_path = vim.fn.fnamemodify(filepath, ":~:.")
  local filetype = vim.bo.filetype
  return {filepath = filepath, ["relative-path"] = relative_path, filetype = filetype}
end
local function get_visual_selection()
  local _ = vim.cmd("normal! \"vy")
  local selection = vim.fn.getreg("v")
  return selection
end
local function show_popup(title, content)
  local buf = vim.api.nvim_create_buf(false, true)
  local lines = vim.split(content, "\n")
  local width
  local function _1_()
    local tbl_21_ = {}
    local i_22_ = 0
    for _, line in ipairs(lines) do
      local val_23_ = #line
      if (nil ~= val_23_) then
        i_22_ = (i_22_ + 1)
        tbl_21_[i_22_] = val_23_
      else
      end
    end
    return tbl_21_
  end
  width = math.min(100, (4 + math.max(unpack(_1_()))))
  local height = math.min(30, (2 + #lines))
  local row = math.floor(((vim.o.lines - height) / 2))
  local col = math.floor(((vim.o.columns - width) / 2))
  local opts = {relative = "editor", width = width, height = height, row = row, col = col, anchor = "NW", style = "minimal", border = "rounded", title = (" " .. title .. " "), title_pos = "center"}
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
  local win = vim.api.nvim_open_win(buf, true, opts)
  local function _3_()
    return vim.api.nvim_win_close(win, false)
  end
  vim.keymap.set("n", "q", _3_, {buffer = buf, desc = "Close popup"})
  local function _4_()
    return vim.api.nvim_win_close(win, false)
  end
  return vim.keymap.set("n", "<Esc>", _4_, {buffer = buf, desc = "Close popup"})
end
local function get_prompt_template()
  local cwd = vim.fn.getcwd()
  return ("You are running headless mode. The current working directory is: " .. cwd .. "\n\nLook at the following text, it will be a reference to a file in the current project.\nThe input could be:\n- A complete filename (e.g., 'config.lua', 'src/main.js')\n- Part of a filename (e.g., 'config', 'main')\n- A git diff output showing file changes\n- Several lines of code from inside a file\n- A single line of code with context\n\nUse your available tools to search for and locate the file. If the input contains code lines, search for those exact lines or similar patterns in the codebase. If it's multiple lines, try to identify a specific line number within the found file.\n\nExamples of input types:\n- 'config.lua' \226\134\146 Find file named config.lua\n- 'config' \226\134\146 Find files with 'config' in the name\n- 'function calculateTotal()' \226\134\146 Search for this function definition\n- 'const API_URL = \"https://api.example.com\"' \226\134\146 Find where this constant is defined\n- Git diff showing +/- lines \226\134\146 Find the modified file\n\nYour response must be ONLY the file path in one of these exact formats:\n- If you found a specific line: /absolute/path/to/file.ext:123\n- If you found the file but no specific line: /absolute/path/to/file.ext\n- If no file matches: ERROR_NO_SUCH_FILE\n\nDo NOT include explanatory text like \"I found it here:\" or \"The file is located at:\" or \"Here's the match:\".\nYour entire response will be parsed by a script that expects only the formats above.\nThe input follows:\n\n")
end
local function claude_code_find_file()
  local clipboard_content = vim.fn.getreg("+")
  if (clipboard_content == "") then
    vim.notify("Clipboard is empty", vim.log.levels.WARN)
    return nil
  else
  end
  vim.notify("Asking Claude to find file... (Ctrl-C to abort)", vim.log.levels.INFO)
  local prompt = get_prompt_template()
  local full_prompt = (prompt .. "\n" .. clipboard_content)
  local escaped_prompt = vim.fn.shellescape(full_prompt)
  local allowed_tools = "--allowedTools \"Read Glob Grep LS Agent TodoRead TodoWrite Bash(find:*) Bash(rg:*) Bash(grep:*) Bash(ls:*) Bash(cat:*) Bash(head:*) Bash(tail:*)\""
  local disallowed_tools = "--disallowedTools \"Edit MultiEdit Write WebSearch WebFetch NotebookEdit\""
  local cmd = ("claude " .. allowed_tools .. " " .. disallowed_tools .. " -p " .. escaped_prompt)
  local result = vim.fn.system(cmd)
  if (vim.v.shell_error == 130) then
    return vim.notify("Claude command aborted", vim.log.levels.WARN)
  else
    local clean_result = vim.trim(result)
    if (clean_result == "ERROR_NO_SUCH_FILE") then
      return vim.notify("No matching file found", vim.log.levels.WARN)
    else
      local filename, line_num = string.match(clean_result, "^([^:]+):?(%d*)$")
      if not filename then
        return vim.notify(("Could not parse result: " .. clean_result), vim.log.levels.ERROR)
      else
        if (vim.fn.filereadable(filename) == 0) then
          return vim.notify(("File does not exist: " .. filename), vim.log.levels.ERROR)
        else
          vim.cmd(("silent edit " .. filename))
          if (line_num and (line_num ~= "")) then
            vim.cmd(("normal! " .. line_num .. "G"))
          else
          end
          vim.cmd("redraw")
          return vim.cmd("echo ''")
        end
      end
    end
  end
end
vim.api.nvim_create_user_command("ClaudeCodeFind", claude_code_find_file, {desc = "Find file using Claude Code from clipboard"})
local function claude_code_rewrite(continue_3f)
  local mode = vim.api.nvim_get_mode()
  local selection
  if (mode.mode == "v") then
    selection = get_visual_selection()
  else
    selection = nil
  end
  local buffer_info = get_buffer_info()
  if not selection then
    vim.notify("No text selected for rewrite", vim.log.levels.WARN)
    return nil
  else
  end
  vim.notify("Claude is rewriting... (Ctrl-C to abort)", vim.log.levels.INFO)
  local prompt = ("Please rewrite the following code. Consider improvements for readability, performance, and best practices. Only return the rewritten code, no explanations.\n\nFile: " .. buffer_info["relative-path"] .. "\nLanguage: " .. buffer_info.filetype .. "\n\nCode to rewrite:\n" .. selection)
  local escaped_prompt = vim.fn.shellescape(prompt)
  local continue_flag
  if continue_3f then
    continue_flag = " -c"
  else
    continue_flag = ""
  end
  local allowed_tools = "--allowedTools \"Read Edit MultiEdit Glob Grep LS Bash(find:*) Bash(rg:*)\""
  local disallowed_tools = "--disallowedTools \"Write WebSearch WebFetch NotebookEdit\""
  local cmd = ("claude" .. continue_flag .. " " .. allowed_tools .. " " .. disallowed_tools .. " -p " .. escaped_prompt)
  local result = vim.fn.system(cmd)
  if (vim.v.shell_error == 130) then
    return vim.notify("Claude command aborted", vim.log.levels.WARN)
  else
    local clean_result = vim.trim(result)
    if (clean_result == "") then
      return vim.notify("Claude returned empty response", vim.log.levels.ERROR)
    else
      vim.cmd("normal! gvd")
      vim.api.nvim_put(vim.split(clean_result, "\n"), "c", true, true)
      return vim.notify("Claude: Code rewritten successfully", vim.log.levels.INFO)
    end
  end
end
local function claude_code_append(continue_3f)
  local mode = vim.api.nvim_get_mode()
  local selection
  if (mode.mode == "v") then
    selection = get_visual_selection()
  else
    selection = nil
  end
  local buffer_info = get_buffer_info()
  if not selection then
    vim.notify("No text selected for append", vim.log.levels.WARN)
    return nil
  else
  end
  vim.notify("Claude is adding code... (Ctrl-C to abort)", vim.log.levels.INFO)
  local prompt = ("Please add code after the following selection. Consider what would logically follow or enhance this code. Only return the new code to append, no explanations.\n\nFile: " .. buffer_info["relative-path"] .. "\nLanguage: " .. buffer_info.filetype .. "\n\nExisting code:\n" .. selection)
  local escaped_prompt = vim.fn.shellescape(prompt)
  local continue_flag
  if continue_3f then
    continue_flag = " -c"
  else
    continue_flag = ""
  end
  local allowed_tools = "--allowedTools \"Read Edit MultiEdit Glob Grep LS Bash(find:*) Bash(rg:*)\""
  local disallowed_tools = "--disallowedTools \"Write WebSearch WebFetch NotebookEdit\""
  local cmd = ("claude" .. continue_flag .. " " .. allowed_tools .. " " .. disallowed_tools .. " -p " .. escaped_prompt)
  local result = vim.fn.system(cmd)
  if (vim.v.shell_error == 130) then
    return vim.notify("Claude command aborted", vim.log.levels.WARN)
  else
    local clean_result = vim.trim(result)
    if (clean_result == "") then
      return vim.notify("Claude returned empty response", vim.log.levels.ERROR)
    else
      vim.cmd("normal! gv")
      vim.cmd("normal! o")
      vim.api.nvim_put(vim.split(clean_result, "\n"), "l", true, true)
      return vim.notify("Claude: Code appended successfully", vim.log.levels.INFO)
    end
  end
end
local function claude_code_question(continue_3f)
  local mode = vim.api.nvim_get_mode()
  local selection
  if (mode.mode == "v") then
    selection = get_visual_selection()
  else
    selection = nil
  end
  local buffer_info = get_buffer_info()
  if not selection then
    vim.notify("No text selected for question", vim.log.levels.WARN)
    return nil
  else
  end
  vim.notify("Asking Claude... (Ctrl-C to abort)", vim.log.levels.INFO)
  local prompt = ("Please analyze and explain the following code. What does it do, how does it work, and are there any potential issues or improvements?\n\nFile: " .. buffer_info["relative-path"] .. "\nLanguage: " .. buffer_info.filetype .. "\n\nCode to analyze:\n" .. selection)
  local escaped_prompt = vim.fn.shellescape(prompt)
  local continue_flag
  if continue_3f then
    continue_flag = " -c"
  else
    continue_flag = ""
  end
  local allowed_tools = "--allowedTools \"Read Glob Grep LS Bash(find:*) Bash(rg:*)\""
  local disallowed_tools = "--disallowedTools \"Edit MultiEdit Write WebSearch WebFetch NotebookEdit\""
  local cmd = ("claude" .. continue_flag .. " " .. allowed_tools .. " " .. disallowed_tools .. " -p " .. escaped_prompt)
  local result = vim.fn.system(cmd)
  if (vim.v.shell_error == 130) then
    return vim.notify("Claude command aborted", vim.log.levels.WARN)
  else
    local clean_result = vim.trim(result)
    if (clean_result == "") then
      return vim.notify("Claude returned empty response", vim.log.levels.ERROR)
    else
      return show_popup("Claude Analysis", clean_result)
    end
  end
end
local function claude_selection_with_prompt()
  local _ = vim.cmd("normal! \"vy")
  local selection = vim.fn.getreg("v")
  if (not selection or (selection == "")) then
    vim.notify("No text selected", vim.log.levels.WARN)
    return nil
  else
  end
  local prompt = vim.fn.input("Additional prompt: ")
  if (prompt == "") then
    return nil
  else
  end
  local bufname = vim.api.nvim_buf_get_name(0)
  local relative_path = vim.fn.fnamemodify(bufname, ":~:.")
  local filetype = vim.bo.filetype
  local full_prompt = ("Context: File " .. relative_path .. " (" .. filetype .. ")\n\nSelected code:\n" .. selection .. "\n\nTask: " .. prompt)
  vim.notify("Asking Claude...", vim.log.levels.INFO)
  local escaped_prompt = vim.fn.shellescape(full_prompt)
  local cmd = ("claude -p " .. escaped_prompt)
  local function _28_(_0, data)
    if (data and (#data > 0)) then
      local response = string.gsub(string.gsub(table.concat(data, "\n"), "^%s+", ""), "%s+$", "")
      if (response ~= "") then
        return vim.notify(response, vim.log.levels.INFO)
      else
        return nil
      end
    else
      return nil
    end
  end
  local function _31_(_0, data)
    if (data and (#data > 0)) then
      local error_msg = table.concat(data, "\n")
      return vim.notify(("Claude error: " .. error_msg), vim.log.levels.ERROR)
    else
      return nil
    end
  end
  return vim.fn.jobstart(cmd, {stdout_buffered = true, on_stdout = _28_, on_stderr = _31_})
end
local function _33_()
  return claude_code_rewrite(false)
end
vim.api.nvim_create_user_command("ClaudeCodeRewrite", _33_, {desc = "Rewrite selected code with Claude"})
local function _34_()
  return claude_code_rewrite(true)
end
vim.api.nvim_create_user_command("ClaudeCodeRewriteContinue", _34_, {desc = "Rewrite selected code with Claude (continue conversation)"})
local function _35_()
  return claude_code_append(false)
end
vim.api.nvim_create_user_command("ClaudeCodeAppend", _35_, {desc = "Append code after selection with Claude"})
local function _36_()
  return claude_code_append(true)
end
vim.api.nvim_create_user_command("ClaudeCodeAppendContinue", _36_, {desc = "Append code after selection with Claude (continue conversation)"})
local function _37_()
  return claude_code_question(false)
end
vim.api.nvim_create_user_command("ClaudeCodeQuestion", _37_, {desc = "Ask Claude about selected code"})
local function _38_()
  return claude_code_question(true)
end
vim.api.nvim_create_user_command("ClaudeCodeQuestionContinue", _38_, {desc = "Ask Claude about selected code (continue conversation)"})
vim.api.nvim_create_user_command("ClaudeSelectionWithPrompt", claude_selection_with_prompt, {desc = "Ask Claude about selected code with custom prompt"})
return {["claude-code-find-file"] = claude_code_find_file, ["claude-code-rewrite"] = claude_code_rewrite, ["claude-code-append"] = claude_code_append, ["claude-code-question"] = claude_code_question, ["claude-selection-with-prompt"] = claude_selection_with_prompt}

local utils = require("user.utils")
local function get_prompt_template()
  local cwd = vim.fn.getcwd()
  return ("You are running headless mode. The current working directory is: " .. cwd .. "\nLook at the following text, it will be a reference to a file in the current project. \nIt could be a git diff, a file name, or several lines from inside the file.\nIf it's the latter, use tool calls to search for the file in question. If it's multiple lines, pick\na line number. \n\nYour response must be ONLY the file path in one of these exact formats:\n- If you found a specific line: /absolute/path/to/file.ext:123\n- If you found the file but no specific line: /absolute/path/to/file.ext\n- If no file matches: ERROR_NO_SUCH_FILE\n\nDo NOT include explanatory text like \"I found it here:\" or \"The file is located at:\" or \"Here's the match:\".\nYour entire response will be parsed by a script that expects only the formats above.\nThe input follows:\n\n")
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
  local cmd = ("claude -p " .. escaped_prompt)
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
return {["claude-code-find-file"] = claude_code_find_file}

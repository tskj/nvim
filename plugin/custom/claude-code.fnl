(local utils (require :user.utils))

(fn get-prompt-template []
  (let [cwd (vim.fn.getcwd)]
    (.. "You are running headless mode. The current working directory is: " cwd "

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
- 'const API_URL = \"https://api.example.com\"' → Find where this constant is defined
- Git diff showing +/- lines → Find the modified file

Your response must be ONLY the file path in one of these exact formats:
- If you found a specific line: /absolute/path/to/file.ext:123
- If you found the file but no specific line: /absolute/path/to/file.ext
- If no file matches: ERROR_NO_SUCH_FILE

Do NOT include explanatory text like \"I found it here:\" or \"The file is located at:\" or \"Here's the match:\".
Your entire response will be parsed by a script that expects only the formats above.
The input follows:

")))

(fn claude-code-find-file []
  (let [clipboard-content (vim.fn.getreg "+")]

    (when (= clipboard-content "")
      (vim.notify "Clipboard is empty" vim.log.levels.WARN)
      (lua "return nil"))

    ;; Show a message that we're processing (user can Ctrl-C to abort)
    (vim.notify "Asking Claude to find file... (Ctrl-C to abort)" vim.log.levels.INFO)

    ;; Combine prompt and clipboard content, then properly escape for shell
    (let [prompt (get-prompt-template)
          full-prompt (.. prompt "\n" clipboard-content)
          escaped-prompt (vim.fn.shellescape full-prompt)
          allowed-tools "--allowedTools \"Read Glob Grep LS Agent TodoRead TodoWrite Bash(find:*) Bash(rg:*) Bash(grep:*) Bash(ls:*) Bash(cat:*) Bash(head:*) Bash(tail:*)\""
          disallowed-tools "--disallowedTools \"Edit MultiEdit Write WebSearch WebFetch NotebookEdit\""
          cmd (.. "claude " allowed-tools " " disallowed-tools " -p " escaped-prompt)
          result (vim.fn.system cmd)]

      ;; Check if command was interrupted
      (if (= vim.v.shell_error 130) ; 130 is the exit code for SIGINT (Ctrl-C)
          (vim.notify "Claude command aborted" vim.log.levels.WARN)
          ;; Parse the result
          (let [clean-result (vim.trim result)]
            (if (= clean-result "ERROR_NO_SUCH_FILE")
                (vim.notify "No matching file found" vim.log.levels.WARN)
                ;; Otherwise try to parse as filename
                (let [(filename line-num) (string.match clean-result "^([^:]+):?(%d*)$")]
                  (if (not filename)
                      (vim.notify (.. "Could not parse result: " clean-result) vim.log.levels.ERROR)
                      (if (= (vim.fn.filereadable filename) 0)
                          (vim.notify (.. "File does not exist: " filename) vim.log.levels.ERROR)
                          (do
                            (vim.cmd (.. "silent edit " filename))
                            (when (and line-num (not= line-num ""))
                              (vim.cmd (.. "normal! " line-num "G")))
                            (vim.cmd "redraw")
                            (vim.cmd "echo ''")))))))))))

;; Create user command
(vim.api.nvim_create_user_command
  :ClaudeCodeFind
  claude-code-find-file
  {:desc "Find file using Claude Code from clipboard"})

{: claude-code-find-file}

(local utils (require :user.utils))

(fn get-prompt-template []
  (let [cwd (vim.fn.getcwd)]
    (.. "You are running headless mode. The current working directory is: " cwd "
Look at the following text, it will be a reference to a file in the current project. 
It could be a git diff, a file name, or several lines from inside the file.
If it's the latter, use tool calls to search for the file in question. If it's multiple lines, pick
a line number. 

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
          cmd (.. "claude -p " escaped-prompt)
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

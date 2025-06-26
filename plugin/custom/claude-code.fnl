(local utils (require :user.utils))

(fn get-prompt-template []
  (let [cwd (vim.fn.getcwd)]
    (.. "You are running headless mode. The current working directory is: " cwd "
Look at the following text, it will be a reference to a file in the current project. 
It could be a git diff, a file name, or several lines from inside the file.
If it's the latter, use tool calls to search for the file in question. If it's multiple lines, pick
a line number. Your task is to respond with the absolute path to the file and linenumber (if appropriate,
if not, only the absolute path). Answer only with this information, as it will be used by the automated
system to open the user's editor at the correct spot. Always use absolute paths starting with /.
If you cannot find a matching file, respond with exactly: ERROR_NO_SUCH_FILE
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
                            (vim.cmd "redraw")))))))))))

;; Create user command
(vim.api.nvim_create_user_command 
  :ClaudeCodeFind
  claude-code-find-file
  {:desc "Find file using Claude Code from clipboard"})

{: claude-code-find-file}
(local utils (require :user.utils))

;; Helper functions for Claude Code integration
(fn get-buffer-info []
  (let [buf (vim.api.nvim_get_current_buf)
        filepath (vim.api.nvim_buf_get_name buf)
        relative-path (vim.fn.fnamemodify filepath ":~:.")
        filetype vim.bo.filetype]
    {:filepath filepath
     :relative-path relative-path
     :filetype filetype}))

(fn get-visual-selection []
  ;; Get visual selection using vim's built-in function
  (let [_ (vim.cmd "normal! \"vy")
        selection (vim.fn.getreg "v")]
    selection))

(fn show-popup [title content]
  ;; Create a modal popup like gpq does
  (let [buf (vim.api.nvim_create_buf false true)
        lines (vim.split content "\n")
        width (math.min 100 (+ 4 (math.max (unpack (icollect [_ line (ipairs lines)] (length line))))))
        height (math.min 30 (+ 2 (length lines)))
        row (math.floor (/ (- vim.o.lines height) 2))
        col (math.floor (/ (- vim.o.columns width) 2))
        opts {:relative "editor"
              :width width
              :height height
              :row row
              :col col
              :anchor "NW"
              :style "minimal"
              :border "rounded"
              :title (.. " " title " ")
              :title_pos "center"}]
    (vim.api.nvim_buf_set_lines buf 0 -1 false lines)
    (vim.api.nvim_buf_set_option buf "modifiable" false)
    (vim.api.nvim_buf_set_option buf "filetype" "markdown")
    (let [win (vim.api.nvim_open_win buf true opts)]
      (vim.keymap.set "n" "q" (fn [] (vim.api.nvim_win_close win false)) {:buffer buf :desc "Close popup"})
      (vim.keymap.set "n" "<Esc>" (fn [] (vim.api.nvim_win_close win false)) {:buffer buf :desc "Close popup"}))))

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

(fn claude-code-rewrite [continue?]
  (let [mode (vim.api.nvim_get_mode)
        selection (if (= mode.mode "v") (get-visual-selection) nil)
        buffer-info (get-buffer-info)]
    
    (when (not selection)
      (vim.notify "No text selected for rewrite" vim.log.levels.WARN)
      (lua "return nil"))
    
    (vim.notify "Claude is rewriting... (Ctrl-C to abort)" vim.log.levels.INFO)
    
    (let [prompt (.. "Please rewrite the following code. Consider improvements for readability, performance, and best practices. Only return the rewritten code, no explanations.\n\nFile: " buffer-info.relative-path "\nLanguage: " buffer-info.filetype "\n\nCode to rewrite:\n" selection)
          escaped-prompt (vim.fn.shellescape prompt)
          continue-flag (if continue? " -c" "")
          allowed-tools "--allowedTools \"Read Edit MultiEdit Glob Grep LS Bash(find:*) Bash(rg:*)\""
          disallowed-tools "--disallowedTools \"Write WebSearch WebFetch NotebookEdit\""
          cmd (.. "claude" continue-flag " " allowed-tools " " disallowed-tools " -p " escaped-prompt)
          result (vim.fn.system cmd)]
      
      (if (= vim.v.shell_error 130)
          (vim.notify "Claude command aborted" vim.log.levels.WARN)
          (let [clean-result (vim.trim result)]
            (if (= clean-result "")
                (vim.notify "Claude returned empty response" vim.log.levels.ERROR)
                (do
                  ;; Replace the selected text with Claude's rewrite
                  (vim.cmd "normal! gvd")
                  (vim.api.nvim_put (vim.split clean-result "\n") "c" true true)
                  (vim.notify "Claude: Code rewritten successfully" vim.log.levels.INFO))))))))

(fn claude-code-append [continue?]
  (let [mode (vim.api.nvim_get_mode)
        selection (if (= mode.mode "v") (get-visual-selection) nil)
        buffer-info (get-buffer-info)]
    
    (when (not selection)
      (vim.notify "No text selected for append" vim.log.levels.WARN)
      (lua "return nil"))
    
    (vim.notify "Claude is adding code... (Ctrl-C to abort)" vim.log.levels.INFO)
    
    (let [prompt (.. "Please add code after the following selection. Consider what would logically follow or enhance this code. Only return the new code to append, no explanations.\n\nFile: " buffer-info.relative-path "\nLanguage: " buffer-info.filetype "\n\nExisting code:\n" selection)
          escaped-prompt (vim.fn.shellescape prompt)
          continue-flag (if continue? " -c" "")
          allowed-tools "--allowedTools \"Read Edit MultiEdit Glob Grep LS Bash(find:*) Bash(rg:*)\""
          disallowed-tools "--disallowedTools \"Write WebSearch WebFetch NotebookEdit\""
          cmd (.. "claude" continue-flag " " allowed-tools " " disallowed-tools " -p " escaped-prompt)
          result (vim.fn.system cmd)]
      
      (if (= vim.v.shell_error 130)
          (vim.notify "Claude command aborted" vim.log.levels.WARN)
          (let [clean-result (vim.trim result)]
            (if (= clean-result "")
                (vim.notify "Claude returned empty response" vim.log.levels.ERROR)
                (do
                  ;; Move cursor to end of selection and append
                  (vim.cmd "normal! gv")
                  (vim.cmd "normal! o")
                  (vim.api.nvim_put (vim.split clean-result "\n") "l" true true)
                  (vim.notify "Claude: Code appended successfully" vim.log.levels.INFO))))))))

(fn claude-code-question [continue?]
  (let [mode (vim.api.nvim_get_mode)
        selection (if (= mode.mode "v") (get-visual-selection) nil)
        buffer-info (get-buffer-info)]
    
    (when (not selection)
      (vim.notify "No text selected for question" vim.log.levels.WARN)
      (lua "return nil"))
    
    (vim.notify "Asking Claude... (Ctrl-C to abort)" vim.log.levels.INFO)
    
    (let [prompt (.. "Please analyze and explain the following code. What does it do, how does it work, and are there any potential issues or improvements?\n\nFile: " buffer-info.relative-path "\nLanguage: " buffer-info.filetype "\n\nCode to analyze:\n" selection)
          escaped-prompt (vim.fn.shellescape prompt)
          continue-flag (if continue? " -c" "")
          allowed-tools "--allowedTools \"Read Glob Grep LS Bash(find:*) Bash(rg:*)\""
          disallowed-tools "--disallowedTools \"Edit MultiEdit Write WebSearch WebFetch NotebookEdit\""
          cmd (.. "claude" continue-flag " " allowed-tools " " disallowed-tools " -p " escaped-prompt)
          result (vim.fn.system cmd)]
      
      (if (= vim.v.shell_error 130)
          (vim.notify "Claude command aborted" vim.log.levels.WARN)
          (let [clean-result (vim.trim result)]
            (if (= clean-result "")
                (vim.notify "Claude returned empty response" vim.log.levels.ERROR)
                (show-popup "Claude Analysis" clean-result)))))))

(fn claude-selection-with-prompt []
  ;; Get visual selection using built-in register
  (let [_ (vim.cmd "normal! \"vy")
        selection (vim.fn.getreg "v")]
    
    (when (or (not selection) (= selection ""))
      (vim.notify "No text selected" vim.log.levels.WARN)
      (lua "return nil"))
    
    ;; Get additional prompt from user
    (let [prompt (vim.fn.input "Additional prompt: ")]
      (when (= prompt "")
        (lua "return nil"))
      
      ;; Get buffer info
      (let [bufname (vim.api.nvim_buf_get_name 0)
            relative-path (vim.fn.fnamemodify bufname ":~:.")
            filetype vim.bo.filetype
            full-prompt (.. "Context: File " relative-path " (" filetype ")\n\nSelected code:\n" selection "\n\nTask: " prompt)]
        
        (vim.notify "Asking Claude..." vim.log.levels.INFO)
        
        ;; Use Claude CLI directly
        (let [escaped-prompt (vim.fn.shellescape full-prompt)
              cmd (.. "claude -p " escaped-prompt)]
          
          ;; Run asynchronously and show result in toast
          (vim.fn.jobstart cmd 
            {:stdout_buffered true
             :on_stdout (fn [_ data]
                          (when (and data (> (length data) 0))
                            (let [response (-> data
                                               (table.concat "\n")
                                               (string.gsub "^%s+" "")
                                               (string.gsub "%s+$" ""))]
                              (when (not= response "")
                                (vim.notify response vim.log.levels.INFO)))))
             :on_stderr (fn [_ data]
                          (when (and data (> (length data) 0))
                            (let [error-msg (table.concat data "\n")]
                              (vim.notify (.. "Claude error: " error-msg) vim.log.levels.ERROR))))}))))))

;; Create user commands
(vim.api.nvim_create_user_command :ClaudeCodeRewrite (fn [] (claude-code-rewrite false)) {:desc "Rewrite selected code with Claude"})
(vim.api.nvim_create_user_command :ClaudeCodeRewriteContinue (fn [] (claude-code-rewrite true)) {:desc "Rewrite selected code with Claude (continue conversation)"})
(vim.api.nvim_create_user_command :ClaudeCodeAppend (fn [] (claude-code-append false)) {:desc "Append code after selection with Claude"})
(vim.api.nvim_create_user_command :ClaudeCodeAppendContinue (fn [] (claude-code-append true)) {:desc "Append code after selection with Claude (continue conversation)"})
(vim.api.nvim_create_user_command :ClaudeCodeQuestion (fn [] (claude-code-question false)) {:desc "Ask Claude about selected code"})
(vim.api.nvim_create_user_command :ClaudeCodeQuestionContinue (fn [] (claude-code-question true)) {:desc "Ask Claude about selected code (continue conversation)"})
(vim.api.nvim_create_user_command :ClaudeSelectionWithPrompt claude-selection-with-prompt {:desc "Ask Claude about selected code with custom prompt"})

{: claude-code-find-file : claude-code-rewrite : claude-code-append : claude-code-question : claude-selection-with-prompt}

(local {: run : volatile-quickfix} (require :user.utils))

(fn add-untracked-to-quickfix []
  ;; Use git repo detection from your existing config
  (local project-path (-> (require :user.find-git-repo)
                          (. :get-path-to-repo)
                          (run (vim.fn.getcwd))))

  (when (not project-path)
    (print "Not in a git repository.")
    (lua :return))

  ;; Run git commands from the git root directory
  (local git-cmd-prefix (.. "cd " (vim.fn.shellescape project-path) " && "))

  ;; Get untracked files relative to git root
  (local untracked-files
    (vim.fn.systemlist (.. git-cmd-prefix "git ls-files --others --exclude-standard")))

  (when (or (not= vim.v.shell_error 0)
            (= (# untracked-files) 0))
    (print "No untracked files found.")
    (lua :return))

  ;; Convert to quickfix items using icollect - use full paths from git root
  (local qf-items
    (icollect [_ file (ipairs untracked-files)]
      {:filename (vim.fs.joinpath project-path file)
       :lnum 1
       :text "New untracked file"}))

  ;; Append to existing quickfix list
  (vim.fn.setqflist qf-items :a)
  (print (.. "Added " (# qf-items) " untracked files to the quickfix list."))
  (volatile-quickfix))

;; Create user command
(vim.api.nvim_create_user_command
  :AddUntracked
  add-untracked-to-quickfix
  {})

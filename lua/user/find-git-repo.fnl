;;; functionality to find the path to a "project",
;;; which means the path to the directory containing
;;; a .git directory (if you are in a git repo).
;;; if not (you're outside any git repo): returns nil


(import-macros {: log} :fnl.macros)


(fn find-path-to-repo [cwd]
  ;; First try to find .git as a directory
  (let [dot-git-dir (vim.fn.finddir ".git" ".;")]
    (if (not= dot-git-dir "")
      ;; Found .git directory (normal repo)
      (let [git-path (vim.fn.fnamemodify dot-git-dir ":h")
            path-to-repo (if (= git-path ".") cwd git-path)]
        (log "found git directory at:" path-to-repo)
        path-to-repo)
      
      ;; No .git directory found, try to find .git file (worktree)
      (let [dot-git-file (vim.fn.findfile ".git" ".;")]
        (if (not= dot-git-file "")
          ;; Found .git file (worktree)
          (let [git-path (vim.fn.fnamemodify dot-git-file ":h")
                path-to-repo (if (= git-path ".") cwd git-path)]
            (log "found git worktree at:" path-to-repo)
            path-to-repo)
          
          ;; No .git found at all
          (do
            (log "not in a git repo")
            nil))))))

{
 :get-path-to-repo
 (fn [cwd]
   (find-path-to-repo cwd))}


;;; functionality to find the path to a "project",
;;; which means the path to the directory containing
;;; a .git directory (if you are in a git repo).
;;; if not (you're outside any git repo): returns nil


(import-macros {: log} :fnl.macros)


(fn find-path-to-repo [cwd]
  (let [dot-git-path (vim.fn.finddir ".git" ".;")
        git-path (vim.fn.fnamemodify dot-git-path ":h")
        path-to-repo (if (= git-path ".") cwd git-path)]

    (if (= dot-git-path "")
      (do
        (log "not in a git repo")
        nil)

      (do
        (log "we've found a project! it's at path:" path-to-repo)
        path-to-repo))))

{
 :get-path-to-repo
 (fn [cwd]
   (find-path-to-repo cwd))}


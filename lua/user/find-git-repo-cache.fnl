;;; functionality to find the path to a "project",
;;; which means the path to the directory containing
;;; a .git directory (if you are in a git repo).
;;; if not (you're outside any git repo): returns nil


(import-macros {: log} :fnl.macros)


;; this is a cached lookup-table that gives the
;; path to the git repo (the directory where .git is located)
;; for any given cwd

;; iff we're in the work tree of a git repo

;; it's set to `false` if we're not

;; if the path doesn't exist in the table,
;; it's because we haven't looked it up yet
(var cwd->project {})


;; are we in a project folder?
(fn cwd-in-git-repo? [cwd]
  (log "checking" cwd "using git rev-parse...")
  (vim.fn.system (.. "cd " cwd " && git rev-parse --is-inside-work-tree"))
  (= 0 vim.v.shell_error))


{
 :get-path-to-repo
 (fn [cwd]
   (let [project-path (. cwd->project cwd)]

     (log "cwd is:" cwd)
     (if (~= project-path nil)

         (do
           ;; TODO: SWR
           (log "path is:" project-path)
           (or project-path nil)) ; nil if we know it doesn't exist

         (do
           (log "we don't know what the path is"
                "because we haven't checked yet")
           (if (cwd-in-git-repo? cwd)

               (let [dot-git-path (vim.fn.finddir ".git" ".;")
                     git-path (vim.fn.fnamemodify dot-git-path ":h")]

                 (log "we're in a project! it's at path:"
                      git-path)
                 (tset cwd->project cwd git-path)
                 git-path)

               (do
                 (log "we're not in a git repo,"
                      "setting to false")
                 (tset cwd->project cwd false)
                 nil))))))}

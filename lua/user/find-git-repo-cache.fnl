;;; functionality to find the path to a "project",
;;; which means the path to the directory containing
;;; a .git directory (if you are in a git repo).
;;; if not (you're outside any git repo): returns nil


;; this is a cached lookup-table that gives the
;; path to the git repo (the directory where .git is located)
;; if we're in the work tree of a git repo

;; it's set to `false` if we're not

;; if the path doesn't exist,
;; it's because we haven't looked it up yet
(var path-to-repo {})


;; are we in a project folder?
(fn git-repo? []
  (vim.fn.system "git rev-parse --is-inside-work-tree")
  (= 0 vim.v.shell_error))


{
 ;; might return nil if we haven't checked,
 ;; or if we know we're not in a git repo
 :get-cached-path
 (fn []
   (let [cwd (vim.fn.getcwd)
         path (. path-to-repo cwd)]
     (or path nil)))

 :get-path-to-repo
 (fn []
   (let [cwd (vim.fn.getcwd)
         path (. path-to-repo cwd)]
     (if (~= path nil)

         ;; path is known; SWR
         (do
           (or path nil)) ; if we know doesn't exist, return nil

         ;; we haven't checked yet
         (if (git-repo?)

             ;; we're in a project!
             (let [dot-git-path (vim.fn.finddir ".git" ".;")
                   git-path (vim.fn.fnamemodify dot-git-path ":h")]

               (tset path-to-repo cwd git-path)
               git-path)

             ;; turns out we're not
             (tset path-to-repo cwd false)
             nil))))}

(local M {})

; this is a cached lookup-table that gives the
; path to the git repo (the directory where .git is located)
; if we're in the work tree of a git repo
; if the path doesn't exist, it could be because we're
; not in a git repo, or because we haven't looked it up yet
(local path-to-repo {})

; sets cwd to be git repository above in file
; tree if it exists, otherwise leaves it as
; current working directory
(fn create-opts []

  (local cwd (vim.fn.getcwd))

  (fn is-git-repo []
    (if (~= nil (. path-to-repo cwd))
      true

      (do
        (vim.fn.system "git rev-parse --is-inside-work-tree")
        (= 0 vim.v.shell_error))))


  (fn get-git-root []
    (let [git-path (. path-to-repo cwd)]

      (if (~= nil git-path)
        git-path

        (let [dot-git-path (vim.fn.finddir ".git" ".;")
              git-path (vim.fn.fnamemodify dot-git-path ":h")]

          (tset path-to-repo cwd git-path)
          git-path))))


  (var opts {})
  (if (is-git-repo)
    (set opts {:cwd (get-git-root)}))
  opts)

; find files relative to git repository
; (in project, in other words)
(fn M.find-files []
  (local builtin (require :telescope.builtin))
  (builtin.find_files (create-opts)))

; live grep relative to git repository
; (in project, in other words)
(fn M.live-grep []
  (local builtin (require :telescope.builtin))
  (builtin.live_grep (create-opts)))

M

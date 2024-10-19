(local {: run} (require :user.utils))

; sets cwd to be git repository above in file
; tree if it exists, otherwise leaves it as
; current working directory
(fn project-path-or-cwd []

  (local cwd (vim.fn.getcwd))
  (local project-path (-> (require :user.find-git-repo)
                          (. :get-path-to-repo)
                          (run cwd)))

  (if project-path
    project-path
    cwd))


{
  ; find files relative to git repository
  ; (in project, in other words)
  :find-files
  (fn []
   (local builtin (require :telescope.builtin))
   (builtin.find_files {:cwd (project-path-or-cwd)}))

  ; find files relative to git repository
  ; (in project, in other words)
  ; but also show hidden files,
  ; but not files ignored by git
  :find-hidden-files
  (fn []
   (local builtin (require :telescope.builtin))
   (builtin.find_files {:cwd (project-path-or-cwd) :hidden true
                        :file_ignore_patterns [".git\\" ".git/"]}))

  ; live grep relative to git repository
  ; (in project, in other words)
  :live-grep
  (fn []
    (local builtin (require :telescope.builtin))
    (builtin.live_grep {:cwd (project-path-or-cwd)}))}

(local {: run} (require :user.utils))

; sets cwd to be git repository above in file
; tree if it exists, otherwise leaves it as
; current working directory
(fn create-opts []

  (local path (-> (require :user.project-repo-cache) (. :get-path-to-repo) (run)))

  (if path
    {:cwd path}
    {}))


{
  ; find files relative to git repository
  ; (in project, in other words)
  :find-files
  (fn []
   (local builtin (require :telescope.builtin))
   (builtin.find_files (create-opts)))

  ; live grep relative to git repository
  ; (in project, in other words)
  :live-grep
  (fn []
    (local builtin (require :telescope.builtin))
    (builtin.live_grep (create-opts)))}

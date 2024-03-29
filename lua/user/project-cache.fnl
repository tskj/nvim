;; this is a cached lookup-table that gives the
;; path to the git repo (the directory where .git is located)
;; if we're in the work tree of a git repo

;; it's set to `false` if we're not

;; if the path doesn't exist,
;; it's because we haven't looked it up yet
(local path-to-repo {})


{
 ;; might return nil if we haven't checked,
 ;; or if we know we're not in a git repo
 :get-cached-path
 (fn [cwd]
   (let [path (. path-to-repo cwd)]
     (or path nil)))

 :get-path-to-repo
 (fn [cwd])}

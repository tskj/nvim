(set vim.opt.guicursor
  ["n-v-c:block"
   "i-ci-ve:hor20"
   "r-cr:hor20"])

(fn pick-random [vs]
  (let [index (math.random (length vs))]
    (. vs index)))

(math.randomseed (os.time))

(local nightfox (require :nightfox))
(nightfox.setup
  {:options {:dim_inactive true}})
(vim.cmd (.. "colorscheme " (pick-random
                              ["nightfox" "duskfox" "nordfox" "terafox" "carbonfox"])))

(set vim.o.guifont "FiraCode Nerd Font:h14")

(set vim.opt.tabstop 2)
(set vim.opt.shiftwidth 2)
(set vim.opt.expandtab true)

; left gutter, I think it's probably best to not waste that space?
; it only appears to work with "no" though, so w/e
(set vim.opt.signcolumn "auto")

(set vim.opt.fileformats ["unix" "dos"])

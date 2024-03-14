(fn pick-random [vs]
  (let [index (math.random (length vs))]
    (. vs index)))

(math.randomseed (os.time))

(local nightfox (require :nightfox))
(nightfox.setup
  {:options {:dim_inactive true}})
(vim.cmd (.. "colorscheme " (pick-random
                              ["nightfox" "duskfox" "nordfox" "terafox" "carbonfox"])))

(fn pick-random [vs]
  (let [index (math.random (length vs))]
    (. vs index)))

(math.randomseed (os.time))

(local nightfox (require :nightfox))
(nightfox.setup
  {:options {:dim_inactive true}})

(local fm (require :fluoromachine))
(fm.setup
  {:glow false
   :theme "fluoromachine"
   :transparent true})

(vim.cmd (.. "colorscheme " (pick-random
                              ["nightfox" "duskfox" "terafox" "carbonfox"
                               "tokyodark"
                               "darkblue"
                               "torte"])))

(local adv (require :advent))
(adv.setup)
; (vim.cmd "colorscheme advent")

(fn pick-random [vs]
  (let [index (math.random (length vs))]
    (. vs index)))

(math.randomseed (os.time))

;; Colorscheme persistence functions
(local colorscheme-state-file (.. (vim.fn.stdpath "data") "/colorscheme-state.json"))
(local available-colorschemes ["nightfox" "duskfox" "terafox" "carbonfox" "darkblue" "torte"])

(fn read-colorscheme-state []
  "Read colorscheme state from file, returns nil if file doesn't exist or invalid"
  (let [file (io.open colorscheme-state-file :r)]
    (if file
      (let [content (file:read "*a")
            _ (file:close)]
        (if (and content (not= content ""))
          (pcall vim.fn.json_decode content)
          nil))
      nil)))

(fn write-colorscheme-state [colorscheme]
  "Write colorscheme and current timestamp to state file"
  (let [state {:colorscheme colorscheme
               :timestamp (os.time)}
        json-content (vim.fn.json_encode state)
        file (io.open colorscheme-state-file :w)]
    (when file
      (file:write json-content)
      (file:close))))

(fn should-reuse-colorscheme? [state]
  "Check if we should reuse the stored colorscheme (within 2 hours)"
  (and state
       state.colorscheme
       state.timestamp
       (< (- (os.time) state.timestamp) 7200))) ; 2 hours = 7200 seconds

(fn get-colorscheme []
  "Get colorscheme - either cached (if recent) or random new one"
  (let [(success state) (read-colorscheme-state)]
    (if (and success (should-reuse-colorscheme? state))
      (do
        (print (.. "Reusing colorscheme: " state.colorscheme))
        state.colorscheme)
      (let [new-colorscheme (pick-random available-colorschemes)]
        (write-colorscheme-state new-colorscheme)
        (print (.. "New random colorscheme: " new-colorscheme))
        new-colorscheme))))

(local nightfox (require :nightfox))
(nightfox.setup
  {:options {:dim_inactive true}})

(local fm (require :fluoromachine))
(fm.setup
  {:glow false
   :theme "fluoromachine"
   :transparent true})

;; Apply the selected colorscheme
(local selected-colorscheme (get-colorscheme))
(vim.cmd (.. "colorscheme " selected-colorscheme))

;; Save colorscheme state when Neovim exits
(vim.api.nvim_create_autocmd "VimLeavePre"
  {:callback (fn []
               (let [current-colorscheme vim.g.colors_name]
                 (when current-colorscheme
                   (write-colorscheme-state current-colorscheme))))})

; (local adv (require :advent))
; (adv.setup)
; (vim.cmd "colorscheme advent")

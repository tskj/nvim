local utils = require("user.utils")

-- get the path to the Neovim configuration directory
local nvim_dir = vim.fn.stdpath("config")

local function open_in_explorer(dir, opts)
  return function()
    if opts and opts.new_tab then
      vim.cmd("tabedit")
    end
    vim.cmd("Oil " .. dir)
  end
end

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Activate Normal mode from Terminal" })
vim.api.nvim_create_autocmd("TermOpen", { pattern = "*", command = "startinsert" }) -- auto insert mode
-- vim.api.nvim_create_autocmd("BufEnter", { pattern = "term://*", command = "startinsert" }) -- auto insert mode
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.keymap.set("n", "<Enter>", function()
      vim.api.nvim_feedkeys("i", "n", false)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
    end, { buffer = true, desc = "Enter terminal mode and send Enter" })
  end,
})

-- these are the regular bindings
vim.keymap.set("n", "<C-Enter>", vim.lsp.buf.code_action, { desc = "Code Actions [LSP]" })
vim.keymap.set("n", "<Enter>", "m`o<Esc>k``", { desc = "Add blank line below" })
vim.keymap.set("n", "<S-Enter>", "m`i<Enter><Esc>``", { desc = "Break line at cursor" })
vim.keymap.set("n", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Move focus to the window to the left" })
vim.keymap.set("n", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Move focus to window below" })
vim.keymap.set("n", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Move focus to window above" })
vim.keymap.set("n", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Move focus to the window to the right" })
vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Move focus to the window to the left" })
vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Move focus to window below" })
vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Move focus to window above" })
-- vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Move focus to the window to the right" }) -- this breaks `clear`
vim.keymap.set("n", "<C-s>", ":w<cr>", { desc = "Save buffer (:w)" })
vim.keymap.set("n", "<C-w>", ":q<cr>", { desc = "Close window (:q)" })
vim.keymap.set("n", "<C-q>", ":bd!<cr>", { desc = "Close buffer (:bd!)" })
vim.keymap.set("t", "<C-w>", function() vim.api.nvim_command("q") end, { desc = "Close window (:q)" })
vim.keymap.set("t", "<C-q>", function() vim.api.nvim_command("bd!") end, { desc = "Close buffer (:bd!)" })
vim.keymap.set("n", "<C-->", "<C-^>", { desc = "Switch to Alternate Buffer (ctrl+dash)" })
vim.keymap.set("t", "<C-->", function() vim.api.nvim_command("buffer #") end, { desc = "Switch to Alternate Buffer (ctrl+dash)" })
vim.keymap.set("n", "<C-Tab>", "<C-^>", { desc = "Switch to Alternate Buffer (ctrl+tab)" })
vim.keymap.set("t", "<C-Tab>", function() vim.api.nvim_command("buffer #") end, { desc = "Switch to Alternate Buffer (ctrl+tab)" })
vim.keymap.set("n", "Z", "zz", { desc = "Center this line" })

local function indent_then_move_cursor(cmd)
  return function()
    local prev_line = vim.api.nvim_get_current_line()
    vim.cmd("normal! " .. cmd)
    local current_line = vim.api.nvim_get_current_line()
    local indents = #current_line - #prev_line
    if indents == 0 then
      return
    end
    if indents < 0 then
      vim.cmd("normal! " .. math.abs(indents) .. "h")
    else
      vim.cmd("normal! " .. indents .. "l")
    end
  end
end
vim.keymap.set("n", "<Tab>", indent_then_move_cursor(">>"), { desc = "Indent line", noremap = true })
vim.keymap.set("n", "<leader><Tab>", "V=", { desc = "Format line", noremap = true })
-- necessary to avoid ctrl+i also meaning tab in normal mode
vim.keymap.set("n", "<C-i>", "<C-i>", { noremap = true })
vim.keymap.set("n", "<S-Tab>", indent_then_move_cursor("<<"), { desc = "Dedent line", noremap = true })

vim.keymap.set({ "n", "t" }, "<C-S-H>", function() vim.api.nvim_command("bp") end, { desc = "Previous Buffer (:bp)" })
vim.keymap.set({ "n", "t" }, "<C-S-L>", function() vim.api.nvim_command("bn") end, { desc = "Next Buffer (:bn)" })
vim.keymap.set({ "n", "t" }, "<C-S-K>", function() vim.api.nvim_command("tabnext") end, { desc = "Next Tab (:tabnext)" })
vim.keymap.set({ "n", "t" }, "<C-S-J>", function() vim.api.nvim_command("tabprev") end, { desc = "Previous Tab (:tabprev)" })

-- Leap
vim.keymap.set({ "n", "v", "o" }, "<leader>gl", "<Plug>(leap-forward)", { desc = "[G]oto [L]eap forwards [Leap]" })
vim.keymap.set({ "n", "v", "o" }, "<leader>gl", "<Plug>(leap-backward)", { desc = "[G]oto [L]eap backwards [Leap]" })

-- Sneak
vim.keymap.set({ "n", "v", "o" }, "gl", "<Plug>Sneak_s", { desc = "[G]oto [L]eap forwards [Sneak]" })
vim.keymap.set({ "n", "v", "o" }, "gL", "<Plug>Sneak_S", { desc = "[G]oto [L]eap backwards [Sneak]" })

--- these are all the spacemacs-like keybindings

-- closes all other windows in current layout
-- if you want to temporarily maximize the window,
-- checkout <leader>lo below
vim.keymap.set({ "n", "v" }, "<leader>wo", ":only<cr>", { desc = "[W]indow [O]nly (close every other window)" })
vim.keymap.set({ "n", "v" }, "<leader>bs", ":enew<cr>", { desc = "[B]uffer [S]cratch (new buffer)" })
vim.keymap.set({ "n", "v" }, "<leader>ev", open_in_explorer(nvim_dir, { new_tab = true }), { desc = "[E]xplore [V]im config (in new tab)" })
vim.keymap.set({ "n", "v" }, "<leader>en", open_in_explorer("~/notes", { new_tab = true }), { desc = "[E]xplore [N]otes (in new tab)" })
vim.keymap.set({ "n", "v" }, "<leader>eh", open_in_explorer("~"), { desc = "[E]xplore [H]ome" })
vim.keymap.set({ "n", "v" }, "<leader>ec", open_in_explorer("~/code"), { desc = "[E]xplore [C]ode" })
vim.keymap.set({ "n", "v" }, "<leader>ep", function()
  local repo = require("user.find-git-repo").get_path_to_repo(vim.fn.getcwd())
  open_in_explorer(repo)()
end, { desc = "[E]xplore [P]roject (according to git repo)" })

vim.keymap.set({ "n", "v" }, "<leader>vd", vim.diagnostic.open_float, { desc = "[V]iew [D]diagnostic" })
vim.keymap.set({ "n", "v" }, "<leader>vh", ":Gitsigns preview_hunk<cr>", { desc = "[V]iew [H]unk" })
vim.keymap.set({ "n", "v" }, "<leader>vi", ":Gitsigns preview_hunk_inline<cr>", { desc = "[V]iew hunk [I]nline" })
vim.keymap.set({ "n", "v" }, "<leader>vb", ":Gitsigns toggle_current_line_blame<cr>", { desc = "[V]iew [B]lame inline (toggle)" })

vim.keymap.set({ "n", "v" }, "<leader>ri", vim.lsp.buf.rename, { desc = "[R]ename [I]dentifier [LSP]" })

-- open file explorer in directory of current file
vim.keymap.set({ "n", "v" }, "<leader>ef", open_in_explorer(""), { desc = "[E]xplore [F]ile (open directory of cwd)" })

-- show current file path in modal
vim.keymap.set({ "n", "v" }, "<leader>fp", function()
  local filepath = vim.fn.expand("%:p")
  local buf = vim.api.nvim_create_buf(false, true)
  local cols = vim.o.columns
  local lines = vim.o.lines
  local width = math.min(string.len(filepath) + 4, cols - 10)
  local opts = {
    relative = "editor",
    width = width,
    height = 1,
    col = math.floor((cols - width) / 2),
    row = math.floor(lines / 2),
    style = "minimal",
    border = "rounded",
  }
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { filepath })
  vim.api.nvim_open_win(buf, true, opts)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>q<cr>", { noremap = true, silent = true })
end, { desc = "[F]ile [P]ath modal" })

-- Notes namespace
local notes_notify = require("mini.notify").make_notify()

local function open_todays_journal()
  local today = os.date("%Y-%m-%d")
  local year = os.date("%Y")
  local journal_dir = "~/notes/.private/journal/" .. year
  -- Ensure the year directory exists
  vim.fn.system("mkdir -p " .. journal_dir)
  vim.cmd(":edit " .. journal_dir .. "/" .. today .. ".norg")
end
vim.keymap.set({ "n", "v" }, "<leader>nj", open_todays_journal, { desc = "[N]otes [J]ournal (open today's entry)" })

vim.keymap.set({ "n", "v" }, "<leader>ns", function()
  notes_notify("running save script...", vim.log.levels.INFO)
  vim.fn.jobstart({ vim.fn.expand("~/notes") .. "/.bin/save.sh" }, {
    cwd = vim.fn.expand("~/notes"),
    on_stdout = function(_, data, _)
      for _, line in ipairs(data) do
        if line and line ~= "" then
          vim.schedule(function() notes_notify(line, vim.log.levels.INFO) end)
        end
      end
    end,
    on_stderr = function(_, data, _)
      for _, line in ipairs(data) do
        if line and line ~= "" then
          vim.schedule(function() notes_notify(line, vim.log.levels.ERROR) end)
        end
      end
    end,
    on_exit = function(_, code, _)
      vim.schedule(function()
        if code == 0 then
          notes_notify("notes saved successfully!", vim.log.levels.INFO)
        else
          notes_notify("save script failed!", vim.log.levels.ERROR)
        end
      end)
    end,
  })
end, { desc = "[N]otes [S]ave (run save script)" })

vim.keymap.set({ "n", "v" }, "<leader>np", function()
  notes_notify("pulling notes from git...", vim.log.levels.INFO)
  vim.fn.jobstart({ "git", "pull" }, {
    cwd = vim.fn.expand("~/notes"),
    on_stdout = function(_, data, _)
      for _, line in ipairs(data) do
        if line and line ~= "" then
          vim.schedule(function() notes_notify(line, vim.log.levels.INFO) end)
        end
      end
    end,
    on_stderr = function(_, data, _)
      for _, line in ipairs(data) do
        if line and line ~= "" then
          vim.schedule(function() notes_notify(line, vim.log.levels.WARN) end)
        end
      end
    end,
    on_exit = function(_, code, _)
      vim.schedule(function()
        if code == 0 then
          notes_notify("notes pulled successfully!", vim.log.levels.INFO)
        else
          notes_notify("git pull failed!", vim.log.levels.ERROR)
        end
      end)
    end,
  })
end, { desc = "[N]otes [P]ull from git" })

vim.keymap.set({ "n", "v" }, "<leader>nn", open_in_explorer("~/notes"), { desc = "[N]otes [N]avigate (open notes directory)" })

-- neogit
vim.keymap.set({ "n", "v" }, "<leader>gs", ":Neogit<cr>", { desc = "[G]it [S]tage [Neogit]" })
vim.keymap.set({ "n", "v" }, "<leader>gc", ":Neogit commit<cr>", { desc = "[G]it [C]ommit [Neogit]" })

-- lazygit
vim.keymap.set({ "n", "v" }, "<leader>gl", ":LazyGit<cr>", { desc = "[G]it [L]azy" })

-- git quickfix
vim.keymap.set({ "n", "v" }, "<leader>gq", utils.gitsigns_quickfix_volatile, { desc = "[G]it [Q]uickfix" })

-- open terminal (moved from <leader>a* to avoid claudecode.nvim conflicts)
vim.keymap.set({ "n", "v" }, "<leader>tc", vim.cmd.terminal, { desc = "[T]erminal [C]ommand line" })
vim.keymap.set({ "n", "v" }, "<leader>tp", function() vim.cmd.terminal("powershell.exe") end, { desc = "[T]erminal [P]owershell" })
vim.keymap.set({ "n", "v" }, "<leader>tl", function() vim.cmd.terminal("wsl.exe zsh") end, { desc = "[T]erminal [L]inux (wsl zsh)" })
vim.keymap.set({ "n", "v" }, "<leader>tb", function() vim.cmd.terminal("wsl.exe bash") end, { desc = "[T]erminal [B]ash (wsl bash)" })

vim.keymap.set({ "n", "v" }, "<leader>wr", vim.cmd.WinResizerStartResize, { desc = "[W]indow [R]esize" })
vim.keymap.set({ "n", "v" }, "<leader>wD", ":q!<cr>", { desc = "[W]indow [D]elete force (:q!)" })

-- buffer home, go to start screen! (mini.starter)
vim.keymap.set({ "n", "v" }, "<leader>bh", function() require("mini.starter").open() end, { desc = "[B]uffer [H]ome [Mini.Starter]" })
vim.keymap.set({ "n", "v" }, "<leader>bD", ":bd!<cr>", { desc = "[B]uffer [D]elete force (:bd!)" })

-- layout/layer stuff, which are neovim _tabs_
vim.keymap.set({ "n", "v" }, "<leader>lh", function()
  vim.cmd.tabnew()
  require("mini.starter").open()
end, { desc = "[L]ayer [H]ome (open new tab with Starter page)" })
vim.keymap.set({ "n", "v" }, "<leader>ln", vim.cmd.tabnext, { desc = "[L]ayer [N]ext (next tab)" })
vim.keymap.set({ "n", "v" }, "<leader>lp", vim.cmd.tabprev, { desc = "[L]ayer [P]rev (prev tab)" })
vim.keymap.set({ "n", "v" }, "<leader>lc", vim.cmd.tabclose, { desc = "[L]ayer [C]lose (close tab)" })
vim.keymap.set({ "n", "v" }, "<leader>lo", function()
  local buffer_name = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  local cursor_position = vim.api.nvim_win_get_cursor(0)
  vim.cmd.tabedit(buffer_name)
  vim.api.nvim_win_set_cursor(0, cursor_position)
end, { desc = "[L]ayer [O]nly (open buffer in new tab to 'maximize' it)" })
vim.keymap.set({ "n", "v" }, "<leader>l<", function() vim.cmd.tabmove("-1") end, { desc = "[L]ayer [<]eft (move tab left)" })
vim.keymap.set({ "n", "v" }, "<leader>l>", function() vim.cmd.tabmove("+1") end, { desc = "[L]ayer [>]ight (move tab right)" })

-- quit everything so the (plain Lua) config reloads on next start
-- (sadly there's no way to restart neovim automatically)
vim.keymap.set({ "n", "v" }, "<leader>qr", function()
  vim.cmd("qa!")
end, { desc = "[Q]uit [R]eload (quit all, restart to reload config)" })

vim.keymap.set({ "n", "v" }, "<leader>u", function() require("undotree").toggle() end, { desc = "[U]ndo tree " })

-- spacemacs basics
vim.keymap.set("n", "<leader>bd", ":bd<cr>", { desc = "[B]uffer [D]elete" })
vim.keymap.set("n", "<leader>bn", ":bn<cr>", { desc = "[B]uffer [N]ext" })
vim.keymap.set("n", "<leader>bp", ":bp<cr>", { desc = "[B]uffer [P]rev" })
vim.keymap.set("n", "<leader>bR", ":e<cr>", { desc = "[B]uffer [R]eload" })
vim.keymap.set("n", "<leader>fs", ":w<cr>", { desc = "[F]ile [S]ave (same as ctrl+s)" })
vim.keymap.set("n", "<leader>fS", ":wa<cr>", { desc = "[F]ile [S]ave all" })
vim.keymap.set("n", "<leader>qq", ":qa<cr>", { desc = "[Q]uit all" })
vim.keymap.set("n", "<leader>qQ", ":qa!<cr>", { desc = "[Q]uit all force" })
vim.keymap.set("n", "<leader>qs", ":xa<cr>", { desc = "[Q]uit [S]ave" })
vim.keymap.set("n", "<leader>w-", ":sp<cr>", { desc = "[W]indow [-]plit horizontally" })
vim.keymap.set("n", "<leader>w/", ":vsp<cr>", { desc = "[W]indow [/]plit vertically" })
vim.keymap.set("n", "<leader>w=", "<C-W>=", { desc = "[W]indow [=]qualize" })
vim.keymap.set("n", "<leader>wd", ":q<cr>", { desc = "[W]indow [D]elete" })
vim.keymap.set("n", "<leader>wn", "<C-W><C-W>", { desc = "[W]indow [N]ext (focus)" })
vim.keymap.set("n", "<leader>wh", "<cmd>wincmd h<cr>", { desc = "Move focus to the window to the left" })
vim.keymap.set("n", "<leader>wj", "<cmd>wincmd j<cr>", { desc = "Move focus to window below" })
vim.keymap.set("n", "<leader>wk", "<cmd>wincmd k<cr>", { desc = "Move focus to window above" })
vim.keymap.set("n", "<leader>wl", "<cmd>wincmd l<cr>", { desc = "Move focus to the window to the right" })

-- telescope
local builtin = require("telescope.builtin")
local telescope_config = require("user.telescope-config")
vim.keymap.set({ "n", "v" }, "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set({ "n", "v" }, "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set({ "n", "v" }, "<leader>sf", telescope_config.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set({ "n", "v" }, "<leader>sa", telescope_config.find_hidden_files, { desc = "[S]earch [A]ll files (includes hidden but hides .gitignore)" })
vim.keymap.set({ "n", "v" }, "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
vim.keymap.set({ "n", "v" }, "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set({ "n", "v" }, "<leader>sg", telescope_config.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set({ "n", "v" }, "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set({ "n", "v" }, "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set({ "n", "v" }, "<leader>s.", builtin.oldfiles, { desc = "[S]earch Recent Files ('.' for repeat)" })
vim.keymap.set({ "n", "v" }, "<leader>sb", builtin.buffers, { desc = "[S]earch [B]uffers (existing)" })
vim.keymap.set({ "n", "v" }, "<leader>sj", builtin.current_buffer_fuzzy_find, { desc = "[S]earch [J]ump: fuzzily search in current buffer" })
vim.keymap.set({ "n", "v" }, "<leader>s/", function()
  builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
end, { desc = "[S]earch [/] in Open Files" })
vim.keymap.set({ "n", "v" }, "<leader>sv", function()
  builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [V]im config files" })
vim.keymap.set({ "n", "v" }, "<leader>st", ":TodoTelescope<cr>", { desc = "[S]earch [T]odos" })
vim.keymap.set({ "n", "v" }, "<leader>sm", builtin.marks, { desc = "[S]earch [M]arks" })
vim.keymap.set({ "n", "v" }, "<leader>sq", builtin.quickfix, { desc = "[S]earch [Q]quickfix list" })
vim.keymap.set({ "n", "v" }, "<leader>sc", builtin.git_commits, { desc = "[S]earch [C]ommits (git)" })
vim.keymap.set({ "n", "v" }, "<leader>su", function() require("telescope").extensions.undo.undo() end, { desc = "[S]earch [U]ndo tree" })

vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "[G]oto [D]efinition [LSP]" })
vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "[G]oto [R]eferences [LSP]" })
vim.keymap.set("n", "gi", builtin.lsp_implementations, { desc = "[G]oto [I]mplementations [LSP]" })
vim.keymap.set("n", "go", builtin.lsp_type_definitions, { desc = "[G]oto Type Definitions [LSP]" })

-- fzf-lua
local fzf_lua = require("fzf-lua")
vim.keymap.set({ "n", "v" }, "<leader>zh", fzf_lua.help_tags, { desc = "[Z]earch [H]elp [fzf-lua]" })
vim.keymap.set({ "n", "v" }, "<leader>zk", fzf_lua.keymaps, { desc = "[Z]earch [K]eymaps [fzf-lua]" })
vim.keymap.set({ "n", "v" }, "<leader>zf", fzf_lua.files, { desc = "[Z]earch [F]iles [fzf-lua]" })
vim.keymap.set({ "n", "v" }, "<leader>zz", fzf_lua.builtin, { desc = "[Z]earch F[Z]F-lua builtins [fzf-lua]" })
vim.keymap.set({ "n", "v" }, "<leader>zw", fzf_lua.grep_cword, { desc = "[Z]earch current [W]ord [fzf-lua]" })
vim.keymap.set({ "n", "v" }, "<leader>zv", fzf_lua.grep_visual, { desc = "[Z]earch [V]isual selection [fzf-lua]" })
vim.keymap.set({ "n", "v" }, "<leader>zg", fzf_lua.live_grep, { desc = "[Z]earch by [G]rep [fzf-lua]" })
vim.keymap.set({ "n", "v" }, "<leader>zd", fzf_lua.diagnostics_workspace, { desc = "[Z]earch [D]iagnostics [fzf-lua]" })
vim.keymap.set({ "n", "v" }, "<leader>zr", fzf_lua.resume, { desc = "[Z]earch [R]esume [fzf-lua]" })
vim.keymap.set({ "n", "v" }, "<leader>z.", fzf_lua.oldfiles, { desc = "[Z]earch Recent Files ('.' for repeat) [fzf-lua]" })
vim.keymap.set({ "n", "v" }, "<leader>zb", fzf_lua.buffers, { desc = "[Z]earch [B]uffers (existing) [fzf-lua]" })
vim.keymap.set({ "n", "v" }, "<leader>zj", fzf_lua.blines, { desc = "[/] Fuzzily search in current buffer [fzf-lua]" })
vim.keymap.set({ "n", "v" }, "<leader>z/", fzf_lua.lines, { desc = "[Z]earch [/] in Open Files [fzf-lua]" })
vim.keymap.set({ "n", "v" }, "<leader>zv", function()
  fzf_lua.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[Z]earch [V]im config files [fzf-lua]" })
vim.keymap.set({ "n", "v" }, "<leader>zm", fzf_lua.marks, { desc = "[Z]earch [M]arks [fzf-lua]" })
vim.keymap.set({ "n", "v" }, "<leader>zq", fzf_lua.quickfix, { desc = "[Z]earch [Q]quickfix list [fzf-lua]" })
vim.keymap.set({ "n", "v" }, "<leader>zc", fzf_lua.git_commits, { desc = "[Z]earch [C]ommits (git) [fzf-lua]" })

-- command-with-unchanged-unnamed-register
local function uur(cmd)
  return function()
    local old_unnamed = vim.fn.getreg('"')
    vim.api.nvim_command("normal! " .. cmd)
    vim.fn.setreg('"', old_unnamed)
  end
end
-- also writes to register r as if it was unnamed
local function uur_2(cmd, r)
  return function()
    local old_unnamed = vim.fn.getreg('"')
    vim.api.nvim_command("normal! " .. cmd)
    local new_unnamed = vim.fn.getreg('"')
    vim.fn.setreg(r, new_unnamed)
    vim.fn.setreg('"', old_unnamed)
  end
end

-- these are modifications of existing behavior, from primeagen
vim.keymap.set("n", "d", '"_d', { silent = true }) -- don't overwrite register when deleting
vim.keymap.set("n", "D", '"_D', { silent = true }) -- don't overwrite register when deleting
vim.keymap.set("v", "d", '"_d', { silent = true }) -- don't overwrite register when deleting in visual mode
vim.keymap.set("v", "D", '"_D', { silent = true }) -- don't overwrite register when deleting in visual mode
vim.keymap.set("v", "p", uur("p"), { silent = true }) -- don't overwrite register when pasting
vim.keymap.set("v", "P", "p", { silent = true }) -- overwrite register when pasting over stuff using shift P

-- special cut tool
vim.keymap.set("n", "<leader>d", "d", { silent = true, desc = "[C]lipboard [Y]ank (y)" })
vim.keymap.set("n", "<leader>D", "D", { silent = true, desc = "[C]lipboard [P]aste (p)" })
vim.keymap.set("v", "<leader>d", "d", { silent = true, desc = "[C]lipboard [D]elete (d)" })
vim.keymap.set("v", "<leader>D", "d", { silent = true, desc = "[C]lipboard [Y]ank (Y)" })

-- clipboard integrations

local function visual_mode_char(motion_type)
  if motion_type == "line" then
    return "V"
  elseif motion_type == "block" then
    return "\22" -- ctrl-v
  else
    return "v"
  end
end

-- operator pending mode for y and d
vim.g.clipboard_yank_operator = function(motion_type)
  local old_reg_content = vim.fn.getreg('"')
  local old_reg_type = vim.fn.getregtype('"')
  local v = visual_mode_char(motion_type)
  vim.cmd("normal! `[" .. v .. '`]"+y')
  vim.fn.setreg('"', old_reg_content, old_reg_type)
end

vim.keymap.set("n", "<leader>cy", function()
  vim.o.operatorfunc = "v:lua.vim.g.clipboard_yank_operator"
  return "g@"
end, { silent = true, desc = "[C]lipboard [Y]ank (y)", expr = true })

vim.g.clipboard_append_operator = function(motion_type)
  local old_reg_content = vim.fn.getreg('"')
  local old_reg_type = vim.fn.getregtype('"')
  local current_clipboard = vim.fn.getreg("+")
  local v = visual_mode_char(motion_type)
  vim.cmd("normal! `[" .. v .. "`]y")
  local yanked_text = vim.fn.getreg('"')
  vim.fn.setreg("+", current_clipboard .. yanked_text)
  vim.fn.setreg('"', old_reg_content, old_reg_type)
end

vim.keymap.set("n", "<leader>ce", function()
  vim.o.operatorfunc = "v:lua.vim.g.clipboard_append_operator"
  return "g@"
end, { silent = true, desc = "[C]lipboard [E]xtend (append)", expr = true })

vim.g.clipboard_delete_operator = function(motion_type)
  local old_reg_content = vim.fn.getreg('"')
  local old_reg_type = vim.fn.getregtype('"')
  local v = visual_mode_char(motion_type)
  vim.cmd("normal! `[" .. v .. '`]"+d')
  vim.fn.setreg('"', old_reg_content, old_reg_type)
end

vim.keymap.set("n", "<leader>cd", function()
  vim.o.operatorfunc = "v:lua.vim.g.clipboard_delete_operator"
  return "g@"
end, { silent = true, desc = "[C]lipboard [D]elete (d)", expr = true })

vim.keymap.set("n", "<leader>cp", uur('"+p'), { silent = true, desc = "[C]lipboard [P]aste (p)" })
vim.keymap.set("n", "<leader>cY", uur('"+y$'), { silent = true, desc = "[C]lipboard [Y]ank (Y)" })
vim.keymap.set("n", "<leader>cP", uur('"+P'), { silent = true, desc = "[C]lipboard [P]aste (P)" })
vim.keymap.set("n", "<leader>cD", uur('"+D'), { silent = true, desc = "[C]lipboard [D]elete (D)" })

vim.keymap.set("v", "<leader>cy", uur('"+y'), { silent = true, desc = "[C]lipboard [Y]ank (y)" })
vim.keymap.set("v", "<leader>ce", function()
  local old_unnamed = vim.fn.getreg('"')
  local current_clipboard = vim.fn.getreg("+")
  vim.cmd("normal! y")
  local yanked_text = vim.fn.getreg('"')
  vim.fn.setreg("+", current_clipboard .. yanked_text)
  vim.fn.setreg('"', old_unnamed)
end, { silent = true, desc = "[C]lipboard [E]xtend (append)" })
vim.keymap.set("v", "<leader>cY", uur('"+y'), { silent = true, desc = "[C]lipboard [Y]ank (Y)" })
vim.keymap.set("v", "<leader>cP", uur_2('"+p', "+"), { silent = true, desc = "[C]lipboard [P]aste (P)" })
vim.keymap.set("v", "<leader>cD", uur('"+D'), { silent = true, desc = "[C]lipboard [D]elete (D)" })
vim.keymap.set("v", "<leader>cp", uur('"+p'), { silent = true, desc = "[C]lipboard [P]aste (p)" })
vim.keymap.set("v", "<leader>cd", uur('"+d'), { silent = true, desc = "[C]lipbaord [D]elete (d)" })

--- jump commands

local m_type = nil
local m_timer = nil

local function register(type)
  m_type = type
  if m_timer then
    vim.fn.timer_stop(m_timer)
  end
  m_timer = vim.fn.timer_start(100000, function()
    m_type = nil
    m_timer = nil
  end)
end

vim.keymap.set("n", ";", function()
  if m_type == "q" then
    vim.cmd("normal ]q")
  elseif m_type == "l" then
    vim.cmd("normal ]l")
  elseif m_type == "d" then
    vim.cmd("normal ]d")
  elseif m_type == "t" then
    vim.cmd("normal ]t")
  else
    vim.cmd("normal! ;")
  end
end)

vim.keymap.set("n", ",", function()
  if m_type == "q" then
    vim.cmd("normal [q")
  elseif m_type == "l" then
    vim.cmd("normal [l")
  elseif m_type == "d" then
    vim.cmd("normal [d")
  elseif m_type == "t" then
    vim.cmd("normal [t")
  else
    vim.cmd("normal! ,")
  end
end)

-- quickfix and location list
vim.keymap.set("n", "<leader>qo", ":copen<cr>", { desc = "[Q]uickfix [O]pen" })
vim.keymap.set("n", "[q", function()
  register("q")
  vim.api.nvim_command("cprev")
end, { desc = "[[]ump [Q]uickfix previous (:cprev)" })
vim.keymap.set("n", "]q", function()
  register("q")
  vim.api.nvim_command("cnext")
end, { desc = "[]]ump [Q]uickfix next (:cnext)" })
vim.keymap.set("n", "[l", function()
  register("l")
  vim.api.nvim_command("lprev")
end, { desc = "[[]ump [L]ocation previous (:lprev)" })
vim.keymap.set("n", "]l", function()
  register("l")
  vim.api.nvim_command("lnext")
end, { desc = "[]]ump [L]ocation next (:lnext)" })

-- diagnostics
vim.keymap.set("n", "[d", function()
  register("d")
  vim.diagnostic.goto_prev()
end, { desc = "[[]ump [D]iagnostic previous" })
vim.keymap.set("n", "]d", function()
  register("d")
  vim.diagnostic.goto_next()
end, { desc = "[]]ump [D]iagnostic next" })

-- todos
vim.keymap.set("n", "[t", function()
  register("t")
  require("todo-comments").jump_prev()
end, { desc = "[[]ump [T]odo previous" })
vim.keymap.set("n", "]t", function()
  register("t")
  require("todo-comments").jump_next()
end, { desc = "[]]ump [T]odo next" })

-- refactors
vim.keymap.set("v", "<leader>ref", ":Refactor extract ", { desc = "[R]efactor [E]xtract [F]unction" })
vim.keymap.set("v", "<leader>rff", ":Refactor extract_to_file ", { desc = "[R]efactor to [F]ile: [F]unction" })
vim.keymap.set("v", "<leader>rev", ":Refactor extract_var ", { desc = "[R]efactor [E]xtract [V]variable" })
vim.keymap.set("n", "<leader>rIf", ":Refactor inline_func<cr>", { desc = "[R]efactor [I]nline [F]unctino" })
vim.keymap.set({ "n", "v" }, "<leader>rIv", ":Refactor inline_var<cr>", { desc = "[R]efactor [I]nline [V]ariable" })
vim.keymap.set("n", "<leader>reb", ":Refactor extract_block<cr>", { desc = "[R]efactor [E]xtract [B]lock" })
vim.keymap.set("n", "<leader>rfb", ":Refactor extract_block<cr>", { desc = "[R]efactor to [F]ile: [B]lock" })
vim.keymap.set({ "n", "v" }, "<leader>rs", function()
  require("telescope").extensions.refactoring.refactors()
end, { desc = "[R]efactor [S]earch (telescope)" })
-- debug
vim.keymap.set("n", "<leader>rdf", function() require("refactoring").debug.printf() end, { desc = "[R]efactor [D]debug [F]unction" })
vim.keymap.set({ "n", "v" }, "<leader>rdp", function() require("refactoring").debug.print_var() end, { desc = "[R]efactor [D]debug [P]rint (variable or selection)" })
vim.keymap.set({ "n", "v" }, "<leader>rdc", function() require("refactoring").debug.cleanup({}) end, { desc = "[R]efactor [D]debug [C]lean" })

-- Quickfix window specific keybindings
vim.g.delete_selected_quickfix_items = function()
  local qf_list = vim.fn.getqflist()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local new_list = {}
  for i, item in ipairs(qf_list) do
    if not (start_line <= i and i <= end_line) then
      table.insert(new_list, item)
    end
  end
  vim.fn.setqflist(new_list)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "<CR>", "<CR><cmd>cclose<cr>", { buffer = true, desc = "Jump to item and close quickfix" })
    vim.keymap.set({ "v", "x" }, "d", ":<C-u>lua vim.g.delete_selected_quickfix_items()<CR>", { buffer = true, desc = "Delete selected quickfix items" })
    vim.keymap.set({ "v", "x" }, "D", ":<C-u>lua vim.g.delete_selected_quickfix_items()<CR>", { buffer = true, desc = "Delete selected quickfix items" })
  end,
})

-- AI
vim.keymap.set({ "n", "v" }, "gpr", ":GpRewrite<cr>", { desc = "[G][P][R]ewrite" })
vim.keymap.set({ "n", "v" }, "gpa", ":GpAppend<cr>", { desc = "[G][P][A]ppend" })
vim.keymap.set({ "n", "v" }, "gpc", ":GpChatNew<cr>", { desc = "[G][P][C]hat new" })
vim.keymap.set({ "n", "v" }, "gpt", ":GpChatToggle<cr>", { desc = "[G][P][T]oggle (chat)" })
vim.keymap.set({ "n", "v" }, "gpq", ":GpPopup<cr>", { desc = "[G][P][Q]uestion (popup)" })

vim.keymap.set("n", "gpf", "<cmd>ClaudeCodeFind<cr>", { desc = "[G][P][F]ind file (Claude)" })
vim.keymap.set("n", "gpF", "<cmd>ClaudeCodeFindPrompt<cr>", { desc = "[G][P][F]ind file with prompt (Claude)" })

-- Custom Claude prompt with selection
vim.keymap.set("v", "<leader>ap", "<cmd>ClaudeSelectionWithPrompt<cr>", { desc = "[A]I [P]rompt with selection" })

-- Toggle formatoptions 'l' flag (prevents reformatting existing long lines)
vim.keymap.set({ "n", "v" }, "<leader>tw", function()
  local current_fo = vim.api.nvim_get_option_value("formatoptions", { scope = "local" })
  if string.find(current_fo, "l") then
    vim.opt_local.formatoptions:remove("l")
    print("Removed 'l' flag - will reformat existing long lines")
  else
    vim.opt_local.formatoptions:append("l")
    print("Added 'l' flag - won't reformat existing long lines")
  end
end, { desc = "[T]oggle [W]rap behavior (formatoptions 'l' flag)" })

local _local_1_ = require("user.utils")
local run = _local_1_["run"]
local nvim_dir = vim.fn.stdpath("config")
local function open_in_explorer(dir)
  local function _2_()
    vim.cmd(("cd " .. dir))
    return vim.cmd(("Oil " .. dir))
  end
  return _2_
end
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", {desc = "Activate Normal mode from Terminal"})
vim.api.nvim_create_autocmd("TermOpen", {pattern = "*", command = "startinsert"})
vim.api.nvim_create_autocmd("BufEnter", {pattern = "term://*", command = "startinsert"})
vim.keymap.set("n", "<C-Enter>", vim.lsp.buf.code_action, {desc = "Code Actions [LSP]"})
vim.keymap.set("n", "<Enter>", "m`o<Esc>k``", {desc = "Add blank line below"})
vim.keymap.set("n", "<S-Enter>", "m`i<Enter><Esc>``", {desc = "Break line at cursor"})
vim.keymap.set("n", "<C-h>", "<cmd>wincmd h<cr>", {desc = "Move focus to the window to the left"})
vim.keymap.set("n", "<C-j>", "<cmd>wincmd j<cr>", {desc = "Move focus to window below"})
vim.keymap.set("n", "<C-k>", "<cmd>wincmd k<cr>", {desc = "Move focus to window above"})
vim.keymap.set("n", "<C-l>", "<cmd>wincmd l<cr>", {desc = "Move focus to the window to the right"})
vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", {desc = "Move focus to the window to the left"})
vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", {desc = "Move focus to window below"})
vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", {desc = "Move focus to window above"})
vim.keymap.set("n", "<C-s>", ":w<cr>", {desc = "Save buffer (:w)"})
vim.keymap.set("n", "<C-w>", ":q<cr>", {desc = "Close window (:q)"})
vim.keymap.set("n", "<C-q>", ":bd!<cr>", {desc = "Close buffer (:bd!)"})
local function _3_()
  return vim.api.nvim_command("q")
end
vim.keymap.set("t", "<C-w>", _3_, {desc = "Close window (:q)"})
local function _4_()
  return vim.api.nvim_command("bd!")
end
vim.keymap.set("t", "<C-q>", _4_, {desc = "Close buffer (:bd!)"})
vim.keymap.set("n", "<C-->", "<C-^>", {desc = "Switch to Alternate Buffer (ctrl+dash)"})
local function _5_()
  return vim.api.nvim_command("buffer #")
end
vim.keymap.set("t", "<C-->", _5_, {desc = "Switch to Alternate Buffer (ctrl+dash)"})
vim.keymap.set("n", "<C-Tab>", "<C-^>", {desc = "Switch to Alternate Buffer (ctrl+tab)"})
local function _6_()
  return vim.api.nvim_command("buffer #")
end
vim.keymap.set("t", "<C-Tab>", _6_, {desc = "Switch to Alternate Buffer (ctrl+tab)"})
local function indent_then_move_cursor(cmd)
  local function _7_()
    local prev_line = vim.api.nvim_get_current_line()
    vim.cmd(("normal! " .. cmd))
    local current_line = vim.api.nvim_get_current_line()
    local indents = (#current_line - #prev_line)
    if (indents == 0) then
      return
    else
    end
    if (indents < 0) then
      return vim.cmd(("normal! " .. math.abs(indents) .. "h"))
    else
      return vim.cmd(("normal! " .. indents .. "l"))
    end
  end
  return _7_
end
vim.keymap.set("n", "<Tab>", indent_then_move_cursor(">>"), {desc = "Indent line", noremap = true})
vim.keymap.set("n", "<leader><Tab>", "V=", {desc = "Format line", noremap = true})
vim.keymap.set("n", "<C-i>", "<C-i>", {noremap = true})
vim.keymap.set("n", "<S-Tab>", indent_then_move_cursor("<<"), {desc = "Dedent line", noremap = true})
local function _10_()
  return vim.api.nvim_command(":bp")
end
vim.keymap.set({"n", "t"}, "<C-S-H>", _10_, {desc = "Previous Buffer (:bp)"})
local function _11_()
  return vim.api.nvim_command(":bn")
end
vim.keymap.set({"n", "t"}, "<C-S-L>", _11_, {desc = "Next Buffer (:bn)"})
local function _12_()
  return vim.api.nvim_command(":tabnext")
end
vim.keymap.set({"n", "t"}, "<C-S-K>", _12_, {desc = "Next Tab (:tabnext)"})
local function _13_()
  return vim.api.nvim_command(":tabprev")
end
vim.keymap.set({"n", "t"}, "<C-S-J>", _13_, {desc = "Previous Tab (:tabprev)"})
vim.keymap.set({"n", "x", "o"}, "<leader>gj", "<Plug>(leap-forward)", {desc = "[G]oto [J]ump forwards [Leap]"})
vim.keymap.set({"n", "x", "o"}, "<leader>gJ", "<Plug>(leap-backward)", {desc = "[G]oto [J]ump backwards [Leap]"})
vim.keymap.set({"n", "x", "o"}, "gj", "<Plug>Sneak_s", {desc = "[G]oto [J]ump forwards [Sneak]"})
vim.keymap.set({"n", "x", "o"}, "gJ", "<Plug>Sneak_S", {desc = "[G]oto [J]ump backwards [Sneak]"})
vim.keymap.set({"n", "v"}, "<leader>wo", ":only<cr>", {desc = "[W]indow [O]nly (close every other window)"})
vim.keymap.set({"n", "v"}, "<leader>bs", ":enew<cr>", {desc = "[B]uffer [S]cratch (new buffer)"})
vim.keymap.set({"n", "v"}, "<leader>en", open_in_explorer(nvim_dir), {desc = "[E]xplore [N]eovim config files"})
vim.keymap.set({"n", "v"}, "<leader>eh", open_in_explorer("~"), {desc = "[E]xplore [H]ome"})
vim.keymap.set({"n", "v"}, "<leader>ec", open_in_explorer("~/code"), {desc = "[E]xplore [C]ode"})
local function _14_()
  return run(open_in_explorer(run(require("user.find-git-repo")["get-path-to-repo"], vim.fn.getcwd())))
end
vim.keymap.set({"n", "v"}, "<leader>ep", _14_, {desc = "[E]xplore [P]roject (according to git repo)"})
vim.keymap.set({"n", "v"}, "<leader>vd", vim.diagnostic.open_float, {desc = "[V]iew [D]diagnostic"})
vim.keymap.set({"n", "v"}, "<leader>ri", vim.lsp.buf.rename, {desc = "[R]ename [I]dentifier [LSP]"})
vim.keymap.set({"n", "v"}, "<leader>ef", open_in_explorer(""), {desc = "[E]xplore [F]ile (open directory of cwd)"})
vim.keymap.set({"n", "v"}, "<leader>gs", ":Neogit<cr>", {desc = "[G]it [S]tage [Neogit]"})
vim.keymap.set({"n", "v"}, "<leader>gc", ":Neogit commit<cr>", {desc = "[G]it [C]ommit [Neogit]"})
vim.keymap.set({"n", "v"}, "<leader>ac", vim.cmd.terminal, {desc = "[A]pplication [C]ommand line (opens terminal)"})
local function _15_()
  return vim.cmd.terminal("powershell.exe")
end
vim.keymap.set({"n", "v"}, "<leader>ap", _15_, {desc = "[A]pplication [P]owershell"})
local function _16_()
  return vim.cmd.terminal("wsl.exe zsh")
end
vim.keymap.set({"n", "v"}, "<leader>al", _16_, {desc = "[A]pplication [L]inux (wsl zsh)"})
local function _17_()
  return vim.cmd.terminal("wsl.exe bash")
end
vim.keymap.set({"n", "v"}, "<leader>ab", _17_, {desc = "[A]pplication [B]ash (wsl bash)"})
vim.keymap.set({"n", "v"}, "<leader>wr", vim.cmd.WinResizerStartResize, {desc = "[W]indow [R]esize"})
vim.keymap.set({"n", "v"}, "<leader>wD", ":q!<cr>", {desc = "[W]indow [D]elete force (:q!)"})
local function _18_()
  return run(require("mini.starter").open)
end
vim.keymap.set({"n", "v"}, "<leader>bh", _18_, {desc = "[B]uffer [H]ome [Mini.Starter]"})
vim.keymap.set({"n", "v"}, "<leader>bD", ":bd!<cr>", {desc = "[B]uffer [D]elete force (:bd!)"})
local function _19_()
  vim.cmd.tabnew()
  return run(require("mini.starter").open)
end
vim.keymap.set({"n", "v"}, "<leader>lh", _19_, {desc = "[L]ayer [H]ome (open new tab with Starter page)"})
vim.keymap.set({"n", "v"}, "<leader>ln", vim.cmd.tabnext, {desc = "[L]ayer [N]ext (next tab)"})
vim.keymap.set({"n", "v"}, "<leader>lp", vim.cmd.tabprev, {desc = "[L]ayer [P]rev (prev tab)"})
vim.keymap.set({"n", "v"}, "<leader>lc", vim.cmd.tabclose, {desc = "[L]ayer [C]lose (close tab)"})
local function _20_()
  local buffer_name = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  local cursor_position = vim.api.nvim_win_get_cursor(0)
  vim.cmd.tabedit(buffer_name)
  return vim.api.nvim_win_set_cursor(0, cursor_position)
end
vim.keymap.set({"n", "v"}, "<leader>lo", _20_, {desc = "[L]ayer [O]nly (open buffer in new tab to 'maximize' it)"})
local function _21_()
  return vim.cmd.tabmove("-1")
end
vim.keymap.set({"n", "v"}, "<leader>l<", _21_, {desc = "[L]ayer [<]eft (move tab left)"})
local function _22_()
  return vim.cmd.tabmove("+1")
end
vim.keymap.set({"n", "v"}, "<leader>l>", _22_, {desc = "[L]ayer [>]ight (move tab right)"})
local function _23_()
  vim.cmd(("cd " .. nvim_dir))
  vim.cmd.terminal("make")
  local function _24_()
    return vim.cmd("qa!")
  end
  return vim.api.nvim_create_autocmd("TermClose", {pattern = "term://*make", callback = _24_})
end
vim.keymap.set({"n", "v"}, "<leader>qr", _23_, {desc = "[Q]uit [R]eload (compiles fennel and quits)"})
local function _25_()
  return run(require("undotree").toggle)
end
vim.keymap.set({"n", "v"}, "<leader>u", _25_, {desc = "[U]ndo tree "})
vim.keymap.set("n", "<leader>bd", ":bd<cr>", {desc = "[B]uffer [D]elete"})
vim.keymap.set("n", "<leader>bn", ":bn<cr>", {desc = "[B]uffer [N]ext"})
vim.keymap.set("n", "<leader>bp", ":bp<cr>", {desc = "[B]uffer [P]rev"})
vim.keymap.set("n", "<leader>bR", ":e<cr>", {desc = "[B]uffer [R]eload"})
vim.keymap.set("n", "<leader>fs", ":w<cr>", {desc = "[F]ile [S]ave (same as ctrl+s)"})
vim.keymap.set("n", "<leader>fS", ":wa<cr>", {desc = "[F]ile [S]ave all"})
vim.keymap.set("n", "<leader>qq", ":qa<cr>", {desc = "[Q]uit all"})
vim.keymap.set("n", "<leader>qQ", ":qa!<cr>", {desc = "[Q]uit all force"})
vim.keymap.set("n", "<leader>qs", ":xa<cr>", {desc = "[Q]uit [S]ave"})
vim.keymap.set("n", "<leader>w-", ":sp<cr>", {desc = "[W]indow [-]plit horizontally"})
vim.keymap.set("n", "<leader>w/", ":vsp<cr>", {desc = "[W]indow [/]plit vertically"})
vim.keymap.set("n", "<leader>w=", "<C-W>=", {desc = "[W]indow [=]qualize"})
vim.keymap.set("n", "<leader>wd", ":q<cr>", {desc = "[W]indow [D]elete"})
vim.keymap.set("n", "<leader>wn", "<C-W><C-W>", {desc = "[W]indow [N]ext (focus)"})
vim.keymap.set("n", "<leader>wh", "<cmd>wincmd h<cr>", {desc = "Move focus to the window to the left"})
vim.keymap.set("n", "<leader>wj", "<cmd>wincmd j<cr>", {desc = "Move focus to window below"})
vim.keymap.set("n", "<leader>wk", "<cmd>wincmd k<cr>", {desc = "Move focus to window above"})
vim.keymap.set("n", "<leader>wl", "<cmd>wincmd l<cr>", {desc = "Move focus to the window to the right"})
local builtin = require("telescope.builtin")
vim.keymap.set({"n", "v"}, "<leader>sh", builtin.help_tags, {desc = "[S]earch [H]elp"})
vim.keymap.set({"n", "v"}, "<leader>sk", builtin.keymaps, {desc = "[S]earch [K]eymaps"})
vim.keymap.set({"n", "v"}, "<leader>sf", require("user.telescope-config")["find-files"], {desc = "[S]earch [F]iles"})
vim.keymap.set({"n", "v"}, "<leader>ss", builtin.builtin, {desc = "[S]earch [S]elect Telescope"})
vim.keymap.set({"n", "v"}, "<leader>sw", builtin.grep_string, {desc = "[S]earch current [W]ord"})
vim.keymap.set({"n", "v"}, "<leader>sg", require("user.telescope-config")["live-grep"], {desc = "[S]earch by [G]rep"})
vim.keymap.set({"n", "v"}, "<leader>sd", builtin.diagnostics, {desc = "[S]earch [D]iagnostics"})
vim.keymap.set({"n", "v"}, "<leader>sr", builtin.resume, {desc = "[S]earch [R]esume"})
vim.keymap.set({"n", "v"}, "<leader>s.", builtin.oldfiles, {desc = "[S]earch Recent Files ('.' for repeat)"})
vim.keymap.set({"n", "v"}, "<leader>sb", builtin.buffers, {desc = "[S]earch [B]uffers (existing)"})
vim.keymap.set({"n", "v"}, "<leader>sj", builtin.current_buffer_fuzzy_find, {desc = "[S]earch [J]ump: fuzzily search in current buffer"})
local function _26_()
  return builtin.live_grep({grep_open_files = true, prompt_title = "Live Grep in Open Files"})
end
vim.keymap.set({"n", "v"}, "<leader>s/", _26_, {desc = "[S]earch [/] in Open Files"})
local function _27_()
  return builtin.find_files({cwd = vim.fn.stdpath("config")})
end
vim.keymap.set({"n", "v"}, "<leader>sn", _27_, {desc = "[S]earch [N]eovim config files"})
vim.keymap.set({"n", "v"}, "<leader>st", ":TodoTelescope<cr>", {desc = "[S]earch [T]odos"})
vim.keymap.set({"n", "v"}, "<leader>sm", builtin.marks, {desc = "[S]earch [M]arks"})
vim.keymap.set({"n", "v"}, "<leader>sq", builtin.quickfix, {desc = "[S]earch [Q]quickfix list"})
vim.keymap.set({"n", "v"}, "<leader>sc", builtin.git_commits, {desc = "[S]earch [C]ommits (git)"})
local function _28_()
  run(require("telescope").extensions.undo.undo)
  return {desc = "[S]earch [U]ndo tree"}
end
vim.keymap.set({"n", "v"}, "<leader>su", _28_)
vim.keymap.set("n", "gd", builtin.lsp_definitions, {desc = "[G]oto [D]efinition [LSP]"})
vim.keymap.set("n", "gr", builtin.lsp_references, {desc = "[G]oto [R]eferences [LSP]"})
vim.keymap.set("n", "gi", builtin.lsp_implementations, {desc = "[G]oto [I]mplementations [LSP]"})
vim.keymap.set("n", "go", builtin.lsp_type_definitions, {desc = "[G]oto Type Definitions [LSP]"})
local fzf_lua = require("fzf-lua")
vim.keymap.set({"n", "v"}, "<leader>zh", fzf_lua.help_tags, {desc = "[Z]earch [H]elp [fzf-lua]"})
vim.keymap.set({"n", "v"}, "<leader>zk", fzf_lua.keymaps, {desc = "[Z]earch [K]eymaps [fzf-lua]"})
vim.keymap.set({"n", "v"}, "<leader>zf", fzf_lua.files, {desc = "[Z]earch [F]iles [fzf-lua]"})
vim.keymap.set({"n", "v"}, "<leader>zz", fzf_lua.builtin, {desc = "[Z]earch F[Z]F-lua builtins [fzf-lua]"})
vim.keymap.set({"n", "v"}, "<leader>zw", fzf_lua.grep_cword, {desc = "[Z]earch current [W]ord [fzf-lua]"})
vim.keymap.set({"n", "v"}, "<leader>zv", fzf_lua.grep_visual, {desc = "[Z]earch [V]isual selection [fzf-lua]"})
vim.keymap.set({"n", "v"}, "<leader>zg", fzf_lua.live_grep, {desc = "[Z]earch by [G]rep [fzf-lua]"})
vim.keymap.set({"n", "v"}, "<leader>zd", fzf_lua.diagnostics_workspace, {desc = "[Z]earch [D]iagnostics [fzf-lua]"})
vim.keymap.set({"n", "v"}, "<leader>zr", fzf_lua.resume, {desc = "[Z]earch [R]esume [fzf-lua]"})
vim.keymap.set({"n", "v"}, "<leader>z.", fzf_lua.oldfiles, {desc = "[Z]earch Recent Files ('.' for repeat) [fzf-lua]"})
vim.keymap.set({"n", "v"}, "<leader>zb", fzf_lua.buffers, {desc = "[Z]earch [B]uffers (existing) [fzf-lua]"})
vim.keymap.set({"n", "v"}, "<leader>zj", fzf_lua.blines, {desc = "[/] Fuzzily search in current buffer [fzf-lua]"})
vim.keymap.set({"n", "v"}, "<leader>z/", fzf_lua.lines, {desc = "[Z]earch [/] in Open Files [fzf-lua]"})
local function _29_()
  return fzf_lua.files({cwd = vim.fn.stdpath("config")}, {desc = "[Z]earch [N]eovim config files [fzf-lua]"})
end
vim.keymap.set({"n", "v"}, "<leader>zn", _29_)
vim.keymap.set({"n", "v"}, "<leader>zm", fzf_lua.marks, {desc = "[Z]earch [M]arks [fzf-lua]"})
vim.keymap.set({"n", "v"}, "<leader>zq", fzf_lua.quickfix, {desc = "[Z]earch [Q]quickfix list [fzf-lua]"})
vim.keymap.set({"n", "v"}, "<leader>zc", fzf_lua.git_commits, {desc = "[Z]earch [C]ommits (git) [fzf-lua]"})
vim.keymap.set("n", "D", "\"_D", {silent = true})
vim.keymap.set("v", "p", "\"_dP", {silent = true})
vim.keymap.set("v", "d", "\"_d", {silent = true})
vim.keymap.set("v", "D", "\"_d", {silent = true})
vim.keymap.set("n", "X", "D", {silent = true})
vim.keymap.set("v", "P", "p", {silent = true})
local function command_with_unchanged_unnamed_register(cmd)
  local function _30_()
    local old_unnamed = vim.fn.getreg("\"")
    vim.api.nvim_command(("normal! " .. cmd))
    return vim.fn.setreg("\"", old_unnamed)
  end
  return _30_
end
vim.keymap.set("n", "<leader>cy", "\"+y", {silent = true, desc = "[C]lipboard [Y]ank (y)"})
vim.keymap.set("n", "<leader>cp", "\"+p", {silent = true, desc = "[C]lipboard [P]aste (p)"})
vim.keymap.set("n", "<leader>cd", "\"+d", {silent = true, desc = "[C]lipboard [D]elete (d)"})
vim.keymap.set("n", "<leader>cY", "\"+Y", {silent = true, desc = "[C]lipboard [Y]ank (Y)"})
vim.keymap.set("n", "<leader>cP", "\"+P", {silent = true, desc = "[C]lipboard [P]aste (P)"})
vim.keymap.set("n", "<leader>cD", "\"+D", {silent = true, desc = "[C]lipboard [D]elete (D)"})
vim.keymap.set("v", "<leader>cY", "\"+y", {silent = true, desc = "[C]lipboard [Y]ank (Y)"})
vim.keymap.set("v", "<leader>cP", "\"+p", {silent = true, desc = "[C]lipboard [P]aste (P)"})
vim.keymap.set("v", "<leader>cD", "\"+d", {silent = true, desc = "[C]lipboard [D]elete (D)"})
vim.keymap.set("v", "<leader>cy", command_with_unchanged_unnamed_register("\"+y"), {silent = true, desc = "[C]lipboard [Y]ank (y)"})
vim.keymap.set("v", "<leader>cp", "\"_d\"+P", {silent = true, desc = "[C]lipboard [P]aste (p)"})
vim.keymap.set("v", "<leader>cd", command_with_unchanged_unnamed_register("\"+d"), {silent = true, desc = "[C]lipbaord [D]elete (d)"})
local m_type = nil
local function register(type)
  m_type = type
  local function _31_()
    m_type = nil
    return nil
  end
  return vim.defer_fn(_31_, 100000)
end
local function _32_()
  if (m_type == "q") then
    return vim.cmd("normal ]q")
  elseif (m_type == "l") then
    return vim.cmd("normal ]l")
  elseif (m_type == "d") then
    return vim.cmd("normal ]d")
  elseif (m_type == "t") then
    return vim.cmd("normal ]t")
  else
    local _ = m_type
    return vim.cmd("normal! ;")
  end
end
vim.keymap.set("n", ";", _32_)
local function _34_()
  if (m_type == "q") then
    return vim.cmd("normal [q")
  elseif (m_type == "l") then
    return vim.cmd("normal [l")
  elseif (m_type == "d") then
    return vim.cmd("normal [d")
  elseif (m_type == "t") then
    return vim.cmd("normal [t")
  else
    local _ = m_type
    return vim.cmd("normal! ,")
  end
end
vim.keymap.set("n", ",", _34_)
local function _36_()
  register("q")
  return vim.api.nvim_command("cprev")
end
vim.keymap.set("n", "[q", _36_, {desc = "[[]ump [Q]uickfix previous (:cprev)"})
local function _37_()
  register("q")
  return vim.api.nvim_command("cnext")
end
vim.keymap.set("n", "]q", _37_, {desc = "[]]ump [Q]uickfix next (:cnext)"})
local function _38_()
  register("l")
  return vim.api.nvim_command("lprev")
end
vim.keymap.set("n", "[l", _38_, {desc = "[[]ump [L]ocation previous (:lprev)"})
local function _39_()
  register("l")
  return vim.api.nvim_command("lnext")
end
vim.keymap.set("n", "]l", _39_, {desc = "[]]ump [L]ocation next (:lnext)"})
local function _40_()
  register("d")
  return vim.diagnostic.goto_prev()
end
vim.keymap.set("n", "[d", _40_, {desc = "[[]ump [D]iagnostic previous"})
local function _41_()
  register("d")
  return vim.diagnostic.goto_next()
end
vim.keymap.set("n", "]d", _41_, {desc = "[]]ump [D]iagnostic next"})
local function _42_()
  register("t")
  return run(require("todo-comments").jump_prev)
end
vim.keymap.set("n", "[t", _42_, {desc = "[[]ump [T]odo previous"})
local function _43_()
  register("t")
  return run(require("todo-comments").jump_next)
end
return vim.keymap.set("n", "]t", _43_, {desc = "[]]ump [T]odo next"})
vim.g.mapleader = " "
do
  local f = vim.fn
  local install_path = (f.stdpath("data") .. "/site/pack/packer/start/packer.nvim")
  if (f.empty(f.glob(install_path)) > 0) then
    f.system({"git", "clone", "https://github.com/wbthomason/packer.nvim", install_path})
  else
  end
end
local packer = require("packer")
local startup = packer.startup
local function _2_()
  use("altercation/vim-colors-solarized")
  use("mhartington/oceanic-next")
  use("rakr/vim-one")
  use("morhetz/gruvbox")
  use("jimmay5469/vim-spacemacs")
  use("hecal3/vim-leader-guide")
  local function _3_()
    return vim.fn("fzf#install")()
  end
  use({"junegunn/fzf", run = _3_})
  return use("ctrlpvim/ctrlp.vim")
end
return startup(_2_)

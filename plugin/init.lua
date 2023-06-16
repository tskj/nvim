-- Make sure packer is installed
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- Plugins
require('packer').startup(function()

  use 'altercation/vim-colors-solarized'
  use 'mhartington/oceanic-next'
  use 'rakr/vim-one'
  use 'morhetz/gruvbox'

  use 'jimmay5469/vim-spacemacs'
  use 'hecal3/vim-leader-guide'
  -- use 'preservim/nerdtree'
  use { 'junegunn/fzf', run = function() vim.fn['fzf#install']() end }
  use 'ctrlpvim/ctrlp.vim'

  use 'rktjmp/hotpot.nvim'
end)

-- Mappings for vim-leader-guide
vim.api.nvim_set_keymap('n', '<leader>', ':<C-U>LeaderGuide \'<SPACE>\'<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<leader>', ':<C-U>LeaderGuideVisual \'<SPACE>\'<CR>', {noremap = true, silent = true})

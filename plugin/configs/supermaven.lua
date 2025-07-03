-- [nfnl] plugin/configs/supermaven.fnl
local _local_1_ = require("user.utils")
local run = _local_1_["run"]
return run(require("supermaven-nvim").setup, {disable_inline_completion = true})

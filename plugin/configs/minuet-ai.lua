-- [nfnl] plugin/configs/minuet-ai.fnl
local _local_1_ = require("user.utils")
local run = _local_1_["run"]
return run(require("minuet").setup, {provider_options = {codestral = {optional = {max_tokens = 256, stop = {"\n\n"}}}}, filetypes = {exclude = {"norg", "markdown", "org", "text", "gitcommit"}}})

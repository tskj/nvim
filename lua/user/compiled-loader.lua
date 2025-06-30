-- Custom loader to prioritize dot-prefixed compiled lua files
-- This allows require("user.utils") to find ".utils.lua" before "utils.lua"

local function setup_compiled_loader()
  -- Cache runtime paths at setup time to avoid fast event issues
  local runtime_paths = vim.api.nvim_list_runtime_paths()

  local function compiled_loader(module_name)
    local parts = {}
    for part in module_name:gmatch('[^%.]+') do
      table.insert(parts, part)
    end

    -- Search for .filename.lua version first using cached paths
    for _, rtp_path in ipairs(runtime_paths) do
      local dir_parts = table.concat(parts, '/', 1, #parts - 1)
      local filename = '.' .. parts[#parts] .. '.lua'
      local compiled_path = rtp_path .. '/lua/' ..
          (dir_parts ~= '' and dir_parts .. '/' or '') .. filename

      local file = io.open(compiled_path, 'r')
      if file then
        file:close()
        return loadfile(compiled_path), compiled_path
      end
    end

    return nil     -- Let other loaders try
  end

  -- Insert at position 1 for highest priority
  table.insert(package.loaders, 1, compiled_loader)
end

-- Auto-setup when required
setup_compiled_loader()

return {
  setup_compiled_loader = setup_compiled_loader
}


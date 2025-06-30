--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
-- Lua Library inline imports
local function __TS__StringAccess(self, index)
    if index >= 0 and index < #self then
        return string.sub(self, index + 1, index + 1)
    end
end

local function __TS__StringSubstring(self, start, ____end)
    if ____end ~= ____end then
        ____end = 0
    end
    if ____end ~= nil and start > ____end then
        start, ____end = ____end, start
    end
    if start >= 0 then
        start = start + 1
    else
        start = 1
    end
    if ____end ~= nil and ____end < 0 then
        ____end = 0
    end
    return string.sub(self, start, ____end)
end

local __TS__StringSplit
do
    local sub = string.sub
    local find = string.find
    function __TS__StringSplit(source, separator, limit)
        if limit == nil then
            limit = 4294967295
        end
        if limit == 0 then
            return {}
        end
        local result = {}
        local resultIndex = 1
        if separator == nil or separator == "" then
            for i = 1, #source do
                result[resultIndex] = sub(source, i, i)
                resultIndex = resultIndex + 1
            end
        else
            local currentPos = 1
            while resultIndex <= limit do
                local startPos, endPos = find(source, separator, currentPos, true)
                if not startPos then
                    break
                end
                result[resultIndex] = sub(source, currentPos, startPos - 1)
                resultIndex = resultIndex + 1
                currentPos = endPos + 1
            end
            if resultIndex <= limit then
                result[resultIndex] = sub(source, currentPos)
            end
        end
        return result
    end
end

local function __TS__ArrayFindIndex(self, callbackFn, thisArg)
    for i = 1, #self do
        if callbackFn(thisArg, self[i], i - 1, self) then
            return i - 1
        end
    end
    return -1
end

local function __TS__ArrayFilter(self, callbackfn, thisArg)
    local result = {}
    local len = 0
    for i = 1, #self do
        if callbackfn(thisArg, self[i], i - 1, self) then
            len = len + 1
            result[len] = self[i]
        end
    end
    return result
end

local function __TS__CountVarargs(...)
    return select("#", ...)
end

local function __TS__ArraySplice(self, ...)
    local args = {...}
    local len = #self
    local actualArgumentCount = __TS__CountVarargs(...)
    local start = args[1]
    local deleteCount = args[2]
    if start < 0 then
        start = len + start
        if start < 0 then
            start = 0
        end
    elseif start > len then
        start = len
    end
    local itemCount = actualArgumentCount - 2
    if itemCount < 0 then
        itemCount = 0
    end
    local actualDeleteCount
    if actualArgumentCount == 0 then
        actualDeleteCount = 0
    elseif actualArgumentCount == 1 then
        actualDeleteCount = len - start
    else
        actualDeleteCount = deleteCount or 0
        if actualDeleteCount < 0 then
            actualDeleteCount = 0
        end
        if actualDeleteCount > len - start then
            actualDeleteCount = len - start
        end
    end
    local out = {}
    for k = 1, actualDeleteCount do
        local from = start + k
        if self[from] ~= nil then
            out[k] = self[from]
        end
    end
    if itemCount < actualDeleteCount then
        for k = start + 1, len - actualDeleteCount do
            local from = k + actualDeleteCount
            local to = k + itemCount
            if self[from] then
                self[to] = self[from]
            else
                self[to] = nil
            end
        end
        for k = len - actualDeleteCount + itemCount + 1, len do
            self[k] = nil
        end
    elseif itemCount > actualDeleteCount then
        for k = len - actualDeleteCount, start + 1, -1 do
            local from = k + actualDeleteCount
            local to = k + itemCount
            if self[from] then
                self[to] = self[from]
            else
                self[to] = nil
            end
        end
    end
    local j = start + 1
    for i = 3, actualArgumentCount do
        self[j] = args[i]
        j = j + 1
    end
    for k = #self, len - actualDeleteCount + itemCount + 1, -1 do
        self[k] = nil
    end
    return out
end

local function __TS__ArrayEvery(self, callbackfn, thisArg)
    for i = 1, #self do
        if not callbackfn(thisArg, self[i], i - 1, self) then
            return false
        end
    end
    return true
end
-- End of Lua Library inline imports
local ____exports = {}
--- precondition: cursor_index is within string
____exports.calculate_text_object = function(____, s, cursor_index)
    if cursor_index < 0 then
        error("cursor_index not in string", 0)
    end
    if cursor_index >= #s then
        error("cursor_index not in string", 0)
    end
    local state = "regular"
    local nesting_level = 0
    local have_found_cursor = false
    local relevant_list_separator_index = nil
    local cursor_is_in_state = nil
    local cursor_nesting_level = nesting_level
    local end_index = nil
    local has_trailing_space
    do
        local i = 0
        while i <= #s do
            if end_index ~= nil then
                break
            end
            if not have_found_cursor then
                if i == cursor_index then
                    have_found_cursor = true
                    cursor_is_in_state = state
                    cursor_nesting_level = nesting_level
                end
            end
            repeat
                local ____switch9 = state
                local ____cond9 = ____switch9 == "regular"
                if ____cond9 then
                    do
                        if i == #s then
                            if not have_found_cursor then
                                error("precondition broken", 0)
                            end
                            end_index = i
                            has_trailing_space = __TS__StringAccess(s, i - 1) == " "
                        end
                        if __TS__StringAccess(s, i) == "'" then
                            state = "single-quote-string"
                        end
                        if __TS__StringAccess(s, i) == "\"" then
                            state = "double-quote-string"
                        end
                        local is_c_style_line_comment = __TS__StringSubstring(s, i, i + 2) == "//"
                        local is_lua_style_line_comment = __TS__StringSubstring(s, i, i + 2) == "--"
                        local is_python_style_line_comment = __TS__StringAccess(s, i) == "#"
                        if is_c_style_line_comment or is_lua_style_line_comment or is_python_style_line_comment then
                            if have_found_cursor then
                                end_index = i
                                has_trailing_space = __TS__StringAccess(s, i - 1) == " "
                            else
                                error("cursor is in line comment", 0)
                            end
                        end
                        local is_closing_paren = __TS__StringAccess(s, i) == ")" or __TS__StringAccess(s, i) == "]"
                        if is_closing_paren then
                            if nesting_level == cursor_nesting_level then
                                local have_passed_cursor = have_found_cursor and i ~= cursor_index
                                if have_passed_cursor then
                                    end_index = i
                                    has_trailing_space = __TS__StringAccess(s, i - 1) == " "
                                end
                            else
                                nesting_level = nesting_level - 1
                            end
                        end
                        if __TS__StringAccess(s, i) == "(" or __TS__StringAccess(s, i) == "[" then
                            nesting_level = nesting_level + 1
                        end
                        if __TS__StringAccess(s, i) == "," and have_found_cursor and nesting_level == cursor_nesting_level then
                            relevant_list_separator_index = i
                            if __TS__StringAccess(s, i + 1) == " " then
                                has_trailing_space = true
                                i = i + 1
                                while __TS__StringAccess(s, i) == " " do
                                    i = i + 1
                                end
                                end_index = i
                            else
                                has_trailing_space = false
                                end_index = i + 1
                            end
                        end
                        break
                    end
                end
                ____cond9 = ____cond9 or ____switch9 == "single-quote-string"
                if ____cond9 then
                    do
                        if i == #s then
                            error("no support for multiline single-quote strings", 0)
                        end
                        if __TS__StringSubstring(s, i, i + 2) == "\\'" then
                            i = i + 1
                        elseif __TS__StringAccess(s, i) == "'" then
                            state = "regular"
                        end
                        break
                    end
                end
                ____cond9 = ____cond9 or ____switch9 == "double-quote-string"
                if ____cond9 then
                    do
                        if i == #s then
                            error("no support for multiline double-quote strings", 0)
                        end
                        if __TS__StringSubstring(s, i, i + 2) == "\\\"" then
                            i = i + 1
                        elseif __TS__StringAccess(s, i) == "\"" then
                            state = "regular"
                        end
                        break
                    end
                end
            until true
            i = i + 1
        end
    end
    if end_index == nil then
        error("expected to have found end_index", 0)
    end
    nesting_level = cursor_nesting_level
    if relevant_list_separator_index ~= nil then
        state = "regular"
    else
        if cursor_is_in_state == nil then
            error("cursor has no state but we need one because there is no list separator (we're on the last element in a list)", 0)
        end
        state = cursor_is_in_state
    end
    local start_index = nil
    do
        local i = relevant_list_separator_index or cursor_index
        while i >= 0 do
            if start_index ~= nil then
                break
            end
            repeat
                local ____switch41 = state
                local ____cond41 = ____switch41 == "regular"
                if ____cond41 then
                    do
                        if __TS__StringAccess(s, i) == "'" then
                            state = "single-quote-string"
                        end
                        if __TS__StringAccess(s, i) == "\"" then
                            state = "double-quote-string"
                        end
                        if __TS__StringAccess(s, i) == ")" or __TS__StringAccess(s, i) == "]" then
                            nesting_level = nesting_level + 1
                        end
                        local is_opening_paren = __TS__StringAccess(s, i) == "(" or __TS__StringAccess(s, i) == "["
                        if is_opening_paren then
                            if nesting_level == cursor_nesting_level then
                                if has_trailing_space then
                                    while __TS__StringAccess(s, i + 1) == " " do
                                        i = i + 1
                                    end
                                end
                                start_index = i + 1
                            else
                                nesting_level = nesting_level - 1
                            end
                        end
                        if __TS__StringAccess(s, i) == "," and i ~= relevant_list_separator_index then
                            if nesting_level == cursor_nesting_level then
                                if relevant_list_separator_index == nil then
                                    start_index = i
                                else
                                    if has_trailing_space then
                                        while __TS__StringAccess(s, i + 1) == " " do
                                            i = i + 1
                                        end
                                    end
                                    start_index = i + 1
                                end
                            end
                        end
                        break
                    end
                end
                ____cond41 = ____cond41 or ____switch41 == "single-quote-string"
                if ____cond41 then
                    do
                        if __TS__StringSubstring(s, i - 1, i + 1) == "\\'" then
                            i = i - 1
                        elseif __TS__StringAccess(s, i) == "'" then
                            state = "regular"
                        end
                        break
                    end
                end
                ____cond41 = ____cond41 or ____switch41 == "double-quote-string"
                if ____cond41 then
                    do
                        if __TS__StringSubstring(s, i - 1, i + 1) == "\\\"" then
                            i = i - 1
                        elseif __TS__StringAccess(s, i) == "\"" then
                            state = "regular"
                        end
                        break
                    end
                end
            until true
            i = i - 1
        end
    end
    if start_index == nil then
        start_index = 0
    end
    return {start_index, end_index}
end

local function select_text_object()
    local line = vim.fn.getline(".")
    local cursor_index = vim.fn.col(".") - 1

    local text_range = ____exports.calculate_text_object(nil, line, cursor_index)
    if text_range then
        local start_index, end_index = text_range[1], text_range[2]
        vim.fn.setpos(".", {0, vim.fn.line("."), start_index + 1})
        vim.cmd("normal! v")
        vim.fn.setpos(".", {0, vim.fn.line("."), end_index + 1})
    else
        print("Text object not found")
    end
end

-- Mapping for visual mode selection
vim.keymap.set("x", "il", select_text_object, { desc = "Select inside list item" })
vim.keymap.set("o", "il", function()
    select_text_object()
    vim.cmd("normal! gv")
end, { desc = "Operate inside list item" })


return ____exports


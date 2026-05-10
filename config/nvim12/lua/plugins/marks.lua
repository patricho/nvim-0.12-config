local M = {}

-- Return a list of uppercase mark letters (A-Z) that are currently set,
-- in alphabetical order.
local function set_upper_marks()
    local result = {}
    local info = vim.fn.getmarklist()
    for i = 65, 90 do -- A=65 … Z=90
        local ch = string.char(i)
        for _, m in ipairs(info) do
            if m.mark == "'" .. ch then
                table.insert(result, ch)
                break
            end
        end
    end
    return result
end

-- Return the index into `set_marks` of the uppercase mark that sits on the
-- current line in the current buffer, or nil if there is none.
local function mark_idx_on_current_line(set_marks)
    local cur_line = vim.fn.line(".")
    local cur_buf  = vim.api.nvim_get_current_buf()
    local info     = vim.fn.getmarklist()
    for idx, ch in ipairs(set_marks) do
        for _, m in ipairs(info) do
            if m.mark == "'" .. ch
                and m.pos[1] == cur_buf
                and m.pos[2] == cur_line then
                return idx
            end
        end
    end
    return nil
end

-- Return all set uppercase marks that live in the current buffer, as a list of
-- { ch, line } tables sorted by line number.
local function marks_in_current_buf()
    local cur_buf = vim.api.nvim_get_current_buf()
    local info    = vim.fn.getmarklist()
    local result  = {}
    for i = 65, 90 do
        local ch = string.char(i)
        for _, m in ipairs(info) do
            if m.mark == "'" .. ch and m.pos[1] == cur_buf then
                table.insert(result, { ch = ch, line = m.pos[2] })
                break
            end
        end
    end
    table.sort(result, function(a, b) return a.line < b.line end)
    return result
end

-- Toggle: set the next available uppercase mark on the current line, or
-- delete the existing one if the line already carries an uppercase mark.
function M.toggle()
    local cur_line = vim.fn.line(".")
    local cur_buf  = vim.api.nvim_get_current_buf()
    local info     = vim.fn.getmarklist()

    for i = 65, 90 do
        local ch = string.char(i)
        for _, m in ipairs(info) do
            if m.mark == "'" .. ch
                and m.pos[1] == cur_buf
                and m.pos[2] == cur_line then
                vim.cmd("delmarks " .. ch)
                vim.notify("Deleted mark " .. ch, vim.log.levels.INFO)
                return
            end
        end
    end

    -- No uppercase mark on this line — set the next available one.
    for i = 65, 90 do
        local ch   = string.char(i)
        local taken = false
        for _, m in ipairs(info) do
            if m.mark == "'" .. ch then
                taken = true
                break
            end
        end
        if not taken then
            vim.cmd("mark " .. ch)
            vim.notify("Set mark " .. ch, vim.log.levels.INFO)
            return
        end
    end

    vim.notify("All uppercase marks (A-Z) are in use", vim.log.levels.WARN)
end

-- Next: if the current line has an uppercase mark, step to the next one
-- alphabetically (cycling). Otherwise jump to the nearest mark ahead in the
-- current buffer by line number. Falls back to the first mark globally.
function M.next()
    local marks = set_upper_marks()
    if #marks == 0 then
        vim.notify("No global marks set", vim.log.levels.WARN)
        return
    end

    -- On a marked line: alphabetical step takes priority.
    local idx = mark_idx_on_current_line(marks)
    if idx then
        vim.cmd("normal! '" .. marks[(idx % #marks) + 1])
        return
    end

    -- Not on a marked line: nearest mark below in this buffer.
    local cur_line  = vim.fn.line(".")
    local buf_marks = marks_in_current_buf()
    for _, bm in ipairs(buf_marks) do
        if bm.line > cur_line then
            vim.cmd("normal! '" .. bm.ch)
            return
        end
    end

    -- Nothing below in this buffer: jump to the first mark globally.
    vim.cmd("normal! '" .. marks[1])
end

-- Prev: if the current line has an uppercase mark, step to the previous one
-- alphabetically (cycling). Otherwise jump to the nearest mark behind in the
-- current buffer by line number. Falls back to the last mark globally.
function M.prev()
    local marks = set_upper_marks()
    if #marks == 0 then
        vim.notify("No global marks set", vim.log.levels.WARN)
        return
    end

    -- On a marked line: alphabetical step takes priority.
    local idx = mark_idx_on_current_line(marks)
    if idx then
        vim.cmd("normal! '" .. marks[((idx - 2) % #marks) + 1])
        return
    end

    -- Not on a marked line: nearest mark above in this buffer.
    local cur_line  = vim.fn.line(".")
    local buf_marks = marks_in_current_buf()
    for i = #buf_marks, 1, -1 do
        if buf_marks[i].line < cur_line then
            vim.cmd("normal! '" .. buf_marks[i].ch)
            return
        end
    end

    -- Nothing above in this buffer: jump to the last mark globally.
    vim.cmd("normal! '" .. marks[#marks])
end

-- Clear all lowercase marks (a-z) in the current buffer.
function M.clear_lower()
    vim.cmd("delmarks a-z")
    vim.notify("Cleared lowercase marks (a-z)", vim.log.levels.INFO)
end

-- Clear all uppercase (global) marks (A-Z).
function M.clear_upper()
    vim.cmd("delmarks A-Z")
    vim.notify("Cleared uppercase marks (A-Z)", vim.log.levels.INFO)
end

return M

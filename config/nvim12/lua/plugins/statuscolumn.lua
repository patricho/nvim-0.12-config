-- Custom statuscolumn: replicates Snacks' layout (sign | number | fold/git)
-- with the single change that all marks are shown as "" instead of the mark letter.
--
-- Layout: [sign/mark] [number] [fold/git]
--   left  = sign or mark (sign takes priority)
--   middle = line number
--   right  = fold or git sign

local M = {}

-- Detect git signs by name
local git_patterns = { "GitSign", "MiniDiffSign" }
local function is_git_sign(name)
    for _, p in ipairs(git_patterns) do
        if name:find(p) then return true end
    end
    return false
end

-- Collect all signs and marks for a buffer, keyed by line number.
-- Returns table<lnum, sign[]> where each sign has { text, texthl, priority, type }.
local sign_cache = {} ---@type table<number, table<number, table[]>>

local function buf_signs(buf)
    local signs = {}

    -- Extmark signs (covers gitsigns, diagnostics, etc. on Neovim 0.10+)
    local extmarks = vim.api.nvim_buf_get_extmarks(buf, -1, 0, -1, { details = true, type = "sign" })
    for _, em in ipairs(extmarks) do
        local lnum = em[2] + 1
        signs[lnum] = signs[lnum] or {}
        local name = em[4].sign_hl_group or em[4].sign_name or ""
        table.insert(signs[lnum], {
            text     = em[4].sign_text,
            texthl   = em[4].sign_hl_group,
            priority = em[4].priority or 0,
            type     = is_git_sign(name) and "git" or "sign",
        })
    end

    -- Marks (a-z, A-Z) — always shown as 
    local all_marks = vim.fn.getmarklist(buf)
    vim.list_extend(all_marks, vim.fn.getmarklist())
    for _, mark in ipairs(all_marks) do
        if mark.pos[1] == buf and mark.mark:match("[a-zA-Z]") then
            local lnum = mark.pos[2]
            signs[lnum] = signs[lnum] or {}
            table.insert(signs[lnum], {
                text     = "",
                texthl   = "StatusColumnMark",
                priority = 100, -- above regular signs, below nothing special
                type     = "mark",
            })
        end
    end

    return signs
end

-- Render a sign as a statuscolumn item (2 cells wide, with highlight).
local icon_cache = {} ---@type table<string, string>
local function render_sign(sign)
    if not sign then return "  " end
    local key = (sign.text or "") .. (sign.texthl or "")
    if icon_cache[key] then return icon_cache[key] end
    local text = vim.fn.strcharpart(sign.text or "", 0, 2)
    text = text .. string.rep(" ", 2 - vim.fn.strchars(text))
    local result = sign.texthl and ("%#" .. sign.texthl .. "#" .. text .. "%*") or text
    icon_cache[key] = result
    return result
end

-- Refresh caches periodically so signs stay current.
local cache = {} ---@type table<string, string>
local timer = vim.uv.new_timer()
timer:start(200, 200, function()
    sign_cache = {}
    cache      = {}
    icon_cache = {}
end)

-- Main statuscolumn expression, called per line.
function M.get()
    local win = vim.g.statusline_winid
    if not win then return "" end

    local buf = vim.api.nvim_win_get_buf(win)
    local lnum = vim.v.lnum

    -- Cache key includes virtual-line and relative-line so wrapped lines are handled.
    local key = ("%d:%d:%d:%d:%d"):format(win, buf, lnum, vim.v.virtnum, vim.v.relnum)
    if cache[key] then return cache[key] end

    local ok, result = pcall(M._get, win, buf, lnum)
    if ok then
        cache[key] = result
        return result
    end
    return ""
end

function M._get(win, buf, lnum)
    local nu         = vim.wo[win].number
    local rnu        = vim.wo[win].relativenumber
    local show_signs = vim.v.virtnum == 0 and vim.wo[win].signcolumn ~= "no"
    local show_folds = vim.v.virtnum == 0 and vim.wo[win].foldcolumn ~= "0"

    if not (nu or rnu or show_signs or show_folds) then return "" end

    -- ── left: highest-priority sign, with marks beating regular signs ──────
    local left = "  "
    if show_signs then
        local buf_s = sign_cache[buf]
        if not buf_s then
            buf_s = buf_signs(buf)
            sign_cache[buf] = buf_s
        end
        local line_signs = buf_s[lnum] or {}
        -- Sort descending by priority; marks are typed "mark" and given priority 100.
        table.sort(line_signs, function(a, b)
            return (a.priority or 0) > (b.priority or 0)
        end)
        -- Pick for the left slot: diagnostic signs first (highest priority), then marks.
        -- Git signs are excluded from the left slot entirely.
        local chosen
        for _, s in ipairs(line_signs) do
            if s.type == "sign" then
                chosen = s; break
            end
        end
        if not chosen then
            for _, s in ipairs(line_signs) do
                if s.type == "mark" then
                    chosen = s; break
                end
            end
        end
        left = render_sign(chosen)
    end

    -- ── middle: line number ─────────────────────────────────────────────────
    local middle = ""
    if (nu or rnu) and vim.v.virtnum == 0 then
        local num
        if rnu and nu and vim.v.relnum == 0 then
            num = lnum
        elseif rnu then
            num = vim.v.relnum
        else
            num = lnum
        end
        middle = "%=" .. num .. " "
    end

    -- ── right: fold icon, falling back to git sign ──────────────────────────
    local right = "  "
    if show_folds then
        local fc = vim.opt.fillchars:get()
        local level = vim.fn.foldlevel(lnum)
        if level > 0 then
            local foldclosed = vim.fn.foldclosed(lnum)
            if foldclosed == lnum then
                -- This line is the start of a closed fold
                right = render_sign({ text = fc.foldclose or "", texthl = "Folded" })
            end
            -- (open folds: no icon, same as Snacks default folds.open = false)
        end
    end
    -- Fall back to git sign on the right when there is no fold icon
    if right == "  " and show_signs then
        local buf_s = sign_cache[buf] or {}
        local line_signs = buf_s[lnum] or {}
        for _, s in ipairs(line_signs) do
            if s.type == "git" then
                right = render_sign(s)
                break
            end
        end
    end

    local ret = left .. middle .. right
    -- Wrap with click handler for folds, matching Snacks behaviour
    return "%@v:lua.require'plugins.statuscolumn'.click_fold@" .. ret .. "%T"
end

function M.click_fold()
    local pos = vim.fn.getmousepos()
    vim.api.nvim_win_set_cursor(pos.winid, { pos.line, 1 })
    vim.api.nvim_win_call(pos.winid, function()
        if vim.fn.foldlevel(pos.line) > 0 then
            vim.cmd("normal! za")
        end
    end)
end

return M

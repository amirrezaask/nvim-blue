local buf = 6
local hls = vim.api.nvim_get_hl(0, {})
local lines = {}
for name, hl in pairs(hls) do
    local bg
    if hl.bg then
        bg = string.format('#%06X', hl.bg)
    else
        bg = 'none'
    end

    local fg
    if hl.fg then
        fg = string.format('#%06X', hl.fg)
    else
        fg = 'none'
    end
    local link = ''
    if hl.link then
        link = string.format(', link = "%s"', hl.link)
    end
    table.insert(lines, string.format("vim.api.nvim_set_hl(0, '%s', {bg='%s', fg='%s' %s})", name, bg, fg, link))
end


vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

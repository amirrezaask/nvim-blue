---@class RGB
---@field r number
---@field g number
---@field b number
---@field lighten function
---@field darken function
local RGB = {}

---@function RGB.new
---@param r number
---@param g number
---@param b number
---@return RGB
function RGB.new(r, g, b)
    r = math.max(0, math.min(255, math.floor(r)))
    g = math.max(0, math.min(255, math.floor(g)))
    b = math.max(0, math.min(255, math.floor(b)))

    local function lighten(self, percent)
        local factor = 1 + math.max(0, math.min(1, percent))
        return RGB.new(
            self.r * factor + (255 - self.r) * (factor - 1),
            self.g * factor + (255 - self.g) * (factor - 1),
            self.b * factor + (255 - self.b) * (factor - 1)
        )
    end


    local function darken(self, percent)
        local factor = 1 - math.max(0, math.min(1, percent))
        return RGB.new(
            self.r * factor,
            self.g * factor,
            self.b * factor
        )
    end

    local function to_hex(self)
        return string.format("#%02x%02x%02x", self.r, self.g, self.b)
    end


    return {
        r = r,
        g = g,
        b = b,
        lighten = lighten,
        darken = darken,
        to_hex = to_hex,
        apply = apply,
    }
end

function RGB.from_hex(hex)
    hex = hex:gsub("^#", "")
    if #hex ~= 6 then
        error("Invalid hex color: must be 6 characters (e.g., '#1a1b26')")
    end

    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)

    if not (r and g and b) then
        error("Invalid hex color: must contain valid hexadecimal values")
    end

    return RGB.new(r, g, b)
end

local theme = {}

function theme.new_base16(name, colors)
    assert(#colors == 16, "Colors should be 16 colors.")
    local function apply(self)
        local base00 = self[1]  -- Default background
        local base01 = self[2]  -- Lighter background
        local base02 = self[3]  -- Selection background
        local base03 = self[4]  -- Comments, line numbers
        local base04 = self[5]  -- Dark foreground
        local base05 = self[6]  -- Default foreground
        local base06 = self[7]  -- Lighter foreground
        local base07 = self[8]  -- Lightest foreground
        local base08 = self[9]  -- Red (variables, errors)
        local base09 = self[10] -- Orange (integers)
        local base0A = self[11] -- Yellow (classes, warnings)
        local base0B = self[12] -- Green (strings)
        local base0C = self[13] -- Cyan (constants)
        local base0D = self[14] -- Blue (functions, keywords)
        local base0E = self[15] -- Purple (control flow)
        local base0F = self[16] -- Brown (accents)

        vim.cmd("highlight clear")
        vim.g.colors_name = name

        local set_hl = vim.api.nvim_set_hl

        set_hl(0, "Normal", { fg = base05:to_hex(), bg = base00:to_hex() })
        set_hl(0, "NormalFloat", { fg = base05:to_hex(), bg = base01:to_hex() })
        set_hl(0, "LineNr", { fg = base03:to_hex() })
        set_hl(0, "CursorLineNr", { fg = base06:to_hex(), bold = true })
        set_hl(0, "CursorLine", { bg = base01:to_hex() })
        set_hl(0, "Visual", { bg = base02:to_hex() })
        set_hl(0, "Cursor", { fg = base00:to_hex(), bg = base07:to_hex() })
        set_hl(0, "StatusLine", { fg = base04:to_hex(), bg = base02:to_hex() })
        set_hl(0, "StatusLineNC", { fg = base04:to_hex(), bg = base01:to_hex() })
        set_hl(0, "VertSplit", { fg = base03:to_hex() })
        set_hl(0, "Pmenu", { bg = base01:to_hex(), fg = base08:to_hex() })
        set_hl(0, "PmenuSel", { bg = base0D:to_hex(), fg = base01:to_hex() })
        set_hl(0, "BlinkCmpMenu", { link = "Pmenu" })
        set_hl(0, "BlinkCmpMenuSelection", { link = "PmenuSel" })
        set_hl(0, "Search", { fg = base00:to_hex(), bg = base0A:to_hex() })
        set_hl(0, "IncSearch", { fg = base00:to_hex(), bg = base09:to_hex() })
        set_hl(0, "MatchParen", { fg = base0E:to_hex(), bold = true })
        set_hl(0, "Folded", { fg = base03:to_hex(), bg = base01:to_hex() })
        set_hl(0, "SignColumn", { bg = base00:to_hex() })
        set_hl(0, "Comment", { fg = base03:to_hex(), italic = true })
        set_hl(0, "Keyword", { fg = base0E:to_hex() })   -- e.g., if, for
        set_hl(0, "Statement", { fg = base0E:to_hex() }) -- e.g., return, break
        set_hl(0, "Function", { fg = base0D:to_hex() })
        set_hl(0, "String", { fg = base0B:to_hex() })
        set_hl(0, "Number", { fg = base09:to_hex() })
        set_hl(0, "Float", { fg = base09:to_hex() })
        set_hl(0, "Boolean", { fg = base09:to_hex() })
        set_hl(0, "Constant", { fg = base0C:to_hex() })
        set_hl(0, "Type", { fg = base0A:to_hex() })
        set_hl(0, "Identifier", { fg = base08:to_hex() })
        set_hl(0, "Operator", { fg = base05:to_hex() })
        set_hl(0, "PreProc", { fg = base0E:to_hex() }) -- e.g., #include
        set_hl(0, "Special", { fg = base0C:to_hex() }) -- e.g., escape sequences
        set_hl(0, "SpecialComment", { fg = base04:to_hex(), italic = true })
        set_hl(0, "Todo", { fg = base0A:to_hex(), bg = base01:to_hex(), bold = true })

        set_hl(0, "Error", { fg = base08:to_hex() })
        set_hl(0, "Warning", { fg = base09:to_hex() })

        set_hl(0, "DiffAdd", { fg = base0B:to_hex(), bg = base01:to_hex() })
        set_hl(0, "DiffChange", { fg = base09:to_hex(), bg = base01:to_hex() })
        set_hl(0, "DiffDelete", { fg = base08:to_hex(), bg = base01:to_hex() })
        set_hl(0, "DiffText", { fg = base0D:to_hex(), bg = base01:to_hex() })
    end


    colors.apply = apply
    return colors
end

------ Here goes the theme.
theme.new_base16(
    "norcalli",
    {
        -- UI
        RGB.from_hex('#121b2b'), -- base00
        RGB.from_hex('#213554'), -- base01
        RGB.from_hex('#1d3872'), -- base02
        RGB.from_hex('#80b2d6'), -- base03
        RGB.from_hex('#3aa3e9'), -- base04
        RGB.from_hex('#abb2bf'), -- base05
        RGB.from_hex('#b6bdca'), -- base06
        RGB.from_hex('#c8ccd4'), -- base07

        -- Syntax
        RGB.from_hex('#f04c75'), -- base08
        RGB.from_hex('#d19a66'), -- base09
        RGB.from_hex('#e5c07b'), -- base0A
        RGB.from_hex('#98c379'), -- base0B
        RGB.from_hex('#56b6c2'), -- base0C
        RGB.from_hex('#01bfef'), -- base0D
        RGB.from_hex('#c678dd'), -- base0E
        RGB.from_hex('#be5046'), -- base0F
    }):apply()

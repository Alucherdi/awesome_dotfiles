local utils = {}

function utils.colorize_text(color, text)
    return
        "<span foreground='"
        .. color
        .. "'>"
        .. text
        .. "</span>"
end

return utils

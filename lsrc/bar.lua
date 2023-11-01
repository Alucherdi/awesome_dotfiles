local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")

local font = "JetbrainsMono Nerd Font"

awful.screen.connect_for_each_screen(function(s)
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    beautiful.taglist_font = font .. " 11"

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
    }

    local time = {
        font   = font,
        widget = wibox.widget.textclock(" %d-%m %H:%M ", 10)
    }

    local calendar = awful.widget.calendar_popup.month {
        font = font .. " 9",
        screen = s,
        style_month = {
            bg_color = "#000000",
            border_width = 4,
            fg_color = "#FFFFFF",
        },

        style_weekday = {
            bg_color = "#000000",
        },

        style_normal = {
            bg_color = "#000000",
        },

    }

    calendar:attach(time.widget, "bc")

    local dpi = beautiful.xresources.apply_dpi

    s.bar = awful.wibar {
        position = "bottom",
        screen = s,
        height = 32,
        width = 500,
        bg = "#FFFFFF00",
    }

    local wi_sep = {
        color = "#00000000",
        widget = wibox.widget.separator,
    }

    local wi_mode = wibox.widget {
        {
            {
                s.mylayoutbox,
                margins = dpi(8),
                widget = wibox.container.margin,
            },
            bg = "#000000",
            widget = wibox.container.background,
        },
        halign = "right",
        widget = wibox.container.place,
    }


    local wi_time = {
        {
            time,
            bg = "#000000",
            widget = wibox.container.background,
        },
        content_fill_vertical = true,
        widget = wibox.container.place,
    }

    local wi_tags = {
        { 
            s.mytaglist,
            bg = "#000000",
            widget = wibox.container.background,
        },
        content_fill_vertical = true,
        halign = "left",
        widget = wibox.container.place,
    }


    s.bar:setup {
        layout = wibox.layout.flex.horizontal,
        spacing = 5,
        wi_mode,
        wi_time,
        wi_tags,
    }
end)

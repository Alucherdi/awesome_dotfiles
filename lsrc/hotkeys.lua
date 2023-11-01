local gears = require("gears")
local awful = require("awful")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

local modkey = "Mod4"
local terminal = "kitty"

local function sd(d, g)
    return { description = d, group = g }
end

local function mv(hk, md)
    return awful.key({ modkey, }, hk, function () awful.client.focus.bydirection(md)
        if client.focus then client.focus:raise() end
    end)
end

-- Defined hotkeys for all-purpose behaviour
globalkeys = gears.table.join(
    awful.key(
        { modkey, "Control" }, "r", awesome.restart,
        sd("reload awesome", "awesome")
    ),
    awful.key(
        { modkey, "Shift"   }, "q", awesome.quit,
        sd("quit awesome", "awesome")
    ),

    awful.key(
        { modkey }, "s", hotkeys_popup.show_help,
        sd("show help", "awesome")
    ),

    awful.key(
        { modkey }, "Left",   awful.tag.viewprev,
        sd("view previous", "tag")
    ),

    awful.key(
        { modkey }, "Right",  awful.tag.viewnext,
        sd("view next", "tag")
    ),

    awful.key(
        { modkey }, "Escape", awful.tag.history.restore,
        sd("go back", "tag")
    ),

    awful.key({ modkey }, "space", function ()
        awful.spawn("rofi -show drun")
    end),

    -- Movement
    mv("j","down"),
    mv("k","up"),
    mv("h","left"),
    mv("l","right"),

    awful.key({ modkey, "Control", "Shift" }, "l", function () awful.tag.incmwfact( 0.04) end),
    awful.key({ modkey, "Control", "Shift" }, "h", function () awful.tag.incmwfact(-0.04) end),
    awful.key({ modkey, "Control", "Shift" }, "j", function () awful.client.incwfact( 0.04) end),
    awful.key({ modkey, "Control", "Shift" }, "k", function () awful.client.incwfact(-0.04) end),


    -- Move Windows
    awful.key({ modkey, "Shift" }, "j", function ()
        awful.client.swap.byidx(1)
    end, sd("swap with next client by index", "client")),

    awful.key({ modkey, "Shift" }, "k", function ()
        awful.client.swap.byidx(-1)
    end, sd("swap with next client by index", "client")),

    awful.key({ modkey, "Shift" }, "h", function ()
        awful.tag.incnmaster(1, nil, true)
    end, sd("increase the number of master clients", "layout")),

    awful.key({ modkey, "Shift" }, "l", function ()
        awful.tag.incnmaster(-1, nil, true)
    end, sd("decrease the number of master clients", "layout")),


    -- Move to Screen
    awful.key({ modkey, "Control" }, "j", function ()
        awful.screen.focus_relative(1)
    end, sd("swap with next client by index", "client")),

    awful.key({ modkey, "Control" }, "k", function ()
        awful.screen.focus_relative(-1)
    end, sd("swap with next client by index", "client")),


    awful.key({ modkey, "Control" }, "h", function ()
        awful.tag.incncol(1, nil, true)
    end, sd("increase the number of columns", "layout")),

    awful.key({ modkey, "Control" }, "l", function ()
        awful.tag.incncol(-1, nil, true)
    end, sd("decrease the number of columns", "layout")),

    awful.key({ modkey }, "p", function()
        menubar.show()
    end, sd("show the menubar", "launcher")),


    awful.key({ modkey, "Shift" }, "space", function ()
        awful.layout.inc(-1)
    end, sd("select previous", "layout")),

    awful.key({ modkey }, "BackSpace", function()
        awful.spawn("betterlockscreen -l")
    end),

    awful.key({}, "Print", function()
        awful.spawn("flameshot gui")
    end),

    awful.key({ modkey }, "Return", function()
        awful.spawn(terminal)
    end)
)

-- Defined hotkeys for in-client behaviour
clientkeys = gears.table.join(
    awful.key({ modkey }, "f", function (c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, sd("toggle fullscreen", "client")),

    awful.key({ modkey, }, "w", function (c)
        c:kill()
    end, sd("close", "client")),

    awful.key({ modkey, "Control" }, "space",
        awful.client.floating.toggle,
    sd("toggle floating", "client")),

    awful.key({ modkey, "Control" }, "Return", function (c)
        c:swap(awful.client.getmaster())
    end, sd("move to master", "client")),

    awful.key({ modkey }, "o", function (c)
        c:move_to_screen()
    end, sd("move to screen", "client")),

    awful.key({ modkey }, "t", function (c)
        c.ontop = not c.ontop
    end, sd("toggle keep on top", "client")),

    awful.key({ modkey }, "n", function (c)
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        c.minimized = true
    end, sd("minimize", "client")),

    awful.key({ modkey }, "m", function (c)
        c.maximized = not c.maximized
        c:raise()
    end, sd("(un)maximize", "client")),

    awful.key({ modkey, "Control" }, "m", function (c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
    end, sd("(un)maximize vertically", "client")),

    awful.key({ modkey, "Shift"   }, "m", function (c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
    end, sd("(un)maximize horizontally", "client"))
)

-- Tag hotkeys
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
    awful.key({ modkey }, "#" .. i + 9,
        function ()
              local screen = awful.screen.focused()
              local tag = screen.tags[i]
              if tag then
                 tag:view_only()
              end
        end,
        sd("view tag #"..i, "tag")),
    -- Toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 9,
        function ()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
               awful.tag.viewtoggle(tag)
            end
        end,
        sd("toggle tag #" .. i, "tag")),
    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
        function ()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                end
           end
        end,
        sd("move focused client to tag #"..i, "tag")),
    -- Toggle tag on focused client.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
        function ()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
        sd("toggle focused client on tag #" .. i, "tag"))
    )
end

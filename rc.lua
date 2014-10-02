-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local lines = require('lines')
local vicious = require('vicious')
-- User libraries
local yawn = require('yawn')
local lain = require('lain')
local common = require('common')
local mocp = require('mocp')

local linesfg  = '#d0d0d0'
local linesbg1 = '#313131'
local linesbg2 = '#444444'

yawn.register(717055)

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/sandro/.config/awesome/themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = "vim"
editor_cmd = terminal .. " -x " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}



-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
  awful.tag({ 1, 2, 3, 4, 5 }, 1, {lain.layout.uselesstile.top, layouts[11], lain.layout.uselesstile.top, layouts[1], layouts[1]}),
  awful.tag({ 'IM' }, 2, layouts[11])
}
-- }}}


-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}

-- tags buttons configuration
mytaglist.buttons = awful.util.table.join(
  awful.button({ }, 1, awful.tag.viewonly),
  awful.button({ modkey }, 1, awful.client.movetotag),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, awful.client.toggletag),
  awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
  awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)


for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 18 })

    local date   = lines:format('%b %d %R', linesfg, linesbg1)
    local cpu    = lines:format('$1%', linesfg, linesbg2)
    local mem    = lines:format('$1%', linesfg, linesbg1)
    local fs     = lines:format('${/ used_gb}GB / ${/ avail_gb}GB', linesfg, linesbg2)
    local weat   = lines:format('', linesfg, linesbg1)
    local vol    = lines:format('$1%', linesfg, linesbg2)
    local therm  = lines:format('$1°C', linesfg, linesbg1)
    local music  = nil

    vicious.register(date.widget, vicious.widgets.date, date.markup, 60)
    vicious.register(cpu.widget, vicious.widgets.cpu, cpu.markup, 60)
    vicious.register(mem.widget, vicious.widgets.mem, mem.markup, 60)
    vicious.register(fs.widget, vicious.widgets.fs, fs.markup, 60)
    vicious.register(vol.widget, vicious.widgets.volume, vol.markup, 5, 'Master')
    vicious.register(therm.widget, vicious.widgets.thermal, therm.markup, 60, {'coretemp.0', 'core'})



    local dateimg  = lines:img(beautiful.dateicon, linesbg1)
    local cpuimg   = lines:img(beautiful.cpuicon, linesbg2)
    local memimg   = lines:img(beautiful.memicon, linesbg1)
    local fsimg    = lines:img(beautiful.fsicon, linesbg2)
    local weatimg  = lines:wrapimg(
      yawn.icon,
      linesbg1
    )
    local volimg   = lines:img(beautiful.volicon, linesbg2)
    local thermimg = lines:img(beautiful.thermicon, linesbg1)
    local musicimg = nil

    --naughty.notify({
    --  text = lines:format('lel', 'green', 'black'):gsub('<', '&lt;'):gsub('>', '&gt;'),
    --  timeout = 0
    --})

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()

    common.layoutpatch(right_layout)

    right_layout:add(
      lines:arrow(beautiful.bg_normal).widget
    )

    right_layout:add(thermimg)
    right_layout:add(therm.widget)

    right_layout:add(volimg)
    right_layout:add(vol.widget)

    right_layout:add(weatimg)
    right_layout:add(weat.widget)

    right_layout:add(fsimg)
    right_layout:add(fs.widget)

    right_layout:add(memimg)
    right_layout:add(mem.widget)

    right_layout:add(cpuimg)
    right_layout:add(cpu.widget)

    right_layout:add(dateimg)
    right_layout:add(date.widget)

    local moctimer = timer({ timeout = 5 })
    local last = nil

    moctimer:connect_signal("timeout", function()
      -- naughty.notify({
      -- text = mocp:playing() and "true" or "false",
      --  timeout = 0
      -- })

      if mocp:playing() and not music then
        music = lines:format(
          mocp:format(),
          linesfg,
          linesbg2
        )

        musicimg = lines:img(beautiful.musicicon, linesbg2)

        right_layout:shift()
        right_layout:unshift(music.widget)
        right_layout:unshift(musicimg)

        right_layout:unshift(
          lines:arrow(beautiful.bg_normal).widget
        )
      elseif not mocp:playing() and music or last ~= mocp:format() and mocp:playing() then -- not playing or song name changed
        right_layout:shift() -- last arrow
        right_layout:shift() -- icon
        right_layout:shift() -- text
        right_layout:shift() -- arrow

        lines:setlastbg(linesbg1)

        right_layout:unshift(thermimg)
        right_layout:unshift(
          lines:arrow(beautiful.bg_normal).widget
        )

        music = nil
      end

      last = mocp:format()
    end)

    moctimer:start()

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

local botwibox = awful.wibox({ position = 'bottom', screen = 1, height = 18})
local layout = wibox.layout.align.horizontal()

layout:set_right(
  wibox.widget.systray()
)

botwibox:set_widget(layout)

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),

    awful.key({ modkey,           }, "h", function() awful.screen.focus_relative(1) end),
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Control" }, "j", function()
      awful.prompt.run(
        {prompt = 'Jump to: '},
        mypromptbox[mouse.screen].widget,
        common.jumpto,
        function() end
      )
    end),
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
          function ()
                local screen = mouse.screen
                local tag = awful.tag.gettags(screen)[i]
                if tag then
                   awful.tag.viewonly(tag)
                end
          end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

globalkeys = awful.util.table.join(require('wmove').table(), globalkeys)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "Firefox" },
       properties = { tag = tags[1][2] } },
    { rule = { class = "Ts3client_linux_amd64" },
       properties = { tag = tags[2][1] } },
    { rule = { class = "Skype" },
       properties = { tag = tags[2][1] } },
    { rule = { class = "dota_linux" },
       properties = { tag = tags[1][3] } },
    { rule = { class = "Steam" },
       properties = { tag = tags[1][3] } }

}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

awful.util.spawn('xrdb /home/sandro/.Xdefaults')
awful.util.spawn('xmodmap /home/sandro/.Xmodmap')
awful.util.spawn('chup firefox')
awful.util.spawn('chup urxvt')
awful.util.spawn('chup skype')
awful.util.spawn('chup teamspeak3')
-- }}}

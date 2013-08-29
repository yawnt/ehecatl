---------------------------
-- Default awesome theme --
---------------------------

theme_dir           = os.getenv("HOME") .. "/.config/awesome/heiwa"

theme = {}

theme.font          = "Inconsolata 10"
theme.taglist_font  = "Inconsolata 10"

theme.bg_normal     = "#303030"
theme.bg_focus      = "#6A9FB5"
theme.bg_urgent     = "#D28445"
theme.bg_minimize   = "#505050"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#E0E0E0"
theme.fg_focus      = "#F5F5F5"
theme.fg_urgent     = "#F5F5F5"
theme.fg_minimize   = "#F5F5F5"

theme.border_width  = 1
theme.border_normal = "#151515"
theme.border_focus  = "#505050"
theme.border_marked = "#8F5536"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
theme.taglist_squares_sel   = theme_dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel = theme_dir .. "/icons/square_unsel.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = theme_dir .. "/icons/submenu.png"
theme.menu_height = 16
theme.menu_width  = 100

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = "/usr/share/awesome/themes/default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = "/usr/share/awesome/themes/default/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = "/usr/share/awesome/themes/default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = "/usr/share/awesome/themes/default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = "/usr/share/awesome/themes/default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = "/usr/share/awesome/themes/default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/maximized_focus_active.png"

theme.wallpaper = os.getenv("HOME") .. "/img/japan.jpg"

-- You can use your own layout icons like this:

theme.layout_tile                           = theme_dir .. "/icons/tile.png"
theme.layout_tilegaps                       = theme_dir .. "/icons/tilegaps.png"
theme.layout_tileleft                       = theme_dir .. "/icons/tileleft.png"
theme.layout_tilebottom                     = theme_dir .. "/icons/tilebottom.png"
theme.layout_tiletop                        = theme_dir .. "/icons/tiletop.png"
theme.layout_fairv                          = theme_dir .. "/icons/fairv.png"
theme.layout_fairh                          = theme_dir .. "/icons/fairh.png"
theme.layout_spiral                         = theme_dir .. "/icons/spiral.png"
theme.layout_dwindle                        = theme_dir .. "/icons/dwindle.png"
theme.layout_max                            = theme_dir .. "/icons/max.png"
theme.layout_fullscreen                     = theme_dir .. "/icons/fullscreen.png"
theme.layout_magnifier                      = theme_dir .. "/icons/magnifier.png"
theme.layout_floating                       = theme_dir .. "/icons/floating.png"

-- Icons
theme.cpuicon   = theme_dir .. "/icons/cpu.png"
theme.clockicon = theme_dir .. "/icons/clock.png"
theme.memicon   = theme_dir .. "/icons/mem.png"
theme.fsicon    = theme_dir .. "/icons/fs.png"
theme.volicon   = theme_dir .. "/icons/spkr.png"
theme.thermicon = theme_dir .. "/icons/temp.png"

theme.awesome_icon = "/usr/share/awesome/icons/awesome16.png"
theme.arch_icon = theme_dir .. "/icons/arch.png"

-- Define the icon theme for application icons. If not set then the icons 
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80

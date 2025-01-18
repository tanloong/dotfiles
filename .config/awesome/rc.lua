-- https://github.com/awesomeWM/awesome/blob/a35fceda14c39b4a2b1c52947288b378f410f32a/docs/90-FAQ.md

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local client_iterate = require("awful.client").iterate
local dpi = require("beautiful.xresources").apply_dpi
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
-- Popin
local poppin = require("poppin")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors
  })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err)
    })
    in_error = false
  end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/usr/.config/awesome/default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "terminal.sh"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
openthe = "/home/usr/.local/bin/openthe"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
Alt = "Mod1"
Super = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.max,
  awful.layout.suit.tile,
  awful.layout.suit.floating,
  -- awful.layout.suit.magnifier,
  -- awful.layout.suit.max.fullscreen,
  -- awful.layout.suit.tile.left,
  -- awful.layout.suit.tile.bottom,
  -- awful.layout.suit.tile.top,
  -- awful.layout.suit.fair,
  -- awful.layout.suit.fair.horizontal,
  -- awful.layout.suit.spiral,
  -- awful.layout.suit.spiral.dwindle,
  -- awful.layout.suit.corner.nw,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,
}
awful.layout.suit.max.name = "[M]"
awful.layout.suit.tile.name = "[]="
awful.layout.suit.floating.name = "><>"
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
  -- { "hotkeys",     function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  -- { "manual",      terminal .. " -e man awesome" },
  { "edit config", editor_cmd .. " " .. awesome.conffile },
  { "restart", awesome.restart },
  { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({
  items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
    { "open terminal", terminal }
  }
})

mylauncher = awful.widget.launcher({
  image = beautiful.awesome_icon,
  menu = mymainmenu
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
-- mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget

-- {wifi_essid, "%s", "wlan0"},
-- { separator, "|",           NULL },

-- {battery_perc, "电量%s", "BAT0"},
-- {battery_state, "%s", "BAT0"},
-- { separator, "|",           NULL },

-- // {disk_free, "硬盘%s", "/"},
-- {disk_free, "~ %s", "/home/usr"},
-- { separator, "|",           NULL },

-- // /home/usr/dotfiles/.local/bin/sb-volume-arch" },
-- // {vol_perc, "音量%s", "/dev/mixer"},
-- // { separator, "|",           NULL },

-- {ram_free, "内存%s", NULL},
-- { separator, "|",           NULL },

-- // { cpu_perc, "⚡ %s%%",           NULL },
-- // { separator, "|",           NULL },

mytextclock = wibox.widget.textclock("%m-%d %u %H:%M")

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
  awful.button({}, 1, function(t) t:view_only() end),
  awful.button({ Alt }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({}, 3, awful.tag.viewtoggle),
  awful.button({ Alt }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end)
-- awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
-- awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
  awful.button({}, 1, function(c)
    if c == client.focus then
      c.minimized = true
    else
      c:emit_signal("request::activate", "tasklist", { raise = true })
    end
  end),
  awful.button({}, 3, function()
    awful.menu.client_list({ theme = { width = 250 } })
  end),
  awful.button({}, 4, function()
    awful.client.focus.byidx(1)
  end),
  awful.button({}, 5, function()
    awful.client.focus.byidx(-1)
  end))

local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  set_wallpaper(s)

  -- Each screen has its own tag table.
  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
    awful.button({}, 1, function() awful.layout.inc(1) end),
    awful.button({}, 3, function() awful.layout.inc(-1) end)))
  -- awful.button({}, 4, function() awful.layout.inc(1) end),
  -- awful.button({}, 5, function() awful.layout.inc(-1) end)))
  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist {
    screen = s,
    filter = awful.widget.taglist.filter.noempty,
    buttons = taglist_buttons
  }

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist {
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons
  }

  -- Create the wibox
  s.mywibox = awful.wibar({ position = "bottom", screen = s, height = dpi(15) })

  -- Add widgets to the wibox
  s.mywibox:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      mylauncher,
      s.mytaglist,
      -- s.mypromptbox,
      s.mylayoutbox,
    },
    s.mytasklist, -- Middle widget
    {             -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      -- mykeyboardlayout,
      wibox.widget.systray(),
      mytextclock,
    },
  }
end)
-- }}}

-- {{{ Mouse bindings
-- root.buttons(gears.table.join(
--   awful.button({}, 3, function() mymainmenu:toggle() end)
-- awful.button({}, 4, awful.tag.viewnext),
-- awful.button({}, 5, awful.tag.viewprev)
-- ))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
  awful.key({ Alt, }, "s", hotkeys_popup.show_help,
    { description = "show help", group = "awesome" }),
  awful.key({ Alt, }, "Left", awful.tag.viewprev,
    { description = "view previous", group = "tag" }),
  awful.key({ Alt, }, "Right", awful.tag.viewnext,
    { description = "view next", group = "tag" }),
  awful.key({ Alt, }, "Escape", awful.tag.history.restore,
    { description = "go back", group = "tag" }),

  awful.key({ Alt, }, "j",
    function()
      awful.client.focus.byidx(1)
    end,
    { description = "focus next by index", group = "client" }
  ),
  awful.key({ Alt, }, "k",
    function()
      awful.client.focus.byidx(-1)
    end,
    { description = "focus previous by index", group = "client" }
  ),
  awful.key({ Alt, }, "w", function() mymainmenu:show() end,
    { description = "show main menu", group = "awesome" }),

  -- Layout manipulation
  awful.key({ Alt, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
    { description = "swap with next client by index", group = "client" }),
  awful.key({ Alt, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
    { description = "swap with previous client by index", group = "client" }),
  awful.key({ Alt, "Control" }, "j", function() awful.screen.focus_relative(1) end,
    { description = "focus the next screen", group = "screen" }),
  awful.key({ Alt, "Control" }, "k", function() awful.screen.focus_relative(-1) end,
    { description = "focus the previous screen", group = "screen" }),
  awful.key({ Alt, }, "u", awful.client.urgent.jumpto,
    { description = "jump to urgent client", group = "client" }),
  awful.key({ Alt, }, "Tab",
    function()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end,
    { description = "go back", group = "client" }),

  -- Standard program
  awful.key({ Alt, "Shift" }, "r", awesome.restart,
    { description = "reload awesome", group = "awesome" }),
  awful.key({ Alt, "Shift" }, "q", awesome.quit,
    { description = "quit awesome", group = "awesome" }),
  awful.key({ Alt, }, "l", function() awful.tag.incmwfact(0.05) end,
    { description = "increase master width factor", group = "layout" }),
  awful.key({ Alt, }, "h", function() awful.tag.incmwfact(-0.05) end,
    { description = "decrease master width factor", group = "layout" }),
  awful.key({ Alt, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
    { description = "increase the number of master clients", group = "layout" }),
  awful.key({ Alt, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
    { description = "decrease the number of master clients", group = "layout" }),
  awful.key({ Alt, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
    { description = "increase the number of columns", group = "layout" }),
  awful.key({ Alt, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
    { description = "decrease the number of columns", group = "layout" }),

  awful.key({ Alt, }, "t", function()
    for c in client_iterate(function() return true end) do
      c.fullscreen = false
      c.maximized = false
      c.maximized_horizontal = false
      c.maximized_vertical = false
      c.floating = false
      c.border_width = beautiful.border_width
    end
    awful.layout.set(awful.layout.suit.tile)
  end, { description = "tile layout", group = "client" }),
  awful.key({ Alt, }, "f", function()
    for c in client_iterate(function() return true end) do
      c.fullscreen = false
      c.maximized = false
      c.maximized_horizontal = false
      c.maximized_vertical = false
      c.border_width = beautiful.border_width
    end
    awful.layout.set(awful.layout.suit.floating)
  end, { description = "floating layout", group = "client" }),
  awful.key({ Alt, }, "m",
    function()
      for c in client_iterate(function() return true end) do
        c.fullscreen = false
        c.floating = false
        c.border_width = 0
      end
      awful.layout.set(awful.layout.suit.max)
    end,
    { description = "(un)maximize", group = "client" }),
  awful.key({ Alt, }, "equal",
    function()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
        c:emit_signal(
          "request::activate", "key.unminimize", { raise = true }
        )
      end
    end,
    { description = "restore minimized", group = "client" }),
  awful.key({}, "XF86MonBrightnessUp", function() awful.spawn.with_shell("brightnessctl set +10%") end),
  awful.key({}, "XF86MonBrightnessDown", function() awful.spawn.with_shell("brightnessctl set 10%-") end),
  awful.key({}, "XF86AudioRaiseVolume", function() awful.spawn.with_shell("/home/usr/.local/bin/set-volume 1") end),
  awful.key({}, "XF86AudioLowerVolume", function() awful.spawn.with_shell("/home/usr/.local/bin/set-volume -1") end),
  awful.key({}, "XF86AudioMute", function() awful.spawn.with_shell("/home/usr/.local/bin/set-volume 0") end),
  awful.key({}, "XF86Suspend", function() awful.spawn.with_shell("/home/usr/.local/bin/suspend.sh") end),
  awful.key({}, "Print", function() awful.spawn.with_shell(openthe .. " screenshot-clip") end),
  awful.key({ "Shift" }, "Print", function() awful.spawn.with_shell(openthe .. " screenshot-noclip") end),
  awful.key({ Super }, "e", function() awful.spawn.with_shell(openthe .. " filemanager") end,
    { description = "filemanager", group = "launcher" }),
  awful.key({ Super }, "r", function() awful.spawn.with_shell(openthe .. " screenkey") end,
    { description = "screenkey", group = "launcher" }),
  awful.key({ Super }, "q", function() awful.spawn.with_shell(openthe .. " qq") end,
    { description = "qq", group = "launcher" }),
  awful.key({ Super }, "a", function() awful.spawn.with_shell(openthe .. " wechat") end,
    { description = "wechat", group = "launcher" }),
  awful.key({ Super }, "p", function() awful.spawn.with_shell(openthe .. " keepassx") end,
    { description = "password", group = "launcher" }),
  awful.key({ Super }, "c", function() awful.spawn.with_shell(openthe .. " office") end,
    { description = "office", group = "launcher" }),
  awful.key({ Super }, "space", function() awful.spawn.with_shell(openthe .. " dictionary") end,
    { description = "dictionary", group = "launcher" }),
  awful.key({ Alt }, "d", function() awful.spawn.with_shell(openthe .. " menu") end,
    { description = "menu", group = "launcher" }),
  awful.key({ Super }, "m", function() awful.spawn.with_shell("/home/usr/.local/bin/change-wallpaper") end,
    { description = "wallpaper", group = "launcher" }),
  awful.key({ Alt }, "e", function() awful.spawn.with_shell("/home/usr/.local/bin/numlock.sh") end,
    { description = "numlock", group = "launcher" }),
  awful.key({ Super }, "x", function() awful.spawn.with_shell(openthe .. " browser") end,
    { description = "browser", group = "launcher" }),
  awful.key({ Super }, "z", function() awful.spawn.with_shell(openthe .. " terminal") end,
    { description = "terminal", group = "launcher" }),
  awful.key({ Alt }, "b", function()
    mouse.screen.mywibox.visible = not mouse.screen.mywibox.visible
  end),
  awful.key({ Alt }, "n", function()
      poppin.pop("scratch", terminal, "center", {width = dpi(800), height = dpi(400) })
    end,
    { description = "scratch", group = "poppin" })

-- awful.key({ Alt, }, "space", function() awful.layout.inc(1) end,
--   { description = "select next", group = "layout" }),
-- awful.key({ Alt, "Shift" }, "space", function() awful.layout.inc(-1) end,
--   { description = "select previous", group = "layout" }),

-- Prompt
-- awful.key({ Alt }, "r", function() awful.screen.focused().mypromptbox:run() end,
--   { description = "run prompt", group = "launcher" }),

-- awful.key({ Alt }, "x",
--   function()
--     awful.prompt.run {
--       prompt       = "Run Lua code: ",
--       textbox      = awful.screen.focused().mypromptbox.widget,
--       exe_callback = awful.util.eval,
--       history_path = awful.util.get_cache_dir() .. "/history_eval"
--     }
--   end,
--   { description = "lua execute prompt", group = "awesome" })
-- Menubar
-- awful.key({ Alt }, "p", function() menubar.show() end,
--   { description = "show the menubar", group = "launcher" })
)

clientkeys = gears.table.join(
  awful.key({ Alt, }, "v", function(c) c:kill() end,
    { description = "close", group = "client" }),
  awful.key({ Alt, "Shift" }, "space", function(c)
    c.fullscreen = false
    c.maximized = false
    c.maximized_horizontal = false
    c.maximized_vertical = false
    c.floating = not c.floating
  end, { description = "toggle floating", group = "client" }),
  awful.key({ Alt, }, "Return", function(c) c:swap(awful.client.getmaster()) end,
    { description = "move to master", group = "client" }),
  awful.key({ Alt, }, "minus",
    function(c)
      -- The client currently has the input focus, so it cannot be
      -- minimized, since minimized clients can't have the focus.
      c.minimized = true
    end,
    { description = "minimize", group = "client" })
-- awful.key({ Alt, }, "o", function(c) c:move_to_screen() end,
--   { description = "move to screen", group = "client" }),
-- awful.key({ Alt, }, "t", function(c) c.ontop = not c.ontop end,
--   { description = "toggle keep on top", group = "client" }),
-- awful.key({ Alt, "Control" }, "m",
--   function(c)
--     c.maximized_vertical = not c.maximized_vertical
--     c:raise()
--   end,
--   { description = "(un)maximize vertically", group = "client" }),
-- awful.key({ Alt, "Shift" }, "m",
--   function(c)
--     c.maximized_horizontal = not c.maximized_horizontal
--     c:raise()
--   end,
--   { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = gears.table.join(globalkeys,
    -- View tag only.
    awful.key({ Alt }, "#" .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      { description = "view tag #" .. i, group = "tag" }),
    -- Toggle tag display.
    awful.key({ Alt, "Control" }, "#" .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
      { description = "toggle tag #" .. i, group = "tag" }),
    -- Move client to tag.
    awful.key({ Alt, "Shift" }, "#" .. i + 9,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end,
      { description = "move focused client to tag #" .. i, group = "tag" }),
    -- Toggle tag on focused client.
    awful.key({ Alt, "Control", "Shift" }, "#" .. i + 9,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:toggle_tag(tag)
          end
        end
      end,
      { description = "toggle focused client on tag #" .. i, group = "tag" })
  )
end

clientbuttons = gears.table.join(
  awful.button({}, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
  end),
  awful.button({ Alt }, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.move(c)
  end),
  awful.button({ Alt }, 3, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.resize(c)
  end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
      maximized_vertical = false,
      maximized_horizontal = false,
    }
  },

  -- Floating clients.
  {
    rule_any = {
      instance = {
        "DTA",   -- Firefox addon DownThemAll.
        "copyq", -- Includes session name in class.
        "pinentry",
      },
      class = {
        "Arandr",
        "Blueman-manager",
        "Gpick",
        "Kruler",
        "MessageWin",  -- kalarm.
        "Sxiv",
        "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
        "Wpa_gui",
        "veromix",
        "xtightvncviewer" },

      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
      name = {
        "Event Tester", -- xev.
      },
      role = {
        "AlarmWindow",   -- Thunderbird's calendar.
        "ConfigManager", -- Thunderbird's about:config.
        "pop-up",        -- e.g. Google Chrome's (detached) Developer Tools.
      }
    },
    properties = { floating = true }
  },

  -- Set Firefox to always map on the tag named "2" on screen 1.
  -- { rule = { class = "Firefox" },
  --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  -- buttons for the titlebar
  local buttons = gears.table.join(
    awful.button({}, 1, function()
      c:emit_signal("request::activate", "titlebar", { raise = true })
      awful.mouse.client.move(c)
    end),
    awful.button({}, 3, function()
      c:emit_signal("request::activate", "titlebar", { raise = true })
      awful.mouse.client.resize(c)
    end)
  )

  -- awful.titlebar(c):setup {
  --   { -- Left
  --     awful.titlebar.widget.iconwidget(c),
  --     buttons = buttons,
  --     layout  = wibox.layout.fixed.horizontal
  --   },
  --   {   -- Middle
  --     { -- Title
  --       align  = "center",
  --       widget = awful.titlebar.widget.titlewidget(c)
  --     },
  --     buttons = buttons,
  --     layout  = wibox.layout.flex.horizontal
  --   },
  --   { -- Right
  --     awful.titlebar.widget.floatingbutton(c),
  --     awful.titlebar.widget.maximizedbutton(c),
  --     awful.titlebar.widget.stickybutton(c),
  --     awful.titlebar.widget.ontopbutton(c),
  --     awful.titlebar.widget.closebutton(c),
  --     layout = wibox.layout.fixed.horizontal()
  --   },
  --   layout = wibox.layout.align.horizontal
  -- }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
local function set_border(c)
  local s = awful.screen.focused()
  if c.maximized
      or (#s.tiled_clients == 1 and not c.floating)
      or (s.selected_tag and s.selected_tag.layout.name == awful.layout.suit.max.name)
  then
    c.border_width = 0
  else
    c.border_width = beautiful.border_width
  end
end

client.connect_signal("request::border", set_border)
-- }}}

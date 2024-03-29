-----------------------------------------------------------------------------------------------------------------------
--                                          Hotkeys and mouse buttons config                                         --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local beautiful = require("beautiful")
local awful = require("awful")
local redflat = require("redflat")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local hotkeys = { settings = { slave = true}, mouse = {} }

-- key aliases
local sw = redflat.float.appswitcher
local current = redflat.widget.tasklist.filter.currenttags
local allscr = redflat.widget.tasklist.filter.allscreen
local laybox = redflat.widget.layoutbox
local tagsel = awful.tag.selected
local exaile = redflat.float.exaile
local redbar = redflat.titlebar

-- key functions
local br = function(args)
    redflat.float.brightness:change(args)
end

local focus_switch_byd = function(dir)
    return function()
        awful.client.focus.bydirection(dir)
        if client.focus then client.focus:raise() end
    end
end

local focus_previous = function()
    awful.client.focus.history.previous()
    if client.focus then client.focus:raise() end
end

local swap_with_master = function()
    if client.focus then client.focus:swap(awful.client.getmaster()) end
end

-- !!! Filters from tasklist used in 'all' functions !!!
-- !!! It's need a custom filter to best performance !!!
local function minimize_all()
    for _, c in ipairs(client.get()) do
        if current(c, mouse.screen) then c.minimized = true end
    end
end

local function restore_all()
    for _, c in ipairs(client.get()) do
        if current(c, mouse.screen) and c.minimized then c.minimized = false end
    end
end

local function kill_all()
    for _, c in ipairs(client.get()) do
        if current(c, mouse.screen) and not c.sticky then c:kill() end
    end
end

-- numeric key function
local function naction(i, handler, is_tag)
    return function ()
        if is_tag or client.focus then
            local tag = awful.tag.gettags(is_tag and mouse.screen or client.focus.screen)[i]
            if tag then handler(tag) end
        end
    end
end

-- volume functions
local volume_raise = function() redflat.widget.pulse:change_volume({ show_notify = true })              end
local volume_lower = function() redflat.widget.pulse:change_volume({ show_notify = true, down = true }) end
local volume_mute  = function() redflat.widget.pulse:mute() end

--other
local function toggle_placement()
    hotkeys.settings.slave = not hotkeys.settings.slave
    redflat.float.notify:show({
        text = (hotkeys.settings.slave and "Slave" or "Master") .. " placement",
        icon = beautiful.icon and beautiful.icon.warning
    })
end

-- Set key for widgets, layouts and other secondary stuff
-----------------------------------------------------------------------------------------------------------------------

-- custom widget keys
redflat.float.appswitcher.keys.next  = { "a", "A", "Tab" }
redflat.float.appswitcher.keys.prev  = { "q", "Q", }
redflat.float.appswitcher.keys.close = { "Super_L" }

-- layout keys
local resize_keys = {
    resize_up    = { "i", "I", },
    resize_down  = { "k", "K", },
    resize_left  = { "j", "J", },
    resize_right = { "l", "L", },
}

redflat.layout.common.keys = redflat.util.table.merge(redflat.layout.common.keys, resize_keys)
redflat.layout.grid.keys = redflat.util.table.merge(redflat.layout.grid.keys, resize_keys)
redflat.layout.map.keys = redflat.util.table.merge(redflat.layout.map.keys, resize_keys)
redflat.layout.map.keys = redflat.util.table.merge(redflat.layout.map.keys, { last = { "p", "P" } })


-- Build hotkeys depended on config parameters
-----------------------------------------------------------------------------------------------------------------------
function hotkeys:init(args)

    local args = args or {}
    self.menu = args.menu or redflat.menu({ items = { {"Empty menu"} } })
    self.browser = args.browser or "google-chrome %U --force-device-scale-factor=1.5"
    --self.browser = args.browser or "chromium-browser %U --force-device-scale-factor=1.5"
    self.calendar = args.calendar or "xterm -class Calcurse -e calcurse"
    self.clementine = args.clementine or "clementine"
    --self.cmus = args.mpd or "xterm -class Cmus -e cmus"
    self.firefox = args.firefox or "firefox"
    self.fm = args.fm or "/bin/sh -c ${HOME}/.scripts/rangerr"
    --self.fm = args.fm or "xterm -e ranger"
    self.glock = args.glock or "gnome-screensaver-command --lock"
    self.keepassx = args.keepassx or "keepassx"
    self.hangups = args.hangups or "terminator --classname=Hangups -e '${HOME}/.local/bin/hangups --col-scheme solarized-dark'"
    self.lock = args.lock or "/bin/sh -c ${HOME}/.scripts/lock"
    self.mail = args.mail or "/bin/sh -c ${HOME}/.scripts/muttt.sh"
    --self.mail = args.mail or "xterm -class Mutt -e ~/.local/bin/mut"
    self.mod = args.mod or "Mod4"
    self.mpd = args.mpd or "xterm -class MPD -e ncmpcpp"
    self.mpv = args.mpv or "mpv --profile=pseudo-gui"
    self.newsbeuter = args.newsbeuter or "xterm -e newsbeuter"
    self.nau = args.nau or "nautilus"
    self.off = args.off or "/bin/sh -c ${HOME}/.scripts/off"
    self.profanity = args.profanity or "terminator --classname=Profanity -e profanity"
    self.reboot = args.reboot or "/bin/sh -c ${HOME}/.scripts/boot"
    self.rs = args.rs or "tickr"
    self.scrot = args.scrot or "/bin/sh -c ${HOME}/.scripts/screenshot"
    self.smplayer = args.smp or "smplayer"
    self.ss = args.ss or "terminator --classname=SSH"
    self.suspend = args.suspend or "/bin/sh -c ${HOME}/.scripts/mysuspend"
    self.terminal = args.terminal or "x-terminal-emulator"
    self.virtualbox = args.virtualbox or "virtualbox"
    self.weechat = args.weechat or "/bin/sh-c ${HOME}/.scripts/weechatt"
    --self.weechat = args.weechat or "xterm -class Weechat -e weechat"
    self.windows = args.windows or "/bin/sh -c ${HOME}/.scripts/wm"
    self.xterm = args.xterm or "xterm"
    self.need_helper = args.need_helper or true

    -- Global keys
    --------------------------------------------------------------------------------
    self.raw_global = {
        { comment = "Power keys" },
        {
            args = { { "Mod1",      "Mod5" }, "p", function () awful.util.spawn(self.off) end },
            comment = "Poweroff"
        },
        {
            args = { { "Mod1",      "Mod5" }, "h", function () awful.util.spawn(self.reboot) end },
            comment = "Reboot"
        },
        {
            args = { { "Mod1",      "Mod5" }, "q", function () awful.util.spawn(self.suspend) end },
            comment = "Suspend to RAM"
        },
        {
            args = { {              "Mod1" }, "l", function () awful.util.spawn(self.glock) end },
            comment = "Gnome Lock"
        },
        {
            args = { {              "Mod5" }, "l", function () awful.util.spawn(self.lock) end },
            comment = "Screen Lock"
        },
        {
            args = { { self.mod, "Control" }, "r", awesome.restart },
            comment = "Restart awesome"
        },
        { comment = "Applications keys" },
        {
            args = { { self.mod,           }, "Return", function () awful.util.spawn(self.terminal) end },
            comment = "Terminator"
        },
        {
            args = { {              "Mod1" }, "x", function () awful.util.spawn(self.xterm) end },
            comment = "Xterm"
        },
        {
            args = { {              "Mod1" }, "v", function () awful.util.spawn(self.browser) end },
            comment = "Browser"
        },
        {
            args = { {              "Mod5" }, "t", function () awful.util.spawn(self.firefox) end },
            comment = "Firefox"
        },
        {
            args = { {              "Mod5" }, "z", function () awful.util.spawn(self.fm) end },
            comment = "Ranger"
        },
        {
            args = { {              "Mod1" }, "n", function () awful.util.spawn(self.nau) end },
            comment = "Nautilus"
        },
        {
            args = { {              "Mod5" }, "n", function () awful.util.spawn(self.mpd) end },
            comment = "Ncmpcpp"
        },
        --{
        --    args = { {              "Mod5" }, "n", function () awful.util.spawn(self.cmus) end },
        --    comment = "Cmus"
        --},
        {
            args = { {              "Mod5" }, "a", function () awful.util.spawn(self.mpv) end },
            comment = "Mpv"
        },
        {
            args = { {              "Mod5" }, "e", function () awful.util.spawn(self.smplayer) end },
            comment = "Smplayer"
        },
        {
            args = { {              "Mod5" }, "i", function () awful.util.spawn(self.clementine) end },
            comment = "Clementine"
        },
        {
            args = { {              "Mod5" }, "r", function () awful.util.spawn(self.rs) end },
            comment = "Tickr"
        },
        {
            args = { {              "Mod5" }, "m", function () awful.util.spawn(self.mail) end },
            comment = "Mutt"
        },
        {
            args = { {              "Mod5" }, "k", function () awful.util.spawn(self.keepassx) end },
            comment = "KeepassX"
        },
        {
            args = { {              "Mod5" }, "b", function () awful.util.spawn(self.newsbeuter) end },
            comment = "Newsbeuter"
        },
        {
            args = { {              "Mod5" }, "c", function () awful.util.spawn(self.calendar) end },
            comment = "Calcurse"
        },
        {
            args = { {              "Mod5" }, "s", function () awful.util.spawn(self.ss) end },
            comment = "SSH"
        },
        {
            args = { {              "Mod1" }, "w", function () awful.util.spawn(self.weechat) end },
            comment = "WeeChat"
        },
        {
            args = { {              "Mod1" }, "g", function () awful.util.spawn(self.profanity) end },
            comment = "Profanity"
        },
        {
            args = { {              "Mod5" }, "g", function () awful.util.spawn(self.hangups) end },
            comment = "Hangups"
        },
        {
            args = { {              "Mod1" }, "z", function () awful.util.spawn(self.virtualbox) end },
            comment = "VirtualBox"
        },
        {
            args = { {              "Mod1" }, "s", function () awful.util.spawn(self.windows) end },
            comment = "Windows VM"
        },
        {
            args = { {                     }, "Print", function () awful.util.spawn(self.scrot) end },
            comment = "PrintScreen"
        },
        {
            args = { { self.mod,           }, "h", function () hints.focus() end },
            comment = "Hints"
        },
        {
            args = { { self.mod,           }, "b", function () redflat.service.keyboard.handler() end },
            comment = "Window control mode"
        },
        { comment = "Window focus" },
        {
            args = { { self.mod,           }, "l", focus_switch_byd("right"), },
            comment = "Focus right client"
        },
        {
            args = { { self.mod,           }, "j", focus_switch_byd("left"), },
            comment = "Focus left client"
        },
        {
            args = { { self.mod,           }, "i", focus_switch_byd("up"), },
            comment = "Focus client above"
        },
        {
            args = { { self.mod,           }, "k", focus_switch_byd("down"), },
            comment = "Focus client below"
        },
        {
            args = { { self.mod,           }, "u", awful.client.urgent.jumpto, },
            comment = "Focus first urgent client"
        },
        {
            args = { { self.mod,           }, "Tab", focus_previous, },
            comment = "Return to previously focused client"
        },
        { comment = "Tag navigation" },
        {
            args = { { self.mod,           }, "Left", awful.tag.viewprev },
            comment = "View previous tag"
        },
        {
            args = { { self.mod,           }, "Right", awful.tag.viewnext },
            comment = "View next tag"
        },
        {
            args = { { self.mod,           }, "Escape", awful.tag.history.restore },
            comment = "View previously selected tag set"
        },
        { comment = "Widgets" },
        {
            args = { { self.mod,           }, "x", function() redflat.float.top:show() end },
            comment = "Show top widget"
        },
        {
            args = { { self.mod,           }, "w", function() hotkeys.menu:toggle() end },
            comment = "Open main menu"
        },
        {
            args = { { self.mod,           }, "y", function () laybox:toggle_menu(tagsel(mouse.screen)) end },
            comment = "Open layout menu"
        },
        {
            args = { { self.mod            }, "p", function () redflat.float.prompt:run() end },
            comment = "Run prompt"
        },
        {
            args = { { self.mod            }, "r", function() redflat.float.apprunner:show() end },
            comment = "Allication launcher"
        },
        {
            args = { {              "Mod1" }, "e", function() redflat.widget.minitray:toggle() end },
            comment = "Show minitray"
        },
        {
            args = { { self.mod            }, "e", function() exaile:show() end },
            comment = "Show exaile widget"
        },
        {
            args = { { self.mod            }, "F1", function() redflat.float.hotkeys:show() end },
            comment = "Show hotkeys helper"
        },
        {
            args = { { self.mod, "Control" }, "u", function () redflat.widget.upgrades:update(true) end },
            comment = "Check available upgrades"
        },
        {
            args = { { self.mod, "Control" }, "m", function () redflat.widget.mail:update() end },
            comment = "Check new mail"
        },
        { comment = "Application switcher" },
        {
            args = { { self.mod            }, "a", nil, function() sw:show({ filter = current }) end },
            comment = "Switch to next with current tag"
        },
        {
            args = { { self.mod            }, "q", nil, function() sw:show({ filter = current, reverse = true }) end },
            comment = "Switch to previous with current tag"
        },
        {
            args = { { self.mod, "Control" }, "a", nil, function() sw:show({ filter = allscr }) end },
            comment = "Switch to next through all tags"
        },
        {
            args = { { self.mod, "Control" }, "q", nil, function() sw:show({ filter = allscr, reverse = true }) end },
            comment = "Switch to previous through all tags"
        },
        { comment = "Exaile music player" },
        {
            args = { {                     }, "XF86AudioPlay", function() exaile:action("PlayPause") end },
            comment = "Play/Pause"
        },
        {
            args = { {                     }, "XF86AudioNext", function() exaile:action("Next") end },
            comment = "Next track"
        },
        {
            args = { {                     }, "XF86AudioPrev", function() exaile:action("Prev") end },
            comment = "Previous track"
        },
        { comment = "Volume control" },
        {
            args = { {                     }, "XF86AudioRaiseVolume", function () awful.util.spawn("pulseaudio-ctl up") end },
            --args = { {                     }, "XF86AudioRaiseVolume", function () awful.util.spawn("pactl -- set-sink-volume 1 +5%") end },
            comment = "Increase volume"
        },
        {
            args = { {                     }, "XF86AudioLowerVolume", function () awful.util.spawn("pulseaudio-ctl down") end },
            --args = { {                     }, "XF86AudioLowerVolume", function () awful.util.spawn("pactl -- set-sink-volume 1 -5%") end },
            comment = "Reduce volume"
        },
        {
            args = { {                     }, "XF86AudioMute", function () awful.util.spawn("pulseaudio-ctl mute") end },
            comment = "Toggle mute"
        },
        { comment = "Brightness control" },
        {
            args = { {                     }, "XF86MonBrightnessUp", function() br({ step = 5 }) end },
            comment = "Increase brightness"
        },
        {
            args = { {                     }, "XF86MonBrightnessDown", function() br({ step = 5, down = 1 }) end },
            comment = "Reduce brightness"
        },
        { comment = "Window manipulation" },
        {
            args = { { self.mod,           }, "F3", toggle_placement },
            comment = "Toggle master/slave placement"
        },
        {
            args = { { self.mod, "Control" }, "Return", swap_with_master },
            comment = "Swap focused client with master"
        },
        {
            args = { { self.mod, "Control" }, "n", awful.client.restore },
            comment = "Restore first minmized client"
        },
        {
            args = { { self.mod, "Shift"   }, "n", minimize_all },
            comment = "Minmize all with current tag"
        },
        {
            args = { { self.mod, "Control", "Shift" }, "n", restore_all },
            comment = "Restore all with current tag"
        },
        {
            args = { { self.mod, "Shift"   }, "F4", kill_all },
            comment = "Kill all with current tag"
        },
        { comment = "Layouts" },
        {
            args = { { self.mod,           }, "Up", function () awful.layout.inc(layouts, 1) end },
            comment = "Switch to next layout"
        },
        {
            args = { { self.mod,           }, "Down", function () awful.layout.inc(layouts, - 1) end },
            comment = "Switch to previous layout"
        },
        { comment = "Titlebar" },
        {
            args = { { self.mod,           }, "comma", function (c) redbar.toggle_group(client.focus) end },
            comment = "Switch to next client in group"
        },
        {
            args = { { self.mod,           }, "period", function (c) redbar.toggle_group(client.focus, true) end },
            comment = "Switch to previous client in group"
        },
        {
            args = { { self.mod,           }, "t", function (c) redbar.toggle_view(client.focus) end },
            comment = "Toggle focused titlebar view"
        },
        {
            args = { { self.mod, "Shift"   }, "t", function (c) redbar.toggle_view_all() end },
            comment = "Toggle all titlebar view"
        },
        {
            args = { { self.mod, "Control" }, "t", function (c) redbar.toggle(client.focus) end },
            comment = "Toggle focused titlebar visible"
        },
        {
            args = { { self.mod, "Control", "Shift" }, "t", function (c) redbar.toggle_all() end },
            comment = "Toggle all titlebar visible"
        },
        { comment = "Tile control" },
        {
            args = { { self.mod, "Shift"   }, "j", function () awful.tag.incnmaster(1) end },
            comment = "Increase number of master windows by 1"
        },
        {
            args = { { self.mod, "Shift"   }, "l", function () awful.tag.incnmaster(-1) end },
            comment = "Decrease number of master windows by 1"
        },
        {
            args = { { self.mod, "Control" }, "j", function () awful.tag.incncol(1) end },
            comment = "Increase number of non-master columns by 1"
        },
        {
            args = { { self.mod, "Control" }, "l", function () awful.tag.incncol(-1) end },
            comment = "Decrease number of non-master columns by 1"
        }
    }

    -- Client keys
    --------------------------------------------------------------------------------
    self.raw_client = {
        { comment = "Client keys" }, -- fake element special for hotkeys helper
        {
            args = { { self.mod,           }, "f", function (c) c.fullscreen = not c.fullscreen end },
            comment = "Set client fullscreen"
        },
        {
            args = { { self.mod,           }, "s", function (c) c.sticky = not c.sticky end },
            comment = "Toogle client sticky status"
        },
        {
            args = { { self.mod,           }, "F4", function (c) c:kill() end },
            comment = "Kill focused client"
        },
        {
            args = { { self.mod, "Control" }, "f", awful.client.floating.toggle },
            comment = "Toggle client floating status"
        },
        {
            args = { { self.mod, "Control" }, "p", function (c) c.ontop = not c.ontop end },
            comment = "Toggle client ontop status"
        },
        {
            args = { { self.mod,           }, "n", function (c) c.minimized = true end },
            comment = "Minimize client"
        },
        {
            args = { { self.mod,           }, "m", function (c) c.maximized = not c.maximized end },
            comment = "Maximize client"
        }
    }

    -- Bind all key numbers to tags
    --------------------------------------------------------------------------------
    local num_tips = { { comment = "Numeric keys" } } -- this is special for hotkey helper

    local num_bindings = {
        {
            mod     = { self.mod },
            args    = { awful.tag.viewonly, true },
            comment = "Switch to tag"
        },
        {
            mod     = { self.mod, "Control" },
            args    = { awful.tag.viewtoggle, true },
            comment = "Toggle tag view"
        },
        {
            mod     = { self.mod, "Shift" },
            args    = { awful.client.movetotag },
            comment = "Tag client with tag"
        },
        {
            mod     = { self.mod, "Control", "Shift" },
            args    = { awful.client.toggletag },
            comment = "Toggle tag on client"
        }
    }

    -- bind
    self.num = {}

    for k, v in ipairs(num_bindings) do
        -- add fake key to tip table
        num_tips[k + 1] = { args = { v.mod, "1 .. 9" }, comment = v.comment, codes = {} }
        for i = 1, 9 do
            table.insert(num_tips[k + 1].codes, i + 9)
            -- add numerical key objects to global
            self.num = awful.util.table.join(
                self.num, awful.key(v.mod, "#" .. i + 9, naction(i, unpack(v.args)))
            )
        end
    end

    -- Mouse bindings
    --------------------------------------------------------------------------------

    -- global
    self.mouse.global = awful.util.table.join(
        awful.button({}, 3, function () self.menu:toggle() end)
        --awful.button({}, 4, awful.tag.viewnext),
        --awful.button({}, 5, awful.tag.viewprev)
    )

    -- client
    self.mouse.client = awful.util.table.join(
        awful.button({                     }, 1, function (c) client.focus = c; c:raise() end),
        awful.button({                     }, 2, redflat.service.mouse.move),
        awful.button({ self.mod            }, 3, redflat.service.mouse.resize),
        awful.button({                     }, 8, function(c) c:kill() end)
    )


    -- Hotkeys helper setup
    --------------------------------------------------------------------------------
    if self.need_helper then
        redflat.float.hotkeys.raw_keys = awful.util.table.join(self.raw_global, self.raw_client, num_tips)
    end

    self.client = redflat.util.table.join_raw(hotkeys.raw_client, awful.key)
    self.global = redflat.util.table.join_raw(hotkeys.raw_global, awful.key)
    self.global = awful.util.table.join(self.global, hotkeys.num)
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return hotkeys

-----------------------------------------------------------------------------------------------------------------------
--                                                  Menu config                                                      --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local beautiful = require("beautiful")
local redflat = require("redflat")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local menu = {}

-- Menu configuration
--------------------------------------------------------------------------------

-- icon finder
local function micon(name)
	return redflat.service.dfparser.lookup_icon(name, icon_style)
end

-- run commands
local ranger_command  = "terminator -e ranger"
local suspend_command = [[/bin/sh -c "~/.local/bin/lock && sleep 3 && /bin/systemctl suspend"]]
local reboot_command = [[/bin/sh -c "/bin/systemctl reboot"]]
local lock_command = [[/bin/sh -c "~/.local/bin/lock"]]
local poweroff_command = [[/bin/sh -c "/bin/systemctl poweroff"]]

-- Build function
--------------------------------------------------------------------------------
function menu.build(args)

	local args = args or {}
	local fm = args.fm or "nautilus"
	local separator = args.separator or { widget = redflat.gauge.separator.horizontal() }
	local theme = args.theme or {}
	local icon_style = args.icon_style or {}

	-- Application submenu
	------------------------------------------------------------
	local appmenu = redflat.service.dfparser.menu({ icons = icon_style, wm_name = "awesome" })

	-- Awesome submenu
	------------------------------------------------------------
	local awesomemenu = {
		{ "Edit config",     "gedit " .. awesome.conffile,  micon("gnome-system-config")  },
		{ "Restart",         awesome.restart,               micon("gnome-session-reboot") },
		{ "Quit",            awesome.quit,                  micon("exit")                 },
		separator,
		{ "Awesome config",  fm .. " .config/awesome",        micon("folder-bookmarks") },
		{ "Awesome lib",     fm .. " /usr/share/awesome/lib", micon("folder-bookmarks") }
	}

	-- Exit submenu
	------------------------------------------------------------
	local exitmenu = {
		{ "Reboot",          reboot_command,              micon("gnome-session-reboot")  },
		{ "Switch user",     "dm-tool switch-to-greeter", micon("gnome-session-switch")  },
		{ "Suspend",         suspend_command,             micon("gnome-session-suspend") }
	}

	-- Places submenu
	------------------------------------------------------------
	local placesmenu = {
		{ "Documents",   fm .. " Documents", micon("folder-documents") },
		{ "Downloads",   fm .. " Downloads", micon("folder-download")  },
		{ "Music",       fm .. " Music",     micon("folder-music")     },
		{ "Pictures",    fm .. " Pictures",  micon("folder-pictures")  },
		{ "Videos",      fm .. " Videos",    micon("folder-videos")    },
		separator,
		{ "AMV",         fm .. " /media/video/AMV", micon("folder-bookmarks") }
	}

	-- Main menu
	------------------------------------------------------------
	local mainmenu = redflat.menu({ hide_timeout = 1, theme = theme,
		items = {
			{ "Awesome",         awesomemenu,            beautiful.icon.awesome },
			{ "Applications",    appmenu,                micon("distributor-logo")        },
			{ "Places",          placesmenu,             micon("folder_home"), key = "c"  },
			separator,
			{ "Chromium",        "chromium",             micon("chromium")                },
			{ "Firefox",         "firefox",              micon("")                        },
			{ "Nautilus",        "nautilus",             micon("folder")                  },
			{ "Ranger",          ranger_command,         micon("folder")                  },
			{ "Gedit",           "gedit",                micon("gedit")                   },
			{ "Exaile",          "exaile",               micon("")                        },
			separator,
			{ "Exit",            exitmenu,               micon("exit")                    },
			{ "Lock",            lock_command,           micon("system-shutdown")         },
			{ "Shutdown",        poweroff_command,       micon("system-shutdown")         }
		}
	})

	return mainmenu
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return menu

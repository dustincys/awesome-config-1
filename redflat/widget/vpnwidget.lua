-- add this to your rc.lua, or include it as a dependency

-- Don't forget to add this to the layout section:
-- right_layout:add(vpnwidget)

vpnwidget = wibox.widget.textbox()
vpnwidget:set_text(" VPN: N/A ")
vpnwidgettimer = timer({ timeout = 5 })
vpnwidgettimer:connect_signal("timeout",
  function()
    status = io.popen("ls /var/run | grep 'openvpn'", "r")
    if status:read() == nil then
        vpnwidget:set_markup(" <span color='#FF0000'>VPN: OFF</span> ")
    else
        vpnwidget:set_markup(" <span color='#00FF00'>VPN: ON</span> ")
    end
    status:close()
  end
)
vpnwidgettimer:start()

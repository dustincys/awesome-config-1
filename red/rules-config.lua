-----------------------------------------------------------------------------------------------------------------------
--                                                Rules config                                                       --
-----------------------------------------------------------------------------------------------------------------------

-- Grab environment
local awful =require("awful")

-- Initialize tables and vars for module
-----------------------------------------------------------------------------------------------------------------------
local rules = {}

-- Build rule table
-----------------------------------------------------------------------------------------------------------------------
function rules:build(args)

    local args = args or {}
    local tags = args.tags or {} -- bad !!!

    local user_rules = {
        {
            rule = { class = "Tickr" },
            properties = { border_width = 0, floating = true, sticky = true, ontop = true }
        },
        {
            rule = { class = "Pidgin" },
            properties = { tag = tags[1][2], floating = false, switchtotag = false }
        },
        {
            rule = { class = "Pidgin", role = "buddy_list" or "conversation"},
            properties = { floating = true },
            callback = function(c)
                local w_area = screen[ c.screen ].workarea local winwidth = 200
                c:struts( { right = winwidth } ) c:geometry( { x = w_area.width - winwidth, width = winwidth, y = w_area.y, height = w_area.height } )
                --c.minimized = true
            end
        },
        {
            rule = { class = "Hangups", role = "Terminator" },
            properties = { tag = tags[1][3], floating = false, switchtotag = false }
        },
        {
            rule = { class = "Evolution" },
            properties = { tag = tags[1][2], switchtotag = false }
        },
        {
            rule = { class = "Xterm" },
            properties = { tag = tags[1][2], switchtotag = false }
        },
        {
            rule = { class = "Mutt" },
            properties = { tag = tags[1][2], switchtotag = true }
        },
        {
            rule = { class = "Weechat" },
            properties = { tag = tags[1][5], switchtotag = false }
        },
        {
            rule = { class = "SSH" },
            properties = { tag = tags[1][5], switchtotag = false }
        },
        {
            rule = { class = "VirtualBox" },
            --except = { name = "Oracle VM VirtualBox Manager" },
            properties = { tag = tags[1][6], switchtotag = false }
        },
        {
            rule       = { class = "google-chrome" }, except = { role = "google-chrome" },
            properties = { floating = false }
        },
        {
            rule_any   = { class = { "pinentry", "Plugin-container" } },
            properties = { floating = true }
        },
        {
            rule       = { class = "Key-mon" },
            properties = { sticky = true }
        },
        {
            rule = { class = "Exaile" },
            callback = function(c)
                for _, exist in ipairs(awful.client.visible(c.screen)) do
                    if c ~= exist and c.class == exist.class then
                        awful.client.floating.set(c, true)
                        return
                    end
                end
                awful.client.movetotag(tags[1][3], c)
                c.minimized = false
            end
        },
        {
            rule = { class = "Clementine" },
            callback = function(c)
                for _, exist in ipairs(awful.client.visible(c.screen)) do
                    if c ~= exist and c.class == exist.class then
                        awful.client.floating.set(c, true)
                        return
                    end
                end
                awful.client.movetotag(tags[1][3], c)
                c.minimized = false
            end
        },
    }
    return user_rules
end

-- End
-----------------------------------------------------------------------------------------------------------------------
return rules

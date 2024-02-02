HUD = {}

HUD.colors = {
    ["red"] = 0xFF0000,
    ["blue"] = 0x0000FF,
    ["yellow"] = 0xEEEE00,
    ["green"] = 0x00FF00,
    ["black"] = 0x000000,
    ["white"] = 0xFFFFFF,
    ["purple"] = 0xFF00FF,
    ["violet"] = 0xDD22DD,
}

HUD.players = {}

HUD.init_HUD = function(player)
    local bg = player:hud_add({
        hud_elem_type = "image",
        position  = {x = 1, y = 0.225},
        offset    = {x = -2, y = 0},
        text      = "HUD_bg.png",
        scale     = { x = 1, y = 1},
        alignment = { x = -1, y = 0 },
    })
    local thud = player:hud_add({ -- thud, short for Team HUD :)
        hud_elem_type = "text",
        position      = {x = 1, y = 0.025}, -- pos normalized (-1 to 1)
        offset        = {x = -64,   y = 0}, -- ofset (px)
        text          = "Team: " .. teams.get_team(player:get_player_name()),
        alignment     = {x = -1, y = 0}, -- alignment normalized (-1 to 1)
        scale         = {x = 100, y = 100}, -- scale (px)
        number        = HUD.colors[teams.get_team(player:get_player_name())], -- color (hex) using table to convert colortext to hex
    })
    local khud = player:hud_add({ -- khud, short for Kill HUD :)
        hud_elem_type = "text",
        position      = {x = 1, y = 0.05}, -- pos normalized (-1 to 1)
        offset        = {x = -64,   y = 0}, -- ofset (px)
        text          = "Kills: " .. teams.players[player:get_player_name()].kills .. " / " .. teams.teams[teams.get_team(player:get_player_name())].kills,
        alignment     = {x = -1, y = 0}, -- alignment normalized (-1 to 1)
        scale         = {x = 100, y = 100}, -- scale (px)
        number        = HUD.colors[teams.get_team(player:get_player_name())], -- color (hex) using table to convert colortext to hex
    })
    local dhud = player:hud_add({ -- dhud, short for Death HUD :)
        hud_elem_type = "text",
        position      = {x = 1, y = 0.075}, -- pos normalized (-1 to 1)
        offset        = {x = -64,   y = 0}, -- ofset (px)
        text          = "Deaths: " .. teams.players[player:get_player_name()].deaths .. " / " .. teams.teams[teams.get_team(player:get_player_name())].deaths,
        alignment     = {x = -1, y = 0}, -- alignment normalized (-1 to 1)
        scale         = {x = 100, y = 100}, -- scale (px)
        number        = HUD.colors[teams.get_team(player:get_player_name())], -- color (hex) using table to convert colortext to hex
    })
    HUD.players[player:get_player_name()] = {background = bg, teamhud = thud, killhud = khud, deathhud = dhud, name = player:get_player_name()}
end

HUD.update_HUD = function(player)
    local hudp = HUD.players[player:get_player_name()]
    player:hud_change(hudp.teamhud, "text", "Team: " .. teams.get_team(player:get_player_name()))
    player:hud_change(hudp.killhud, "text", "Kills: " .. teams.players[player:get_player_name()].kills .. " / " .. teams.teams[teams.get_team(player:get_player_name())].kills)
    player:hud_change(hudp.deathud, "text", "Deaths: " .. teams.players[player:get_player_name()].deaths .. " / " .. teams.teams[teams.get_team(player:get_player_name())].deaths)
    minetest.log("updated hud for player: " .. player.name)
end

HUD.remove_HUD = function(player)
    local hudp = HUD.players[player:get_player_name()]
    player:hud_remove(hudp.background)
    player:hud_remove(hudp.teamhud)
    player:hud_remove(hudp.killhud)
    player:hud_remove(hudp.deathud)
    HUD.players[hudp.name] = nil
end
--player:hud_change(idx, "text", "New Text")

HUD.update_all = function(player)
    minetest.log("updating hud")
    for i, player in ipairs(teams.players) do
        minetest.log("updating hud for player: " .. player.name)
        HUD.update_HUD(minetest.get_player_by_name(player.name))
    end
end

local on_joinplayer = function(player)
    HUD.init_HUD(player)
end

minetest.register_on_joinplayer(function(player, last_login)
	on_joinplayer(player)
end)

teams.register_die_callback("update_hud", function(player, team)
	minetest.log("player died")
	HUD.update_all(player)
end)

minetest.register_chatcommand("hud", {
    privs = {
        interact = true,
    },
	description = "Usage: hud show\n" ..
    "                        hud hide\n" ..
    "                        hud update\n" ..
    "                        hud update all\n" ..
    "                        hud reset",
    func = function(name, param)
		local parts = param:split(" ")
		local cmd = parts[1]
        local player = minetest.get_player_by_name(name)

		if cmd == "show" then
			on_joinplayer(player)
        elseif cmd == "hide" then
            HUD.remove_HUD(player)
        elseif cmd == "update" then
            local cmd2 = parts[2]
            if cmd2 == "all" then
                HUD.update_all(player)
            else
                HUD.update_HUD(player)
            end
        elseif cmd == "reset" then
            HUD.init_HUD(player)
		else
			return true, "Usage: hud <cmd> [cmd2]"
		end
	end,
})

--[[
    local param2 = parts[2]
    if param2 == "all" then
        shop.remove_upgrades(minetest.get_player_by_name(name))
        return true, "Removed all upgrades"
    elseif shop.find_upgrade(param2) then
        shop.remove_upgrade(minetest.get_player_by_name(name), param2)
        return true, "Removed upgrade: " .. param2
    else
        return false, "Must give an upgrade to remove"
    end
]]
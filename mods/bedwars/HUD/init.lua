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

HUD.create_text = function(type, player)
    if teams.players[player:get_player_name()].is_playing then
        if type == "team" then
            return "Team: " .. teams.get_team(player:get_player_name())
        elseif type == "kills" then
            return "Kills: " .. teams.players[player:get_player_name()].kills .. " / " .. teams.teams[teams.get_team(player:get_player_name())].kills
        elseif type == "deaths" then
            return "Deaths: " .. teams.players[player:get_player_name()].deaths .. " / " .. teams.teams[teams.get_team(player:get_player_name())].deaths
        end
    end
end

HUD.remove_HUD = function(player)
    local hudp = HUD.players[player:get_player_name()]
    player:hud_remove(hudp.background)
    player:hud_remove(hudp.teamhud)
    player:hud_remove(hudp.killhud)
    player:hud_remove(hudp.deathhud)
    HUD.players[hudp.name] = nil
end

HUD.init_HUD = function(player)
    if HUD.players[player:get_player_name()] then
        HUD.remove_HUD(player)
    end
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
        text          = HUD.create_text("team", player),
        alignment     = {x = -1, y = 0}, -- alignment normalized (-1 to 1)
        scale         = {x = 100, y = 100}, -- scale (px)
        number        = HUD.colors[teams.get_team(player:get_player_name())], -- color (hex) using table to convert colortext to hex
    })
    local khud = player:hud_add({ -- khud, short for Kill HUD :)
        hud_elem_type = "text",
        position      = {x = 1, y = 0.05}, -- pos normalized (-1 to 1)
        offset        = {x = -64,   y = 0}, -- ofset (px)
        text          = HUD.create_text("kills", player),
        alignment     = {x = -1, y = 0}, -- alignment normalized (-1 to 1)
        scale         = {x = 100, y = 100}, -- scale (px)
        number        = HUD.colors[teams.get_team(player:get_player_name())], -- color (hex) using table to convert colortext to hex
    })
    local dhud = player:hud_add({ -- dhud, short for Death HUD :)
        hud_elem_type = "text",
        position      = {x = 1, y = 0.075}, -- pos normalized (-1 to 1)
        offset        = {x = -64,   y = 0}, -- ofset (px)
        text          = HUD.create_text("deaths", player),
        alignment     = {x = -1, y = 0}, -- alignment normalized (-1 to 1)
        scale         = {x = 100, y = 100}, -- scale (px)
        number        = HUD.colors[teams.get_team(player:get_player_name())], -- color (hex) using table to convert colortext to hex
    })
    HUD.players[player:get_player_name()] = {background = bg, teamhud = thud, killhud = khud, deathhud = dhud, name = player:get_player_name()}
end

HUD.update_HUD = function(player)
    local hudp = HUD.players[player:get_player_name()]
    if hudp ~= nil and teams.players[player:get_player_name()].is_playing then
        player:hud_change(hudp.teamhud, "text", HUD.create_text("team", player))
        player:hud_change(hudp.killhud, "text", HUD.create_text("kills", player))
        player:hud_change(hudp.deathhud, "text", HUD.create_text("deaths", player))
    elseif hudp ~= nil then
        HUD.remove_HUD(player)
    end
    --minetest.log("updated hud for player: " .. player:get_player_name())
end
--player:hud_change(idx, "text", "New Text")

HUD.update_all = function()
    --minetest.log("updating hud") -- for debug only
    for pn in pairs(teams.players) do
        --minetest.log("updating hud for player: " .. pn) -- for debug only
        HUD.update_HUD(minetest.get_player_by_name(pn))
    end
end

teams.register_join_callback("init_hud", {
    name = "init_hud",
    func = function(player, team)
        --minetest.log("player joined")
        HUD.init_HUD(player)
    end
})

teams.register_start_callback("update_hud", {
    name = "update_hud",
    func = function(player, team)
        --minetest.log("game started")
        HUD.update_all()
    end
})

teams.register_die_callback("update_hud", {
    name = "update_hud",
    func = function(player, team)
        --minetest.log("player died")
        HUD.update_all()
    end
})

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
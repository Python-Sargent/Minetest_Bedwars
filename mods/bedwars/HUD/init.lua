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
    local hudp = HUD.players(player:get_player_name())
    player:hud_change(hudp.teamhud, "text", "Team: " .. teams.get_team(player:get_player_name()))
    player:hud_change(hudp.killhud, "text", "Kills: " .. teams.players[player:get_player_name()].kills .. " / " .. teams.teams[teams.get_team(player:get_player_name())].kills)
    player:hud_change(hudp.deathud, "text", "Deaths: " .. teams.players[player:get_player_name()].deaths .. " / " .. teams.teams[teams.get_team(player:get_player_name())].deaths)
    minetest.log("updated hud for player: " .. player.name)
end

--player:hud_change(idx, "text", "New Text")

HUD.update_all = function(player)
    minetest.log("updating hud")
    for i, player in ipairs(teams.players) do
        minetest.log("updating hud for player: " .. player.name)
        HUD.update_HUD(minetest.get_player_by_name(player.name))
    end
end

minetest.register_on_joinplayer(function(player, last_login)
	HUD.init_HUD(player)
    minetest.log("player joined")
end)

teams.register_die_callback("update_hud", function(player, team)
	minetest.log("player died")
	HUD.update_all(player)
end)
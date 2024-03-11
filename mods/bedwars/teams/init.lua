teams = {}

teams.teams = {}

teams.lobby = {}

teams.lobby.current = {
	name = "Lobby1",
	spawn = vector.new(434, 4, 435)
}

teams.lobby.queuing_room = {}
teams.lobby.queuing_room.current = {
	name = "Skeletol",
	spawn = vector.new(10, 504 ,10),
	path = "/schematics/QueuingRoom.mts",
	author = "SuperStarSonic",
}

teams.maps = {}

local modpath = minetest.get_modpath("teams")

teams.maps.current_map = {
	name = "Galactuim",
	teams = {
		["red"] = {name = "red", spawn = {x=27, y=1, z=22}},
		["blue"] = {name = "blue", spawn = {x=27, y=1, z=116}},
	},
	max_players = 2,
	start = {x = 27, y = 0, z = 69},
	path = "",
	size = {x=55, y=35, z=137},
	init = function()
		minetest.clear_objects({mode = "quick"})
		local place = {x=0, y=-10, z=0}
		minetest.place_schematic(place, modpath .. "/schematics/Galactium2p_Map.mts", nil, nil, true)
		local node_positions, node_names = minetest.find_nodes_in_area(place, vector.add(place, teams.maps.current_map.size), {
			"item_spawners:forge_red", "item_spawners:forge_blue",
		})

		for i, pos in ipairs(node_positions) do
			minetest.registered_nodes["item_spawners:forge_red"].on_construct(pos)
		end
	end,
	author = "SuperStarSonic",
}

teams.maps["Galactium"] = {
	name = "Galactuim 2 Player",
	teams = {
		["red"] = {name = "red", spawn = {x=27, y=1, z=22}},
		["blue"] = {name = "blue", spawn = {x=27, y=1, z=116}},
	},
	max_players = 2,
	start = {x = 27, y = 0, z = 69},
	size = {x=121, y=12, z=183},
	init = function()
		minetest.clear_objects({mode = "quick"})
		minetest.place_schematic({x=0, y=-10, z=0}, modpath .. "/schematics/Galactium2p_Map.mts", nil, nil, true)
		local node_positions, node_names = minetest.find_nodes_in_area({x=0,y=0,z=0}, vector.add({x=0,y=0,z=0}, teams.maps.current_map.size), {
			"item_spawners:forge_red", "item_spawners:forge_blue",
		})

		for i, pos in ipairs(node_positions) do
			minetest.registered_nodes["item_spawners:forge_red"].on_construct(pos)
		end
	end,
	author = "SuperStarSonic",
}

teams.maps["Asterisk2p"] = {
	name = "Asterisk 2 Player",
	teams = {
		["red"] = {name = "red", spawn = {x=-340, y=-3, z=177}},
		["blue"] = {name = "blue", spawn = {x=-340, y=-3, z=5}},
	},
	max_players = 2,
	start = {x = -340, y = -7, z = 93},
	size = {x=55, y=35, z=137},
	init = function()
		minetest.clear_objects({mode = "quick"})
		local place = {x=-400, y=-10, z=0}
		minetest.place_schematic(place, modpath .. "/schematics/Asterisk2p_Map.mts", nil, nil, true)
		local node_positions, node_names = minetest.find_nodes_in_area(place, vector.add(place, teams.maps.current_map.size), {
			"item_spawners:forge_red", "item_spawners:forge_blue",
		})

		for i, pos in ipairs(node_positions) do
			minetest.registered_nodes["item_spawners:forge_red"].on_construct(pos)
		end
	end,
	author = "SuperStarSonic",
}

teams.maps["CloverLeaf2p"] = {
	name = "Clover Leaf 2 Player",
	teams = {
		["red"] = {name = "red", spawn = {x=-566, y=3, z=20}},
		["blue"] = {name = "blue", spawn = {x=-780, y=3, z=20}},
	},
	max_players = 2,
	start = {x = -673, y = 0, z = 20},
	size = {x=254, y=42, z=42},
	init = function()
		minetest.clear_objects({mode = "quick"})
		local place = {x=-800, y=-10, z=0}
		minetest.place_schematic(place, modpath .. "/schematics/CloverLeaf2p_Map.mts", nil, nil, true)
		local node_positions, node_names = minetest.find_nodes_in_area(place, vector.add(place, teams.maps.current_map.size), {
			"item_spawners:forge_red", "item_spawners:forge_blue",
		})

		for i, pos in ipairs(node_positions) do
			minetest.registered_nodes["item_spawners:forge_red"].on_construct(pos)
		end
	end,
	author = "Wilderness7272",
}

--[[teams.maps.maplist = {}

teams.register_map = function(name, teams)
	teams.maps.maplist[name] = {
		name = name,
		teams = teams,
	}
end

teams.unregister_map = function(name)
	teams.maps.maplist[name] = nil
end]]

teams.players = {
	--[[
		["singleplayer"] = {
			team = "red", -- what team is this player on
			name = "singleplayer", -- what is this player's name
			kills = 0, -- how many times has this player kill another player
			deaths = 0, -- how many times has this player died
			beds = 0, -- how many beds has this player destroyed
		},
	]]--
}

teams.game = {
	is_running = false,
	waiting_players = 0,
}

teams.init = function()
	local dyes = dye.dyes -- obtain list of dyes from the dyes mod

	for i = 1, #dyes do -- create team for each dye color
		local name, desc = unpack(dyes[i]) -- unpack dye into name and desc vars

		teams.teams[name] = { -- create team dict structure from the variable name that was unpacked from dyes
			name = name, -- name of the team (ex. 'red')
			kills = 0, -- kill amount of the team
			deaths = 0, -- death amount of the team
			has_bed = true, -- whether the team still has it's bed
			players = {}, -- dict of players in this team
		}
	end
end

teams.init_team = function(tn)
	teams.teams[tn] = {
		name = tn, -- name of the team (ex. 'red')
		kills = 0, -- kill amount of the team
		deaths = 0, -- death amount of the team
		has_bed = true, -- whether the team still has it's bed
		players = {}, -- dict of players in this team
	}
end

teams.chat_send_all = function(message)
	for pn in pairs(teams.players) do
		if teams.players[pn].is_playing == true or teams.players[pn].waiting == true then
			minetest.chat_send_player(pn, message)
		end
	end
end

teams.init()

teams.get_team = function(pn) -- get the team name of the player using player name
	if teams.players[pn] then return teams.players[pn].team end
	return "" --missing player, just return empty string
end

teams.lent = function(T) -- Length of Table or LenT (lent) similar name as the python len() function
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end
	
local teleport_particlespawner = {
    amount = 2000,
    time = 3,
    vertical = true,
    texture = "teams_teleport.png",
    glow = 5,
    minpos = {x=-0.5, y=-0.5, z=-0.5},
    maxpos = {x=0.5, y=0, z=0.5},
    minvel = {x=0, y=2, z=0},
    maxvel = {x=0, y=3, z=0},
    minacc = {x=0, y=2, z=0},
    maxacc = {x=0, y=3, z=0},
    minexptime = 3,
    maxexptime = 6,
    minsize = 2,
    maxsize = 3,
}

teams.add_teleport_particlespawner = function(pos)
	local particlespawner = teleport_particlespawner
	particlespawner.minpos = vector.offset(pos, particlespawner.minpos.x, particlespawner.minpos.y, particlespawner.minpos.z)
	particlespawner.maxpos = vector.offset(pos, particlespawner.maxpos.x, particlespawner.maxpos.y, particlespawner.maxpos.z)
	minetest.add_particlespawner{particlespawner}
end

teams.select_map = function(mapname)
	if teams.game.is_running ~= true then
		teams.maps.current_map = teams.maps[mapname]
		teams.chat_send_all("Map Selected: " .. teams.maps[mapname].name)
		minetest.log("Map name: " .. teams.maps.current_map.name)
		teams.maps.current_map.init()
	end
end

local leave_callbacks = {}

teams.register_leave_callback = function(name, callback)
	leave_callbacks[name] = callback
end

local run_leave_callbacks = function(player, team)
	for callback in pairs(leave_callbacks) do
		leave_callbacks[callback].func(player, team)
	end
end

local join_callbacks = {}

teams.register_join_callback = function(name, callback)
	join_callbacks[name] = callback
end

local run_join_callbacks = function(player, team)
	for callback in pairs(join_callbacks) do
		join_callbacks[callback].func(player, team)
	end
end

local die_callbacks = {}

teams.register_die_callback = function(name, callback)
	die_callbacks[name] = callback
end

local run_die_callbacks = function(player, team, reason)
	for callback in pairs(die_callbacks) do
		die_callbacks[callback].func(player, team, reason)
	end
end

local start_callbacks = {}

teams.register_start_callback = function(name, callback)
	start_callbacks[name] = callback
end

local run_start_callbacks = function()
	for callback in pairs(start_callbacks) do
		start_callbacks[callback].func()
	end
end

local end_callbacks = {}

teams.register_end_callback = function(name, callback)
	end_callbacks[name] = callback
end

local run_end_callbacks = function(winning_team)
	for callback in pairs(end_callbacks) do
		end_callbacks[callback].func(winning_team)
	end
end

teams.spawn = function(player)
	if teams.players[player:get_player_name()] and teams.players[player:get_player_name()].is_playing then
		player:respawn() -- respawn the player
		player:set_hp(16, "respawn")
		player:set_pos(teams.maps.current_map.teams[teams.get_team(player:get_player_name())].spawn)
		local inv = player:get_inventory()
		if not inv:contains_item("main", "default:sword_wood 1") then
			inv:add_item("main", "default:sword_wood 1")
		end
	else
		player:respawn() -- respawn the player
		player:set_hp(16, "respawn")
		teams.add_teleport_particlespawner(player:get_pos())
		player:set_pos(teams.lobby.current.spawn)
	end
end

minetest.hud_replace_builtin("health", {
	type = "statbar",
	position = {x = 0.5, y = 1},
	text = "heart.png",
	text2 = "heart_gone.png",
	number = core.PLAYER_MAX_HP_DEFAULT + 4,
	item = core.PLAYER_MAX_HP_DEFAULT + 4,
	direction = 0,
	size = {x = 24, y = 24},
	offset = {x = (-10 * 24) - 25, y = -(48 + 24 + 16)},
})

local countdown

local countdown = function(len, func, player, hud)
	player:hud_change(hud, "text", "Respawning in " .. len .. " seconds")
	minetest.after(1, countdown, len - 1, func, player, hud)
	--countdown(len -1, func, player, hud)
end

local countdown_HUD = function(player)
	local hud = player:hud_add({ -- chud, short for Countdown HUD
		hud_elem_type = "text",
		position      = {x = 0.5, y = 0.45}, -- pos normalized (-1 to 1)
		offset        = {x = 0,   y = 0}, -- ofset (px)
		text          = "Respawning in 5 seconds",
		alignment     = {x = 0, y = 0}, -- alignment normalized (-1 to 1)
		scale         = {x = 100, y = 100}, -- scale (px)
		number        = 0xFFFFFF, -- color (hex) using table to convert colortext to hex
	})
	return hud
end

teams.game_start = function()
	teams.init()
	teams.maps.current_map.init()
	for i, pn in ipairs(teams.players) do
		local pn = teams.players[pn].name
		teams.on_joinplayer(pn)
		teams.join_team(pn, teams.get_team(pn)) -- kinda redundant, but whatever
	end
	run_start_callbacks()
	minetest.chat_send_all("Game Started!")
end

teams.game_end = function(winning_team)
	minetest.after(5, teams.game_start)
	minetest.chat_send_all(winning_team .. " won")
	for pn in pairs(teams.teams[winning_team].players) do
		minetest.chat_send_player(pn, "Your Team Won!")
	end
	for pn in pairs(teams.players) do -- move everyone to the lobby
		minetest.get_player_by_name(pn):set_pos(teams.lobby.current.spawn)
	end
end

teams.setup_lobby = function()
	minetest.clear_objects({mode = "quick"})
	minetest.place_schematic({x=400, y=0, z=400}, modpath .. "/schematics/lobby.mts", nil, nil, true)
	minetest.place_schematic({x=0, y=500, z=0}, modpath .. teams.lobby.queuing_room.current.path, nil, nil, true)
	for pn in pairs(teams.players) do -- move everyone to the lobby
		minetest.get_player_by_name(pn):set_pos(teams.lobby.current.spawn)
	end
end

teams.respawn = function(player) -- custom respawn function
	if teams.players[player:get_player_name()].is_playing then
		player:get_inventory():set_list("main", {})
		if teams.teams[teams.get_team(player:get_player_name())].has_bed == true then -- bed hasn't been destroyed
			player:respawn() -- respawn the player
			player:set_hp(20)
			player:set_pos(teams.maps.current_map.start)
			--local chud = countdown_HUD(player)
			--countdown(5, teams.spawn, player, chud)
			minetest.after(5, teams.spawn, player)
		else
			if teams.players[player:get_player_name()] and teams.get_team(player:get_player_name()) then
				local players = teams.teams[teams.get_team(player:get_player_name())].players
				if teams.lent(players) < 1 then
					minetest.chat_send_all(minetest.colorize(teams.get_team(pn), "TEAM ELIMINATED"))
				end
				teams.on_leaveplayer(player:get_player_name())
				local teams_eliminated = 0
				local winning_team = ""
				for i, team in ipairs(teams.maps.current_map.teams) do
					if teams.teams[team].has_bed ~= true then
						teams_eliminated = teams_eliminated + 1
					else
						winning_team = team
					end
				end
				if teams_eliminated >= teams.lent(teams.maps.current_map.teams) then
					teams.game_end(winning_team)
				end
			end
			player:respawn() -- respawn the player
			player:set_hp(16)
			player:set_pos(teams.lobby.current.spawn)
			if teams.teams[teams.get_team(player:get_player_name())] then
				teams.teams[teams.get_team(player:get_player_name())].players[player:get_player_name()] = nil -- remove player from team
			end
		end
	else
		player:respawn() -- respawn the player
		player:set_hp(20)
		player:set_pos(teams.lobby.current.spawn)
	end
end

teams.on_dieplayer = function(pn, reason) -- a player died, update score and respawn
	local deathinfo = "died"
	if reason and reason.type == "punch" and reason.object and reason.object:is_player() and teams.players[pn].is_playing then
		deathinfo = "was killed by " .. minetest.colorize(teams.get_team(reason.object:get_player_name()), reason.object:get_player_name())
		teams.players[reason.object:get_player_name()].kills = teams.players[reason.object:get_player_name()].kills + 1
		teams.teams[teams.get_team(reason.object:get_player_name())].kills = teams.teams[teams.get_team(reason.object:get_player_name())].kills + 1
	end
	minetest.chat_send_all(minetest.colorize(teams.get_team(pn), pn .. " ") .. minetest.colorize("pink", " " .. deathinfo))
	if teams.players[pn] and teams.players[pn].is_playing then
		teams.players[pn].deaths = teams.players[pn].deaths + 1 -- increment player deaths
		teams.teams[teams.get_team(pn)].deaths = teams.teams[teams.get_team(pn)].deaths + 1 -- increment total team deaths
	end
	run_die_callbacks(minetest.get_player_by_name(pn), teams.get_team(pn), deathinfo)
	teams.respawn(minetest.get_player_by_name(pn))
end

teams.join_team = function(pn, team) -- use to make o player join a team
	minetest.get_player_by_name(pn):get_inventory():set_list("main", {})
	if teams.players[pn] and teams.get_team(pn) ~= "" and teams.get_team(pn) ~= nil then -- make sure we're not removing nonexistent player
		teams.teams[teams.get_team(pn)].players[pn] = nil -- remove player from old team
	end
	teams.teams[team].players[pn] = pn -- add player to new team
	teams.players[pn] = {team = team, name = pn, kills = 0, deaths = 0, beds = 0, is_playing = true, waiting = false}
	local player = minetest.get_player_by_name(pn)
	teams.add_teleport_particlespawner(player:get_pos())
	player:set_pos(teams.maps.current_map.teams[team].spawn)
	run_join_callbacks(player, team)
	local playercount = 0
	for tn in pairs(teams.teams) do
		for pn in pairs(teams.teams[tn].players) do
			playercount = playercount + 1
		end
	end
	if playercount >= teams.maps.current_map.max_players then
		minetest.chat_send_all("Starting Game in 5 seconds")
		minetest.after(5, teams.game_start)
	end
	minetest.chat_send_player(pn, "Joined team " .. minetest.colorize(teams.get_team(pn), teams.get_team(pn)))
end

teams.on_joinplayer = function(pn) -- when joining a match
	minetest.get_player_by_name(pn):get_inventory():set_list("main", {})
	minetest.get_player_by_name(pn):set_properties({nametag_color = {a=0, r=255, g=255, b=255}})
	minetest.get_player_by_name(pn):set_hp(16)
	--default.chest.enderchest.create_inventory(pn)
	local has_joined = false
	for tn, mapteam in pairs(teams.maps.current_map.teams) do 
		local pc = 0
		for pn, player in pairs(teams.teams[tn].players) do -- count how many players are in the team
			pc = pc + 1
		end
		if pc < 1 then -- if the team is not full
			teams.join_team(pn, tn) -- join the team
			has_joined = true
			break
		end
	end
	if has_joined == false then
		minetest.chat_send_player(pn, minetest.colorize("red", "No empty team found"))
		teams.on_leaveplayer(pn)
	end
end

teams.queueplayer = function(player)
	teams.game.waiting_players = teams.game.waiting_players + 1
	teams.add_teleport_particlespawner(player:get_pos())
	player:set_pos(teams.lobby.queuing_room.current.spawn)
	teams.players[player:get_player_name()].waiting = true
end

teams.unqueueplayer = function(player)
	teams.game.waiting_players = math.max(teams.game.waiting_players - 1, 0)
	teams.add_teleport_particlespawner(player:get_pos())
	player:set_pos(teams.lobby.current.spawn)
	teams.players[player:get_player_name()].waiting = false
end

teams.leave_team = function(pn) -- leave the team you are on
	if pn ~= nil then
		run_leave_callbacks(minetest.get_player_by_name(pn), teams.get_team(pn)) -- ran before player data is deleted
		if teams.teams[teams.get_team()] then teams.teams[teams.get_team(pn)].players[pn] = nil end -- remove player from team
		teams.players[pn] = {team = "", name = pn, kills = 0, deaths = 0, beds = 0, is_playing = false, waiting = false} -- reset player
	end
end

teams.on_leaveplayer = function(pn) -- when left a match
	teams.leave_team(pn)
end

teams.on_join_server = function(player, last_login)
	teams.add_teleport_particlespawner(player:get_pos())
	player:set_pos(teams.lobby.current.spawn)
	teams.players[player:get_player_name()] = {team = "", name = player:get_player_name(), kills = 0, deaths = 0, beds = 0, is_playing = false}
end

teams.on_leave_server = function(player, timed_out)
	teams.on_leaveplayer(player:get_player_name())
	teams.players[player:get_player_name()] = nil
end

teams.on_cheat = function(pn, cheat) -- someone triggered the minetest anticheat, kick them and warn the other players
	minetest.kick_player(pn, "you were caught cheating") -- cheat is a table, I don't want to deal with it so I just say 'you cheated' @1
	minetest.chat_send_all(minetest.colorize("red", "***" .. pn .. " was kicked because they " .. "cheated" .. "***")) -- see @1
end

teams.on_digbed = function(pn, team) -- someone broke a bed (already checked to make sure they're on a different team)
	if team ~= nil then
		teams.teams[team].has_bed = false -- this team no longer has their bed
		teams.players[pn].beds = teams.players[pn].beds + 1
		minetest.chat_send_all(minetest.colorize(teams.teams[team].name, team .. "'s") .. " bed was broken by " .. minetest.colorize(teams.players[pn].team, pn))
	else
		minetest.chat_send_all("What on earth, this bed has no team!?!")
	end
end

local knockback_ratings = {
	[1] = 4,
	[2] = 5,
	[3] = 6,
	[4] = 7,
	[5] = 8,
}

local calculate_knockback = minetest.calculate_knockback
function minetest.calculate_knockback(player, hitter, time_from_last_punch, tool_capabilities, dir, distance, damage)
	if damage == 0 or player:get_armor_groups().immortal then
		return 0.0
	end

	local m = 8
	-- solve m - m*e^(k*4) = 4 for k
	local k = -0.17328
	local res = m - m * math.exp(k)

	if distance < 3.0 then
		res = res * 1.01 -- more knockback when closer
	elseif distance > 4.0 then
		res = res * 0.99 -- less when far away
	end
	local knockback_group = tool_capabilities.damage_groups.knockback or 1
	--minetest.log("Knockback group: " .. knockback_group .. ", from group num: " .. tostring(tool_capabilities.damage_groups.knockback))
	player:add_velocity(vector.new(0, 5, 0)) -- to stop players from disabling knockback by crouching at the edge (trust me it's not smth you want)
	return res * knockback_ratings[tool_capabilities.damage_groups.knockback]
end

minetest.register_on_dieplayer(function(player, reason) -- trigger teams.on_dieplayer()
	teams.on_dieplayer(player:get_player_name(), reason)
end)

minetest.register_on_joinplayer(function(player, last_login) -- trigger teams.on_joinplayer()
	--teams.on_joinplayer(player:get_player_name())
	player:get_inventory():set_list("main", {})
	player:set_physics_override({
		sneak_glitch = true,
	})
	teams.on_join_server(player, last_login)
end)

minetest.register_on_leaveplayer(function(player, timed_out) -- trigger teams.on_leaveplayer()
	--teams.on_leaveplayer(player:get_player_name())
	teams.on_leave_server(player, timed_out)
end)

minetest.register_on_cheat(function(player, cheat) -- trigger teams.on_cheat()
	teams.on_cheat(player:get_player_name(), cheat)
end)

minetest.register_on_chat_message(function(name, message)
	local color = teams.get_team(name) or "white"
    minetest.chat_send_all(minetest.colorize(color, "<" .. name .. "> ") .. message)
    return true
end)

local list = function(name)
	local tc = 0 -- team count
	local hasbed = { -- table to convert from boolean to understandable and grammarly correct text
		[true] = "with a bed",
		[false] = "without bed",
	}
	for tn, team in pairs(teams.teams) do -- for each team show team name and team stats
		
		minetest.chat_send_player(name, minetest.colorize(teams.teams[tn].name, teams.teams[tn].name .. " team: ") .. hasbed[teams.teams[tn].has_bed] .. ", and " .. teams.teams[tn].deaths .. " deaths, " .. teams.teams[tn].kills .. " kills.")
		tc = tc + 1 -- add to team count (#teams.teams doesn't work)
	end
	return true, "Showing a total of " .. tc .. " teams, and " .. 0 .. " hidden."
end

local dumplist = function(name)
	minetest.chat_send_player(name, minetest.colorize(teams.teams[teams.get_team(name)].name, teams.teams[teams.get_team(name)].name) .. teams.teams[teams.get_team(name)].kills .. teams.teams[teams.get_team(name)].deaths)
	return true, "Dumped all team data of player '" .. name .. "'"
end

local listp = function(name)
	local pc = 0 -- player count
	for pn, player in pairs(teams.teams[teams.get_team(name)].players) do -- for each player in teams.teams[team].players show player name and player stats
		minetest.chat_send_player(name, minetest.colorize(teams.teams[teams.get_team(name)].name, name .. ": ") .. teams.players[pn].deaths .. " deaths, " .. teams.players[pn].kills .. " kills.")
		pc = pc + 1 -- add to player count
	end
	return true, "Showing a total of " .. pc .. " players, and " .. 0 .. " hidden."
end

minetest.register_chatcommand("teams", { -- chatcommand to control teams (must be server priviliged for the actual manipulation of teams)
    privs = {
        interact = true,
    },
	description = "Usage: teams <cmd> <param>\n" ..
				  "teams map place\n" ..
				  "teams join <team> (join a team)\n" ..
				  "teams list players (list players in your team)\n" ..
				  "teams list teams (list teams)\n" ..
				  "teams list dump (dump all team info)\n" ..
				  "teams reset all (reset all teams)\n" .. 
				  "teams reset team <team> (reset selected team)\n" .. 
				  "teams reset player <player> (reset player stats)\n",
    func = function(name, param)
		local parts = param:split(" ")
		local cmd = parts[1]
		local has, missing = minetest.check_player_privs(name,  {server = true})

		if cmd == "join" then
			if has then
				local tn = parts[2]
				if teams.teams[tn] ~= nil then
					teams.join_team(name, tn)
					return true, name .. " Joined team " .. tn
				else 
					return false, "Not a valid Team"
				end
			else
				return false, "Missing privilege: '" .. missing .. "'"
			end
		elseif cmd == "list" then
			local param1 = parts[2]
			if param1 == "players" then
				return listp(name)
			elseif param1 == "teams" then
				return list(name)
			elseif param1 == "dump" then
				return dumplist()
			else
				return false, "No command given"
			end
		elseif cmd == "reset" then
			if has then
				local cmd2 = parts[2]
				if cmd2 == "all" then
					teams.init()
					return true, "All teams were reset"
				elseif cmd2 == "team" then
					local tn = parts[3]
					if tn then
						teams.init_team(tn)
						return true, "Team " .. minetest.colorize(tn, tn) .. " was reset"
					else
						return false, ""
					end
				elseif cmd2 == "player" then
					local pn = parts[3]
					if pn then
						minetest.get_player_by_name(pn):get_inventory():set_list("main", {})
						teams.join_team(pn, teams.get_team(pn))
						return true, "Player" .. minetest.colorize(teams.get_team(pn), pn) .. " was reset"
					else
						return false, "Player not found: " .. tostring(pn)
					end
				else
					return false, "Usage: teams reset <cmd> <param>"
				end
			end
		elseif cmd == "map" then
			local cmd2 = parts[2]
			if cmd2 == "place" then
				teams.maps.current_map.init()
			end
		else
			return true, "Usage: teams <cmd> <param>"
		end
	end,
})

minetest.register_chatcommand("t", { -- chatcommand for team chat
    privs = {
		shout = true,
    },
	description = "Chat to team only.\nUsage: /t <message>",
    func = function(name, param)
		local parts = param:split(" ")
		local msg = parts[1]
		if teams.players[name].is_playing then
			for pn in pairs(teams.teams[teams.get_team(name)].players) do
				minetest.chat_send_player(pn, minetest.colorize(teams.get_team(pn), "*" .. pn  .. "* " .. msg))
			end
		else
			return false, "You may not chat to your team while dead or not playing."
		end
	end,
})

minetest.register_chatcommand("start", { -- chatcommand for starting/restarting the game
    privs = {
		server = true,
    },
	description = "Start game.\nUsage: /start",
    func = function(name, param)
		teams.game_start()
	end,
})

minetest.register_chatcommand("setup", { -- chatcommand for setting up a new world
    privs = {
		server = true,
    },
	description = "Setup the lobby in the world.\nUsage: /setup",
    func = function(name, param)
		teams.setup_lobby()
	end,
})

minetest.register_chatcommand("lobby", { -- chatcommand for going back to the lobby
    privs = {
		interact = true,
    },
	description = "Start game.\nUsage: /lobby",
    func = function(name, param)
		minetest.get_player_by_name(name):get_inventory():set_list("main", {})
		if teams.players[name].waiting == true then teams.unqueueplayer(minetest.get_player_by_name(name)) end
		teams.on_leaveplayer(name)
		teams.on_join_server(minetest.get_player_by_name(name))
	end,
})

teams.rules = "1: No unhelpful or offensive names or messages.\n2: No cheating in Public games, if you want to test something get into a Private game with a friend.\n3: Explore, Don't destroy.\n4: No stalking, bullying, or harrasment.\n5: Don't beg for roles, privs, or items.\n6: Keep your personal information safe.\n7: If you see anyone breaking these rules report them.\n8: If you don't understand or agree to these rules contact and Admin or Moderator.\n9: No Cross-Teaming or Stream-Sniping.\n10: Admins and Moderators have the ability to punish people who break these rules at any time and anywhere, this includes PermaBanning."

minetest.register_chatcommand("rules", {
    privs = {},
	description = "View the server rules.\nUsage: /rules",
    func = function(name, param)
		minetest.chat_send_player(name, minetest.colorize("lightgreen", "Rules:\n" .. teams.rules))
	end,
})

minetest.register_chatcommand("agree", { -- agree to the rules
    privs = {},
	description = "Usage: /agree",
    func = function(name, param)
		minetest.chat_send_player(name, minetest.colorize("green", "Rules:\n" .. teams.rules))
		minetest.change_player_privs(name, {interact = true, shout = true})
	end,
})

minetest.register_node("teams:join_game", {
	description = "Join Game",
	paramtype = "light",
	paramtype2 = "4dir",
	tiles = {
		"teams_join_game.png"
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed    = {-0.375, -0.5, -0.375, 0.375, 0.375, 0.375},
	},
	groups = {map_node=1, join_node=1},
	on_punch = function(pos, node, puncher, pointed_thing)
		puncher:get_inventory():set_list("main", {})
		teams.on_joinplayer(puncher:get_player_name())
	end,
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

minetest.register_node("teams:queue", {
	description = "Queue",
	paramtype = "light",
	paramtype2 = "4dir",
	tiles = {
		"teams_queue.png"
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed    = {-0.375, -0.5, -0.375, 0.375, 0.375, 0.375},
	},
	groups = {map_node=1, join_node=1},
	on_punch = function(pos, node, puncher, pointed_thing)
		puncher:get_inventory():set_list("main", {})
		teams.queueplayer(puncher)
	end,
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

local select_map_formspec_start = "size[8,9]" .. "list[current_player;main;0,5;8,4;]"
local select_map_formspec_end = "label[4,0;Select Map]" ..
								"button[0,1;4,1;galactium;Galactium (2p)]" .. -- unfortunately this has to be hardcoded :/
								"button[4,1;4,1;asterisk2p;Asterisk (2p)]" ..
								"button[0,2;4,1;cloverleaf2p;Clover Leaf (2p)]"
local select_map_formspec = select_map_formspec_start .. select_map_formspec_end

minetest.register_node("teams:select_map", {
	description = "Select Map",
	paramtype = "light",
	paramtype2 = "4dir",
	tiles = {
		"teams_select_map.png"
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed    = {-0.375, -0.5, -0.375, 0.375, 0.375, 0.375},
	},
	groups = {map_node=1, join_node=1},
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		minetest.show_formspec(clicker:get_player_name(), "teams:select_map", select_map_formspec)
	end,
	on_punch = function(pos, node, puncher, pointed_thing)
		minetest.show_formspec(puncher:get_player_name(), "teams:select_map", select_map_formspec)
	end,
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "teams:select_map" then
		return
	end
	
	if fields.galactium then
		teams.select_map("Galactium")
	elseif fields.asterisk2p then
		teams.select_map("Asterisk2p")
	elseif fields.cloverleaf2p then
		teams.select_map("CloverLeaf2p")
	end
end)

--[[
minetest.register_chatcommand("tstat", { -- show stats for your team
    description = "Show your team's stats",
    func = function(pn)
    	return true, minetest.colorize(teams.teams[teams.get_team(pn)].name, "Team " .. teams.teams[teams.get_team(pn)].name) .. ", has " .. teams.teams[teams.get_team(pn)].kills .. " kills, and " teams.teams[teams.get_team(pn)].deaths .. " deaths."
    end,
})

minetest.register_chatcommand("tstatp", { -- show your stats
    description = "Show your personal stats",
    func = function(pn)
    	return true, "Player " .. teams.players[pn].name .. ", has " .. teams.players[pn].kills .. " kills, and " teams.players[pn].deaths .. " deaths."
    end,
})
]]

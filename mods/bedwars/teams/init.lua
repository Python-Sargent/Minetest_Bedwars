teams = {}

teams.teams = {}

teams.maps = {}

teams.maps.current_map = {
	name = "Galactuim",
	teams = {
		["red"] = {name = "red", spawn = {x=0, y=0.5, z=0}},
		["blue"] = {name = "blue", spawn = {x=0, y=0.5, z=62}},
	},
	path = "",
}

teams.maps.maplist = {}

teams.register_map = function(name, teams)
	teams.maps.maplist[name] = {
		name = name,
		teams = teams,
	}
end

teams.unregister_map = function(name)
	teams.maps.maplist[name] = nil
end

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

teams.init()

teams.get_team = function(pn) -- get the team name of the player using player name
	return teams.players[pn].team
end

local leave_callbacks = {}

teams.register_leave_callback = function(name, callback)
	leave_callbacks[name] = callback
end

local run_leave_callbacks = function(player, team)
	for i, callback in ipairs(leave_callbacks) do
		callback(player, team)
	end
end

local join_callbacks = {}

teams.register_join_callback = function(name, callback)
	join_callbacks[name] = callback
end

local run_join_callbacks = function(player, team)
	for i, callback in ipairs(join_callbacks) do
		callback(player, team)
	end
end

local die_callbacks = {}

teams.register_die_callback = function(name, callback)
	die_callbacks[name] = {name = name, func = callback}
end

local run_die_callbacks = function(player, team)
	for i, callback in ipairs(die_callbacks) do
		die_callbacks[callback].func(player, team)
	end
end

teams.on_dieplayer = function(pn, reason) -- a player died, update score and respawn
	reason = reason or "died"
	minetest.chat_send_all(minetest.colorize(teams.get_team(pn), pn .. " ") .. minetest.colorize("pink", " " .. reason))
	teams.players[pn].deaths = teams.players[pn].deaths + 1 -- increment player deaths
	teams.teams[teams.get_team(pn)].deaths = teams.teams[teams.get_team(pn)].deaths + 1 -- increment total team deaths
end

teams.join_team = function(pn, team) -- use to make o player join a team
	teams.teams[team].players[pn] = pn
	teams.players[pn] = {team = team, name = pn, kills = 0, deaths = 0, beds = 0}
	local player = minetest.get_player_by_name(pn)
	run_join_callbacks(player, team)
	player:set_pos(teams.maps.current_map.teams[team].spawn)
	minetest.chat_send_player(pn, "Joined team " .. minetest.colorize(teams.get_team(pn), teams.get_team(pn)))
end

teams.on_joinplayer = function(pn) -- when joining a match
	minetest.get_player_by_name(pn):set_properties({nametag = ""})
	--default.chest.enderchest.create_inventory(pn)
	local has_joined = false
	for tn, mapteam in pairs(teams.maps.current_map.teams) do -- for each team show team name and team stats
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
		teams.join_team(pn, "red") -- make it so you're in a team
	end
end

teams.leave_team = function(pn) -- leave the team you are on
	teams.teams[teams.get_team(pn)].players[pn] = nil
	run_leave_callbacks(minetest.get_player_by_name(pn), teams.get_team(pn))
	teams.players[pn] = nil
end

teams.on_leaveplayer = function(pn) -- when left a match
	teams.leave_team(pn)
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

teams.respawn = function(player) -- custom respawn function
	run_die_callbacks(player, teams.get_team(player:get_player_name()))
	player:get_inventory():set_list("main", {})
	if teams.teams[teams.get_team(player:get_player_name())].has_bed == true then -- bed hasn't been destroyed
		player:respawn() -- respawn the player
		player:set_pos(teams.maps.current_map.teams[teams.get_team(player:get_player_name())].spawn)
		player:get_inventory():add_item("main", "default:sword_wood 1")
	end
end

minetest.register_on_dieplayer(function(player, reason) -- trigger teams.on_dieplayer()
	teams.on_dieplayer(player:get_player_name())
end)

minetest.register_on_joinplayer(function(player, last_login) -- trigger teams.on_joinplayer()
	teams.on_joinplayer(player:get_player_name())
end)

minetest.register_on_leaveplayer(function(player, timed_out) -- trigger teams.on_leaveplayer()
	teams.on_leaveplayer(player:get_player_name())
end)

minetest.register_on_cheat(function(player, cheat) -- trigger teams.on_cheat()
	teams.on_cheat(player:get_player_name(), cheat)
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
						teams.join_team(pn, teams.get_team(pn))
						return true, "Player" .. minetest.colorize(teams.get_team(pn), pn) .. " was reset"
					else
						return false, "Player not found: " .. tostring(pn)
					end
				else
					return false, "Usage: teams reset <cmd> <param>"
				end
			end
		else
			return true, "Usage: teams <cmd> <param>"
		end
	end,
})

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

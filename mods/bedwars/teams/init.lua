teams = {}

teams.teams = {}

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

teams.get_team = function(pn) -- get the team name of the player using player name
	return teams.players[pn].team
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
	minetest.chat_send_player(pn, "Joined team " .. minetest.colorize(teams.get_team(pn), teams.get_team(pn)))
end

teams.on_joinplayer = function(pn) -- when joining a match
	local has_joined = false
	for tn, team in pairs(teams.teams) do -- for each team show team name and team stats
		local pc = 0
		for pn, player in pairs(teams.teams[tn].players) do -- count how many players are in the team
			pc = pc + 1
		end
		if pc < 1 then -- if the team is not full
			teams.join_team(pn, team.name) -- join the team
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
	player:get_inventory():set_list("main", {})
	if teams.teams[teams.get_team(player:get_player_name())].has_bed == true then -- bed hasn't been destroyed
		player:respawn() -- respawn the player
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

minetest.register_on_cheat(function(player, cheat) -- trigger teams.cheat()
	teams.on_cheat(player:get_player_name(), cheat)
end)

minetest.register_chatcommand("tlist", { -- list all teams and team stats
    description = "Show current teams",
    func = function(name)
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
    end,
})

minetest.register_chatcommand("tdump", { -- dump team and team stats into string (sent to player)
	description = "",
	func = function(name)
		minetest.chat_send_player(name, minetest.colorize(teams.teams[teams.get_team(name)].name, teams.teams[teams.get_team(name)].name) .. teams.teams[teams.get_team(name)].kills .. teams.teams[teams.get_team(name)].deaths)
	end,
})

minetest.register_chatcommand("tlistp", { -- list players on team
    description = "Show current players on your team",
    func = function(name)
    	local pc = 0 -- player count
		for pn, player in pairs(teams.teams[teams.get_team(name)].players) do -- for each player in teams.teams[team].players show player name and player stats
    		minetest.chat_send_player(name, minetest.colorize(teams.teams[teams.get_team(name)].name, name .. ": ") .. teams.players[pn].deaths .. " deaths, " .. teams.players[pn].kills .. " kills.")
    		pc = pc + 1 -- add to player count
    	end
    	return true, "Showing a total of " .. pc .. " players, and " .. 0 .. " hidden."
    end,
})

minetest.register_chatcommand("tshow", { -- send team name to player invoking command
    description = "Show what team you are on",
    func = function(pn)
    	return true, "You are on team " .. minetest.colorize(teams.teams[teams.get_team(pn)].name, teams.teams[teams.get_team(pn)].name)
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


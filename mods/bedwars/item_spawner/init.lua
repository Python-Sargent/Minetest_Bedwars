item_spawner = {}

item_spawner.times = {
	forge = {
		lvl1 = {steel = 2, gold = 3.5, cost = 0}, -- steel (time), gold (steel times N)
		lvl2 = {steel = 1.75, gold = 3.5, cost = 4},
		lvl3 = {steel = 1.5, gold = 3.5, cost = 8},
		lvl4 = {steel = 1.25, gold = 3.5, cost = 16}
	},
	diamond = {
		lvl1 = {delay = 45, time = 60*1},
		lvl2 = {delay = 35, time = 60*2},
		lvl3 = {delay = 30, time = 60*3},
		lvl4 = {delay = 25, time = 60*4}
	},
	mese = {
		lvl1 = {delay = 75, time = 60*2},
		lvl2 = {delay = 60, time = 60*4},
		lvl3 = {delay = 55, time = 60*6},
		lvl4 = {delay = 50, time = 60*8}
	},
}

item_spawner.levels = {
	forge = item_spawner.times.forge.lvl1,
	diamond = item_spawner.times.diamond.lvl1,
	mese = item_spawner.times.mese.lvl1
}

item_spawner.forges = {}

minetest.register_node("item_spawners:mese_spawner", {
	description = "Mese Spawner",
	tiles = {"default_mese_block.png"},
	paramtype = "light",
	groups = {map_node = 1, level = 2},
	sounds = default.node_sound_stone_defaults(),
	light_source = 3,
	on_blast = function() end,
	can_dig = can_dig_map,
})

minetest.register_node("item_spawners:diamond_spawner", {
	description = "Diamond Spawner",
	tiles = {"default_diamond_block.png"},
	is_ground_content = false,
	groups = {map_node = 1, level = 3},
	sounds = default.node_sound_stone_defaults(),
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

minetest.register_abm({
	catch_up = false,
	nodenames = {"item_spawners:diamond_spawner"},
	interval = item_spawner.levels.diamond.delay,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.add_item({x = pos.x, y = pos.y + 1, z = pos.z}, "default:diamond")
	end
})

minetest.register_abm({
	catch_up = false,
	nodenames = {"item_spawners:mese_spawner"},
	interval = item_spawner.levels.mese.delay,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.add_item({x = pos.x, y = pos.y + 1, z = pos.z}, "default:mese_crystal")
	end
})

--[[minetest.register_abm({
	catch_up = false,
	nodenames = {"default:steelblock"},
	interval = item_spawner.levels.forge.steel,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.add_item({x = pos.x, y = pos.y + 1, z = pos.z}, "default:steel_ingot")
	end
})

minetest.register_abm({
	catch_up = false,
	nodenames = {"default:steelblock"},
	interval = item_spawner.levels.forge.gold,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.add_item({x = pos.x, y = pos.y + 1, z = pos.z}, "default:gold_ingot")
	end
})]]

--55 35 137

item_spawner.register_forge = function(team)
	minetest.register_node("item_spawners:forge_"..team, {
		description = "Forge (" .. team .. " Team)",
		tiles = {"default_steel_block.png"},
		is_ground_content = false,
		groups = {map_node = 1, forge = 1},
		sounds = default.node_sound_metal_defaults(),
		on_blast = function() end,
		can_dig = default.can_dig_map,
		on_construct = function(pos, node)
			local meta = minetest.get_meta(pos)
			meta:set_int("ticks", 0)
			meta:set_string("team", team)
			local timer = minetest.get_node_timer(pos)
			timer:start(item_spawner.forges[team].steel)
		end,
		on_timer = function(pos, elapsed)
			local meta = minetest.get_meta(pos)
			meta:set_int("ticks", meta:get_int("ticks") + 1)
			if meta:get_int("ticks") >= item_spawner.forges[team].gold then
				minetest.add_item({x = pos.x, y = pos.y + 1, z = pos.z}, "default:gold_ingot")
				meta:set_int("ticks", 0)
			end
			minetest.add_item({x = pos.x, y = pos.y + 1, z = pos.z}, "default:steel_ingot")
			local timer = minetest.get_node_timer(pos)
			timer:start(item_spawner.forges[team].steel)
			return false
		end,
	})
end

local dyes = dye.dyes -- obtain list of dyes from the dyes mod

for i = 1, #dyes do -- create team for each dye color
	local name, desc = unpack(dyes[i]) -- unpack dye into name and desc vars

	item_spawner.forges[name] = item_spawner.times.forge.lvl1
	item_spawner.register_forge(name)
end
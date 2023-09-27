--
-- Sounds
--

function default.node_sound_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "", gain = 1.0}
	table.dug = table.dug or
			{name = "default_dug_node", gain = 0.25}
	table.place = table.place or
			{name = "default_place_node_hard", gain = 1.0}
	return table
end

function default.node_sound_stone_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_hard_footstep", gain = 0.2}
	table.dug = table.dug or
			{name = "default_hard_footstep", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_dirt_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_dirt_footstep", gain = 0.25}
	table.dig = table.dig or
			{name = "default_dig_crumbly", gain = 0.4}
	table.dug = table.dug or
			{name = "default_dirt_footstep", gain = 1.0}
	table.place = table.place or
			{name = "default_place_node", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_sand_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_sand_footstep", gain = 0.05}
	table.dug = table.dug or
			{name = "default_sand_footstep", gain = 0.15}
	table.place = table.place or
			{name = "default_place_node", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_gravel_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_gravel_footstep", gain = 0.25}
	table.dig = table.dig or
			{name = "default_gravel_dig", gain = 0.35}
	table.dug = table.dug or
			{name = "default_gravel_dug", gain = 1.0}
	table.place = table.place or
			{name = "default_place_node", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_wood_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_wood_footstep", gain = 0.15}
	table.dig = table.dig or
			{name = "default_dig_choppy", gain = 0.4}
	table.dug = table.dug or
			{name = "default_wood_footstep", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_leaves_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_grass_footstep", gain = 0.45}
	table.dug = table.dug or
			{name = "default_grass_footstep", gain = 0.7}
	table.place = table.place or
			{name = "default_place_node", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_glass_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_glass_footstep", gain = 0.3}
	table.dig = table.dig or
			{name = "default_glass_footstep", gain = 0.5}
	table.dug = table.dug or
			{name = "default_break_glass", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_ice_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_ice_footstep", gain = 0.15}
	table.dig = table.dig or
			{name = "default_ice_dig", gain = 0.5}
	table.dug = table.dug or
			{name = "default_ice_dug", gain = 0.5}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_metal_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_metal_footstep", gain = 0.2}
	table.dig = table.dig or
			{name = "default_dig_metal", gain = 0.5}
	table.dug = table.dug or
			{name = "default_dug_metal", gain = 0.5}
	table.place = table.place or
			{name = "default_place_node_metal", gain = 0.5}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_water_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_water_footstep", gain = 0.2}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_snow_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_snow_footstep", gain = 0.2}
	table.dig = table.dig or
			{name = "default_snow_footstep", gain = 0.3}
	table.dug = table.dug or
			{name = "default_snow_footstep", gain = 0.3}
	table.place = table.place or
			{name = "default_place_node", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end


--
-- Lavacooling
--

default.cool_lava = function(pos, node)
	if node.name == "default:lava_source" then
		minetest.set_node(pos, {name = "default:obsidian"})
	else -- Lava flowing
		minetest.set_node(pos, {name = "default:stone"})
	end
	minetest.sound_play("default_cool_lava",
		{pos = pos, max_hear_distance = 16, gain = 0.2}, true)
end

if minetest.settings:get_bool("enable_lavacooling") ~= false then
	minetest.register_abm({
		label = "Lava cooling",
		nodenames = {"default:lava_source", "default:lava_flowing"},
		neighbors = {"group:cools_lava", "group:water"},
		interval = 2,
		chance = 2,
		catch_up = false,
		action = function(...)
			default.cool_lava(...)
		end,
	})
end


--
-- Optimized helper to put all items in an inventory into a drops list
--

function default.get_inventory_drops(pos, inventory, drops)
	local inv = minetest.get_meta(pos):get_inventory()
	local n = #drops
	for i = 1, inv:get_size(inventory) do
		local stack = inv:get_stack(inventory, i)
		if stack:get_count() > 0 then
			drops[n+1] = stack:to_table()
			n = n + 1
		end
	end
end

--
-- Dig upwards
--

function default.dig_up(pos, node, digger)
	if digger == nil then return end
	local np = {x = pos.x, y = pos.y + 1, z = pos.z}
	local nn = minetest.get_node(np)
	if nn.name == node.name then
		minetest.node_dig(np, nn, digger)
	end
end

--
-- Mese post registration helper
--

function default.register_mesepost(name, def)
	minetest.register_craft({
		output = name .. " 4",
		recipe = {
			{'', 'default:glass', ''},
			{'default:mese_crystal', 'default:mese_crystal', 'default:mese_crystal'},
			{'', def.material, ''},
		}
	})

	local post_texture = def.texture .. "^default_mese_post_light_side.png^[makealpha:0,0,0"
	local post_texture_dark = def.texture .. "^default_mese_post_light_side_dark.png^[makealpha:0,0,0"
	-- Allow almost everything to be overridden
	local default_fields = {
		wield_image = post_texture,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-2 / 16, -8 / 16, -2 / 16, 2 / 16, 8 / 16, 2 / 16},
			},
		},
		paramtype = "light",
		tiles = {def.texture, def.texture, post_texture_dark, post_texture_dark, post_texture, post_texture},
		use_texture_alpha = "opaque",
		light_source = default.LIGHT_MAX,
		sunlight_propagates = true,
		is_ground_content = false,
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		sounds = default.node_sound_wood_defaults(),
	}
	for k, v in pairs(default_fields) do
		if def[k] == nil then
			def[k] = v
		end
	end

	def.texture = nil
	def.material = nil

	minetest.register_node(name, def)
end

--
-- Register a craft to copy the metadata of items
--

function default.register_craft_metadata_copy(ingredient, result)
	minetest.register_craft({
		type = "shapeless",
		output = result,
		recipe = {ingredient, result}
	})

	minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
		if itemstack:get_name() ~= result then
			return
		end

		local original
		local index
		for i = 1, #old_craft_grid do
			if old_craft_grid[i]:get_name() == result then
				original = old_craft_grid[i]
				index = i
			end
		end
		if not original then
			return
		end
		local copymeta = original:get_meta():to_table()
		itemstack:get_meta():from_table(copymeta)
		-- put the book with metadata back in the craft grid
		craft_inv:set_stack("craft", index, original)
	end)
end

--
-- Log API / helpers
--

local log_non_player_actions = minetest.settings:get_bool("log_non_player_actions", false)

local is_pos = function(v)
	return type(v) == "table" and
		type(v.x) == "number" and type(v.y) == "number" and type(v.z) == "number"
end

function default.log_player_action(player, ...)
	local msg = player:get_player_name()
	if player.is_fake_player or not player:is_player() then
		if not log_non_player_actions then
			return
		end
		msg = msg .. "(" .. (type(player.is_fake_player) == "string"
			and player.is_fake_player or "*") .. ")"
	end
	for _, v in ipairs({...}) do
		-- translate pos
		local part = is_pos(v) and minetest.pos_to_string(v) or v
		-- no leading spaces before punctuation marks
		msg = msg .. (string.match(part, "^[;,.]") and "" or " ") .. part
	end
	minetest.log("action",  msg)
end

function default.set_inventory_action_loggers(def, name)
	def.on_metadata_inventory_move = function(pos, from_list, from_index,
			to_list, to_index, count, player)
		default.log_player_action(player, "moves stuff in", name, "at", pos)
	end
	def.on_metadata_inventory_put = function(pos, listname, index, stack, player)
		default.log_player_action(player, "moves", stack:get_name(), "to", name, "at", pos)
	end
	def.on_metadata_inventory_take = function(pos, listname, index, stack, player)
		default.log_player_action(player, "takes", stack:get_name(), "from", name, "at", pos)
	end
end

--
-- NOTICE: This method is not an official part of the API yet.
-- This method may change in future.
--

function default.can_interact_with_node(player, pos)
	if player and player:is_player() then
		if minetest.check_player_privs(player, "protection_bypass") then
			return true
		end
	else
		return false
	end

	local meta = minetest.get_meta(pos)
	local owner = meta:get_string("owner")

	if not owner or owner == "" or owner == player:get_player_name() then
		return true
	end

	-- Is player wielding the right key?
	local item = player:get_wielded_item()
	if minetest.get_item_group(item:get_name(), "key") == 1 then
		local key_meta = item:get_meta()

		if key_meta:get_string("secret") == "" then
			local key_oldmeta = item:get_metadata()
			if key_oldmeta == "" or not minetest.parse_json(key_oldmeta) then
				return false
			end

			key_meta:set_string("secret", minetest.parse_json(key_oldmeta).secret)
			item:set_metadata("")
		end

		return meta:get_string("key_lock_secret") == key_meta:get_string("secret")
	end

	return false
end

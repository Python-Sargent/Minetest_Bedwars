-- mods/default/nodes.lua

-- support for MT game translation.
local S = default.get_translator

--[[ Node name convention:

Although many node names are in combined-word form, the required form for new
node names is words separated by underscores. If both forms are used in written
language (for example pinewood and pine wood) the underscore form should be used.

--]]


--[[ Index:

Stone
-----
(1. Material 2. Cobble variant 3. Brick variant 4. Modified forms)

default:stone
default:cobble
default:stonebrick

default:sandstone
default:sandstonebrick

default:obsidian

Soft / Non-Stone
----------------
(1. Material 2. Modified forms)

default:dirt
default:dirt_with_grass

default:sand

default:ice

Mineral Blocks
--------------
default:steelblock
default:mese
default:diamondblock

Trees
-----
(1. Trunk 2. Fabricated trunk 3. Leaves 4. Sapling 5. Fruits)

default:tree
default:wood

Liquids
-------
(1. Source 2. Flowing)

default:water_source
default:water_flowing

default:lava_source
default:lava_flowing

Tools / "Advanced" crafting / Non-"natural"
-------------------------------------------

default:ladder_wood

default:glass

default:brick

default:meselamp
default:mese_post_light

Misc
----

default:cloud

--]]

-- Required wrapper to allow customization of default.after_place_leaves
local function after_place_leaves(...)
	return default.after_place_leaves(...)
end

-- Required wrapper to allow customization of default.grow_sapling
local function grow_sapling(...)
	return default.grow_sapling(...)
end

default.can_dig_map = function(pos, player)
	if player and player:is_player() then
		local privs = minetest.get_player_privs(player:get_player_name())
		if privs.creative == true then
			return true
		end
	else
		return false
	end
end

--can_dig = function(pos, [player]),

--
-- Stone
--

minetest.register_node("default:stone", {
	description = S("Stone"),
	tiles = {"default_stone.png"},
	groups = {cracky = 3, stone = 1},
	drop = "default:cobble",
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:cobble", {
	description = S("Cobblestone"),
	tiles = {"default_cobble.png"},
	is_ground_content = false,
	groups = {map_node = 1, stone = 2},
	sounds = default.node_sound_stone_defaults(),
	on_blast = function() end,
	can_dig = can_dig_map,
})

minetest.register_node("default:stonebrick", {
	description = S("Stone Brick"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_stone_brick.png"},
	is_ground_content = false,
	groups = {map_node = 1, stone = 1},
	sounds = default.node_sound_stone_defaults(),
	on_blast = function() end,
	can_dig = can_dig_map,
})

minetest.register_node("default:sandstone", {
	description = S("Sandstone"),
	tiles = {"default_sandstone.png"},
	groups = {crumbly = 1, cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:sandstonebrick", {
	description = S("Sandstone Brick"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_sandstone_brick.png"},
	is_ground_content = false,
	groups = {map_node = 1},
	sounds = default.node_sound_stone_defaults(),
	on_blast = function() end,
	can_dig = can_dig_map,
})

minetest.register_node("default:obsidian", {
	description = S("Obsidian"),
	tiles = {"default_obsidian.png"},
	sounds = default.node_sound_stone_defaults(),
	groups = {cracky = 1, level = 2},
})

--
-- Soft / Non-Stone
--

minetest.register_node("default:dirt", {
	description = S("Dirt"),
	tiles = {"default_dirt.png"},
	groups = {map_node = 1, soil = 1},
	sounds = default.node_sound_dirt_defaults(),
	on_blast = function() end,
	can_dig = can_dig_map,
})

minetest.register_node("default:dirt_with_grass", {
	description = S("Dirt with Grass"),
	tiles = {"default_grass.png", "default_dirt.png",
		{name = "default_dirt.png^default_grass_side.png",
			tileable_vertical = false}},
	groups = {map_node = 1, soil = 1, spreading_dirt_type = 1},
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	}),
	on_blast = function() end,
	can_dig = can_dig_map,
})

minetest.register_node("default:ice", {
	description = S("Ice"),
	tiles = {"default_ice.png"},
	is_ground_content = false,
	paramtype = "light",
	groups = {map_node = 1, cools_lava = 1, slippery = 3},
	sounds = default.node_sound_ice_defaults(),
	on_blast = function() end,
	can_dig = can_dig_map,
})

--
-- Mineral Blocks
--

minetest.register_node("default:steelblock", {
	description = S("Steel Block"),
	tiles = {"default_steel_block.png"},
	is_ground_content = false,
	groups = {map_node = 1, level = 2},
	sounds = default.node_sound_metal_defaults(),
	on_blast = function() end,
	can_dig = can_dig_map,
})

minetest.register_node("default:mese", {
	description = S("Mese Block"),
	tiles = {"default_mese_block.png"},
	paramtype = "light",
	groups = {map_node = 1, level = 2},
	sounds = default.node_sound_stone_defaults(),
	light_source = 3,
	on_blast = function() end,
	can_dig = can_dig_map,
})

minetest.register_node("default:diamondblock", {
	description = S("Diamond Block"),
	tiles = {"default_diamond_block.png"},
	is_ground_content = false,
	groups = {map_node = 1, level = 3},
	sounds = default.node_sound_stone_defaults(),
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

--
-- Trees
--

minetest.register_node("default:tree", {
	description = S("Apple Tree"),
	tiles = {"default_tree_top.png", "default_tree_top.png", "default_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, map_node = 1},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node,
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

minetest.register_node("default:wood", {
	description = S("Apple Wood Planks"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

--
-- Liquids
--

minetest.register_node("default:water_source", {
	description = S("Water Source"),
	drawtype = "liquid",
	waving = 3,
	tiles = {
		{
			name = "default_water_source_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
		{
			name = "default_water_source_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
	use_texture_alpha = "blend",
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "default:water_flowing",
	liquid_alternative_source = "default:water_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
	groups = {water = 3, liquid = 3, cools_lava = 1},
	sounds = default.node_sound_water_defaults(),
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

minetest.register_node("default:water_flowing", {
	description = S("Flowing Water"),
	drawtype = "flowingliquid",
	waving = 3,
	tiles = {"default_water.png"},
	special_tiles = {
		{
			name = "default_water_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.5,
			},
		},
		{
			name = "default_water_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.5,
			},
		},
	},
	use_texture_alpha = "blend",
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "default:water_flowing",
	liquid_alternative_source = "default:water_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
	groups = {water = 3, liquid = 3, not_in_creative_inventory = 1,
		cools_lava = 1},
	sounds = default.node_sound_water_defaults(),
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

minetest.register_node("default:lava_source", {
	description = S("Lava Source"),
	drawtype = "liquid",
	tiles = {
		{
			name = "default_lava_source_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
		},
		{
			name = "default_lava_source_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
		},
	},
	paramtype = "light",
	light_source = default.LIGHT_MAX - 1,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "default:lava_flowing",
	liquid_alternative_source = "default:lava_source",
	liquid_viscosity = 7,
	liquid_renewable = false,
	damage_per_second = 4 * 2,
	post_effect_color = {a = 191, r = 255, g = 64, b = 0},
	groups = {lava = 3, liquid = 2, igniter = 1},
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

minetest.register_node("default:lava_flowing", {
	description = S("Flowing Lava"),
	drawtype = "flowingliquid",
	tiles = {"default_lava.png"},
	special_tiles = {
		{
			name = "default_lava_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.3,
			},
		},
		{
			name = "default_lava_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.3,
			},
		},
	},
	paramtype = "light",
	paramtype2 = "flowingliquid",
	light_source = default.LIGHT_MAX - 1,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "default:lava_flowing",
	liquid_alternative_source = "default:lava_source",
	liquid_viscosity = 7,
	liquid_renewable = false,
	damage_per_second = 4 * 2,
	post_effect_color = {a = 191, r = 255, g = 64, b = 0},
	groups = {lava = 3, liquid = 2, igniter = 1, not_in_creative_inventory = 1},
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

--
-- Tools / "Advanced" crafting / Non-"natural"
--

minetest.register_node("default:ladder_wood", {
	description = S("Wooden Ladder"),
	drawtype = "signlike",
	tiles = {"default_ladder_wood.png"},
	inventory_image = "default_ladder_wood.png",
	wield_image = "default_ladder_wood.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
	is_ground_content = false,
	selection_box = {
		type = "wallmounted",
		--wall_top = = <default>
		--wall_bottom = = <default>
		--wall_side = = <default>
	},
	groups = {choppy = 2, oddly_breakable_by_hand = 3, flammable = 2},
	legacy_wallmounted = true,
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:ladder_map", {
	description = S("Map Ladder"),
	drawtype = "signlike",
	tiles = {"default_ladder_wood.png"},
	inventory_image = "default_ladder_wood.png",
	wield_image = "default_ladder_wood.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
	is_ground_content = false,
	selection_box = {
		type = "wallmounted",
		--wall_top = = <default>
		--wall_bottom = = <default>
		--wall_side = = <default>
	},
	groups = {map_node = 1, flammable = 2},
	legacy_wallmounted = true,
	sounds = default.node_sound_wood_defaults(),
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

minetest.register_node("default:glass", {
	description = S("Glass"),
	drawtype = "glasslike_framed_optional",
	tiles = {"default_glass.png", "default_glass_detail.png"},
	use_texture_alpha = "clip", -- only needed for stairs API
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {map_node = 1, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_glass_defaults(),
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

minetest.register_node("default:brick", {
	description = S("Brick Block"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {
		"default_brick.png^[transformFX",
		"default_brick.png",
	},
	is_ground_content = false,
	groups = {map_node = 1},
	sounds = default.node_sound_stone_defaults(),
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

minetest.register_node("default:meselamp", {
	description = S("Mese Lamp"),
	drawtype = "glasslike",
	tiles = {"default_meselamp.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {map_node = 1, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_glass_defaults(),
	light_source = default.LIGHT_MAX,
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

default.register_mesepost("default:mese_post_light", {
	description = S("Apple Wood Mese Post Light"),
	texture = "default_fence_wood.png",
	material = "default:wood",
})

minetest.register_node("default:map_bottom", {
	description = S("Map Bottom"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {
		"default_cloud.png",
	},
	is_ground_content = false,
	damage_per_second = 100,
	move_resistance = 10,
	groups = {map_node = 1, not_in_creative_inventory = 1},
	sounds = default.node_sound_stone_defaults(),
	on_blast = function() end,
	can_dig = default.can_dig_map,
})

--
-- Misc
--

minetest.register_node("default:cloud", {
	description = S("Cloud"),
	tiles = {"default_cloud.png"},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
	groups = {not_in_creative_inventory = 1},
})
-- mods/default/tools.lua

-- support for MT game translation.
local S = default.get_translator

local bedcap = {times={[3]=1.00, [2]=1.00, [1]=1.00}, uses=0}
local woolcap = {times={[3]=1.00, [2]=0.90, [1]=0.75}, uses=0}

-- The hand
-- Override the hand item registered in the engine in builtin/game/register.lua
minetest.override_item("", {
	wield_scale = {x=1,y=1,z=2.5},
	tool_capabilities = {
		full_punch_interval = 0.25,
		max_drop_level = 0,
		groupcaps = {
			crumbly = {times={[2]=3.00, [3]=0.70}, uses=0, maxlevel=3},
			snappy = {times={[3]=0.40}, uses=0, maxlevel=3},
			cracky = {times={[3]=4.00}, uses=20, maxlevel=3},
			choppy = {times={[3]=3.70}, uses=0, maxlevel=3},
			oddly_breakable_by_hand = {times={[1]=3.50,[2]=2.00,[3]=0.70}, uses=0},
			bed = bedcap,
			wool = woolcap,
		},
		damage_groups = {fleshy=1},
	}
})

--
-- Picks
--

minetest.register_tool("default:pick_stone", {
	description = S("Stone Pickaxe"),
	inventory_image = "default_tool_stonepick.png",
	tool_capabilities = {
		full_punch_interval = 1.3,
		max_drop_level=0,
		groupcaps={
			cracky = {times={[2]=6.00, [3]=5.00}, uses=0, maxlevel=3},
			bed = bedcap,
			wool = woolcap,
		},
		damage_groups = {fleshy=3},
	},
	groups = {pickaxe = 1}
})

minetest.register_tool("default:pick_steel", {
	description = S("Steel Pickaxe"),
	inventory_image = "default_tool_steelpick.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			cracky = {times={[1]=8.00, [2]=5.60, [3]=4.80}, uses=0, maxlevel=3},
			bed = bedcap,
			wool = woolcap,
		},
		damage_groups = {fleshy=4},
	},
	groups = {pickaxe = 1}
})

minetest.register_tool("default:pick_diamond", {
	description = S("Diamond Pickaxe"),
	inventory_image = "default_tool_diamondpick.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=3,
		groupcaps={
			cracky = {times={[1]=6.00, [2]=5.0, [3]=4.50}, uses=0, maxlevel=3},
			bed = bedcap,
			wool = woolcap,
		},
		damage_groups = {fleshy=5},
	},
	groups = {pickaxe = 1}
})

--
-- Axes
--

minetest.register_tool("default:axe_stone", {
	description = S("Stone Axe"),
	inventory_image = "default_tool_stoneaxe.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps={
			choppy={times={[1]=7.00, [2]=6.0, [3]=5.30}, uses=0, maxlevel=3},
			bed = bedcap,
			wool = woolcap,
		},
		damage_groups = {fleshy=3},
	},
	groups = {axe = 1}
})

minetest.register_tool("default:axe_steel", {
	description = S("Steel Axe"),
	inventory_image = "default_tool_steelaxe.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=6.50, [2]=5.40, [3]=5.00}, uses=0, maxlevel=3},
			bed = bedcap,
			wool = woolcap,
		},
		damage_groups = {fleshy=4},
	},
	groups = {axe = 1}
})

minetest.register_tool("default:axe_diamond", {
	description = S("Diamond Axe"),
	inventory_image = "default_tool_diamondaxe.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=6.10, [2]=4.90, [3]=4.50}, uses=0, maxlevel=3},
			bed = bedcap,
			wool = woolcap,
		},
		damage_groups = {fleshy=7},
	},
	groups = {axe = 1}
})

--
-- Swords
--

minetest.register_tool("default:sword_wood", {
	description = S("Wooden Sword"),
	inventory_image = "default_tool_woodsword.png",
	tool_capabilities = {
		full_punch_interval = 1,
		max_drop_level=0,
		groupcaps={
			snappy={times={[2]=6.60, [3]=5.40}, uses=0, maxlevel=3},
			bed = bedcap,
			wool = woolcap,
		},
		damage_groups = {fleshy=2},
	},
	groups = {sword = 1, flammable = 2}
})

minetest.register_tool("default:sword_stone", {
	description = S("Stone Sword"),
	inventory_image = "default_tool_stonesword.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps={
			snappy={times={[2]=6.4, [3]=5.40}, uses=0, maxlevel=3},
			bed = bedcap,
			wool = woolcap,
		},
		damage_groups = {fleshy=4},
	},
	groups = {sword = 1}
})

minetest.register_tool("default:sword_steel", {
	description = S("Steel Sword"),
	inventory_image = "default_tool_steelsword.png",
	tool_capabilities = {
		full_punch_interval = 0.8,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=7.5, [2]=6.20, [3]=5.35}, uses=0, maxlevel=3},
			bed = bedcap,
			wool = woolcap,
		},
		damage_groups = {fleshy=6},
	},
	groups = {sword = 1}
})

minetest.register_tool("default:sword_diamond", {
	description = S("Diamond Sword"),
	inventory_image = "default_tool_diamondsword.png",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=6.90, [2]=5.90, [3]=5.20}, uses=0, maxlevel=3},
			bed = bedcap,
			wool = woolcap,
		},
		damage_groups = {fleshy=8},
	},
	groups = {sword = 1}
})

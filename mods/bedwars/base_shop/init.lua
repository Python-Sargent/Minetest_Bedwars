shop = {}

shop.basic_formspec = "size[8,9]item_image_button[0,0;1,1;default:sword_diamond;diamond_sword;Sword]list[current_player;main;0,5;8,4;]"

local replace_item = function(inv, type, level)
	if type == "sword" then
		if inv:contains_item("main", "default:sword_diamond") then inv:remove_item("main", ItemStack("default:sword_diamond")) end
		if inv:contains_item("main", "default:sword_wood") then inv:remove_item("main", ItemStack("default:sword_wood")) end
		if inv:contains_item("main", "default:sword_stone") then inv:remove_item("main", ItemStack("default:sword_stone")) end
		if inv:contains_item("main", "default:sword_steel") then inv:remove_item("main", ItemStack("default:sword_steel")) end
	elseif type == "pick" then
		if inv:contains_item("main", "default:pick_diamond") then inv:remove_item("main", ItemStack("default:pick_diamond")) end
		if inv:contains_item("main", "default:pick_stone") then inv:remove_item("main", ItemStack("default:pick_stone")) end
		if inv:contains_item("main", "default:pick_steel") then inv:remove_item("main", ItemStack("default:pick_steel")) end
	elseif type == "axe" then
		if inv:contains_item("main", "default:axe_diamond") then inv:remove_item("main", ItemStack("default:axe_diamond")) end
		if inv:contains_item("main", "default:axe_stone") then inv:remove_item("main", ItemStack("default:axe_stone")) end
		if inv:contains_item("main", "default:axe_steel") then inv:remove_item("main", ItemStack("default:axe_steel")) end
	elseif type == "shears" then
		if inv:contains_item("main", "default:shears") then inv:remove_item("main", ItemStack("default:shears")) end
	elseif type == "knockback_stick" then
		if inv:contains_item("main", "default:knockback_stick") then inv:remove_item("main", ItemStack("default:knockback_stick")) end
	end
end

shop.buy_item = function(inv, player, cost, item, type, reqtext)
	if inv:contains_item("main", cost) then
		if type then replace_item(inv, type) end -- just pass in nil if you don't want to replace anything
		player:get_inventory():add_item("main", item)
		inv:remove_item("main", ItemStack(cost))
	else
		minetest.chat_send_player(player:get_player_name(), "You need to have " .. reqtext .. " in order to buy this item.")
	end
end

local function createBasicShopFormspec(player)
	local inv = player:get_inventory()
	local sword = {item = "default:sword_stone", name = "stone_sword"}
	if inv:contains_item("main", "default:sword_diamond") then
		sword = {item = "default:sword_diamond", name = "diamond_sword"}
	elseif inv:contains_item("main", "default:sword_steel") then
		sword = {item = "default:sword_diamond", name = "diamond_sword"}
	elseif inv:contains_item("main", "default:sword_stone") then
		sword = {item = "default:sword_steel", name = "steel_sword"}
	elseif inv:contains_item("main", "default:sword_wood") then
		sword = {item = "default:sword_stone", name = "stone_sword"}
	end

	local pickaxe = {item = "default:pick_stone", name = "stone_pick"}
	if inv:contains_item("main", "default:pick_diamond") then
		pickaxe = {item = "default:pick_diamond", name = "diamond_pick"}
	elseif inv:contains_item("main", "default:pick_steel") then
		pickaxe = {item = "default:pick_diamond", name = "diamond_pick"}
	elseif inv:contains_item("main", "default:pick_stone") then
		pickaxe = {item = "default:pick_steel", name = "steel_pick"}
	end

	local name = player:get_player_name()
	local formspec = "size[8,9]" .. "list[current_player;main;0,5;8,4;]" ..
	"item_image_button[0,0;1,1;" .. sword.item.. ";" .. sword.name .. ";1]" ..
	"item_image_button[1,0;1,1;" .. pickaxe.item .. ";" .. pickaxe.name .. ";1]" ..
	"item_image_button[2,0;1,1;default:shears;shears;1]" ..
	"item_image_button[3,0;1,1;default:knockback_stick;knockback_stick;1]" ..
	"item_image_button[0,1;1,1;default:stone;stone;16]" ..
	"item_image_button[1,1;1,1;wool:" .. teams.get_team(name) .. ";wool;16]" ..
	"item_image_button[2,1;1,1;default:sandstone;sandstone;12]" ..
	"item_image_button[3,1;1,1;default:obsidian;obsidian;4]" ..
	"item_image_button[4,1;1,1;blastproof_glass:" .. teams.get_team(name) .. ";blastproof_glass;4]" ..
	"item_image_button[0,2;1,1;tnt:tnt;tnt;1]" ..
	"item_image_button[1,2;1,1;turret:turret;turret;1]" ..
	"item_image_button[2,2;1,1;fireball:fireball;fireball;1]" ..
	"item_image_button[3,2;1,1;enderpearl:ender_pearl;enderpearl;1]" ..
	"item_image_button[4,2;1,1;golden_apple:golden_apple;golden_apple;1]" ..
	"item_image_button[5,2;1,1;potions:jump_boost_potion;jump_boost;1]" ..
	"item_image_button[6,2;1,1;potions:speed_potion;speed;1]" ..
	"tooltip[stone_sword;Stone Sword\nCost: 10 Steel;grey;white]" ..
	"tooltip[steel_sword;Steel Sword\nCost: 7 Gold;grey;gold]" ..
	"tooltip[diamond_sword;Diamond Sword\nCost: 4 Mese;grey;lightgreen]" ..
	"tooltip[stone_pick;Stone Pickaxe\nCost: 6 Steel;grey;white]" ..
	"tooltip[steel_pick;Steel Pickaxe\nCost: 4 Gold;grey;gold]" ..
	"tooltip[diamond_pick;Diamond Pickaxe\nCost: 1 Mese;grey;lightgreen]" ..
	"tooltip[shears;Shears\nCost: 4 Steel Ingot;grey;white]" ..
	"tooltip[knockback_stick;Knockback Stick\nCost: 5 Gold Ingot;grey;gold]" ..
	"tooltip[wool;" .. teams.get_team(name) ..  " Wool\nCost: 4 Steel;grey;white]" ..
	"tooltip[sandstone;Sandstone\nCost: 24 Steel;grey;white]" ..
	"tooltip[stone;Stone\nCost: 4 Gold;grey;gold]" ..
	"tooltip[obsidian;Obsidian\nCost: 4 Mese;grey;lightgreen]" ..
	"tooltip[blastproof_glass;Blastproof Glass\nCost: 4 Steel Ingot;grey;white]" ..
	"tooltip[tnt;TNT\nCost: 4 Gold;grey;gold]" ..
	"tooltip[turret;Defensive Turret\nCost: 120 Steel;grey;white]" ..
	"tooltip[fireball;Fireball\nCost: 40 Steel;grey;white]" ..
	"tooltip[enderpearl;Enderpearl\nCost: 4 Mese;grey;lightgreen]" ..
	"tooltip[golden_apple;Golden Apple\nCost: 3 Gold Ingot;grey;gold]" ..
	"tooltip[jump_boost;Jump Boost Potion\nCost: 1 Mese;grey;lightgreen]" ..
	"tooltip[speed;Speed Potion\nCost: 1 Mese;grey;lightgreen]"

	return formspec
end

shop.register_shop = function(def)
	minetest.register_node("base_shop:" .. tostring(def.shop_name) .. "_shop", {
		description = tostring(def.shop_type) .. " Shop",
		drawtype = "nodebox",
		nodebox = {
			fixed = {
				{-0.5, -0.5, -0.45, 0.5, 0.5, 0.5},
			},
		},
		tiles = {
			"base_shop_side.png",
			"base_shop_side.png",
			"base_shop_side.png",
			"base_shop_side.png",
			"base_shop_front.png",
			"base_shop_side.png",
		},
		paramtype = "light",
		paramtype2 = "4dir",
		groups = {map_node = 1, shop = 1},
		on_blast = function() end,
		can_dig = default.can_dig_map,
		on_rightclick = function(pos, _, clicker)
			--local name = clicker:get_player_name()
			--[[local formspec_begin = "size[8,9]"
			local formspec_end = "list[current_player;main;0,5;8,4;]"
			local formspec_mid = "item_image_button[0,0;1,1;default:sword_stone;stone_sword;1]" ..
								 "item_image_button[1,0;1,1;default:sword_steel;steel_sword;1]" ..
								 "item_image_button[2,0;1,1;default:sword_diamond;diamond_sword;1]" ..
								 "item_image_button[3,0;1,1;default:pick_stone;stone_pick;1]" ..
								 "item_image_button[4,0;1,1;default:pick_steel;steel_pick;1]" ..
								 "item_image_button[5,0;1,1;default:pick_diamond;diamond_pick;1]" ..
								 "item_image_button[6,0;1,1;default:shears;shears;1]" ..
								 "item_image_button[7,0;1,1;default:knockback_stick;knockback_stick;1]" ..
								 "item_image_button[0,1;1,1;default:stone;stone;16]" ..
								 "item_image_button[1,1;1,1;wool:" .. teams.get_team(name) .. ";wool;16]" ..
								 "item_image_button[2,1;1,1;default:sandstone;sandstone;12]" ..
								 "item_image_button[3,1;1,1;default:obsidian;obsidian;4]" ..
								 "item_image_button[4,1;1,1;blastproof_glass:" .. teams.get_team(name) .. ";blastproof_glass;4]" ..
								 "item_image_button[0,2;1,1;tnt:tnt;tnt;1]" ..
								 "item_image_button[1,2;1,1;turret:turret;turret;1]" ..
								 "item_image_button[2,2;1,1;fireball:fireball;fireball;1]" ..
								 "item_image_button[3,2;1,1;enderpearl:ender_pearl;enderpearl;1]" ..
								 "item_image_button[4,2;1,1;golden_apple:golden_apple;golden_apple;1]" ..
								 "item_image_button[5,2;1,1;potions:jump_boost_potion;jump_boost;1]" ..
								 "item_image_button[6,2;1,1;potions:speed_potion;speed;1]"
			local formspec_mid2 = "tooltip[stone_sword;Stone Sword\nCost: 10 Steel;grey;white]" ..
								  "tooltip[steel_sword;Steel Sword\nCost: 7 Gold;grey;gold]" ..
								  "tooltip[diamond_sword;Diamond Sword\nCost: 4 Mese;grey;lightgreen]" ..
								  "tooltip[stone_pick;Stone Pickaxe\nCost: 6 Steel;grey;white]" ..
								  "tooltip[steel_pick;Steel Pickaxe\nCost: 4 Gold;grey;gold]" ..
								  "tooltip[diamond_pick;Diamond Pickaxe\nCost: 1 Mese;grey;lightgreen]" ..
								  "tooltip[shears;Shears\nCost: 4 Steel Ingot;grey;white]" ..
								  "tooltip[knockback_stick;Knockback Stick\nCost: 5 Gold Ingot;grey;gold]" ..
								  "tooltip[wool;" .. teams.get_team(name) ..  " Wool\nCost: 4 Steel;grey;white]" ..
								  "tooltip[sandstone;Sandstone\nCost: 24 Steel;grey;white]" ..
								  "tooltip[stone;Stone\nCost: 4 Gold;grey;gold]" ..
								  "tooltip[obsidian;Obsidian\nCost: 4 Mese;grey;lightgreen]" ..
								  "tooltip[blastproof_glass;Blastproof Glass\nCost: 4 Steel Ingot;grey;white]" ..
								  "tooltip[tnt;TNT\nCost: 4 Gold;grey;gold]" ..
								  "tooltip[turret;Defensive Turret\nCost: 120 Steel;grey;white]" ..
								  "tooltip[fireball;Fireball\nCost: 40 Steel;grey;white]" ..
								  "tooltip[enderpearl;Enderpearl\nCost: 4 Mese;grey;lightgreen]" ..
								  "tooltip[golden_apple;Golden Apple\nCost: 3 Gold Ingot;grey;gold]" ..
								  "tooltip[jump_boost;Jump Boost Potion\nCost: 1 Mese;grey;lightgreen]" ..
								  "tooltip[speed;Speed Potion\nCost: 1 Mese;grey;lightgreen]"]]

			--item_image_button[0,0;1,1;default:sword_diamond;diamond_sword;Sword]
			minetest.show_formspec(clicker:get_player_name(), "base_shop:" .. def.shop_type, createBasicShopFormspec(clicker))
		end,
	})

	minetest.register_on_player_receive_fields(function(player, formname, fields)
		if formname ~= "base_shop:" .. def.shop_type then
			return
		end
		
		local inv = player:get_inventory()
		if fields.diamond_sword then
			shop.buy_item(inv, player, "default:mese_crystal 4", "default:sword_diamond", "sword", "4 Mese Crystal")
		end
		if fields.steel_sword then
			shop.buy_item(inv, player, "default:gold_ingot 7", "default:sword_steel", "sword", "7 Gold Ingot")
		end
		if fields.stone_sword then
			shop.buy_item(inv, player, "default:steel_ingot 10", "default:sword_stone", "sword", "10 Steel Ingot")
		end
		if fields.diamond_pick then
			shop.buy_item(inv, player, "default:mese_crystal 1", "default:pick_diamond", "pick", "1 Mese Crystal")
		end
		if fields.steel_pick then
			shop.buy_item(inv, player, "default:gold_ingot 4", "default:pick_steel", "pick", "4 Gold Ingot")
		end
		if fields.stone_pick then
			shop.buy_item(inv, player, "default:steel_ingot 6", "default:pick_stone", "pick", "6 Steel Ingot")
		end
		if fields.shears then
			shop.buy_item(inv, player, "default:steel_ingot 4", "default:shears", "shears", "4 Steel Ingot")
		end
		if fields.knockback_stick then
			shop.buy_item(inv, player, "default:gold_ingot 5", "default:knockback_stick", "knockback_stick", "5 Gold Ingot")
		end
		if fields.wool then
			shop.buy_item(inv, player, "default:steel_ingot 4", "wool:" .. teams.get_team(player:get_player_name()) .." 16", nil, "4 Steel Ingot")
		end
		if fields.sandstone then
			shop.buy_item(inv, player, "default:steel_ingot 24", "default:sandstone 12", nil, "24 Steel Ingot")
		end
		if fields.stone then
			shop.buy_item(inv, player, "default:gold_ingot 4", "default:stone 16", nil, "4 Gold Ingot")
		end
		if fields.obsidian then
			shop.buy_item(inv, player, "default:mese_crystal 4", "default:obsidian 4", nil, "4 Mese Crystal")
		end
		if fields.blastproof_glass then
			shop.buy_item(inv, player, "default:steel_ingot 4", "blastproof_glass:" .. teams.get_team(player:get_player_name()) .." 4", nil, "4 Steel Ingot")
		end
		if fields.tnt then
			shop.buy_item(inv, player, "default:gold_ingot 4", "tnt:tnt", nil, "4 Gold Ingot")
		end
		if fields.turret then
			shop.buy_item(inv, player, "default:steel_ingot 120", "turret:turret", nil, "120 Steel Ingot")
		end
		if fields.fireball then
			shop.buy_item(inv, player, "default:steel_ingot 40", "fireball:fireball", nil, "40 Steel Ingot")
		end
		if fields.enderpearl then
			shop.buy_item(inv, player, "default:mese_crystal 4", "enderpearl:ender_pearl", nil, "4 Mese Crystal")
		end
		if fields.golden_apple then
			shop.buy_item(inv, player, "default:gold_ingot 3", "golden_apple:golden_apple", nil, "3 Golden Ingot")
		end
		if fields.jump_boost then
			shop.buy_item(inv, player, "default:mese_crystal 1", "potions:jump_boost_potion", nil, "1 Mese Crystal")
		end
		if fields.speed then
			shop.buy_item(inv, player, "default:mese_crystal 1", "potions:speed_potion", nil, "1 Mese Crystal")
		end
		if not fields.enter and not fields.quit then
			minetest.show_formspec(player:get_player_name(), "base_shop:" .. def.shop_type, createBasicShopFormspec(player))
		end
	end)
end

shop.register_shop({
	shop_type = "Basic",
	shop_name = "basic",
})

-- upgrade shops

local upgraded_players = {}

local upgrades = {
	["hp_extra"] = {
	add = function(player)
		local max_hp = 24 -- 2 extra hearts
		player:set_properties({hp_max = max_hp})
		player:set_hp(math.min(player:get_hp() + 4, max_hp))
		--minetest.log("HP Extra +2 added to " .. player:get_player_name())
	end,
	remove = function(player)
		local max_hp = 20 -- normal health
		player:set_properties({hp_max = max_hp})
		player:set_hp(max_hp)
		--minetest.log("HP Extra +2 removed from " .. player:get_player_name())
	end,
	name = "HP Extra +2"},

	["forge_1"] = {
	add = function(player) -- need to make this team specific
		item_spawner.forges[teams.get_team(player:get_player_name())] = item_spawner.times.forge.lvl2
		item_spawner.update_forge()
		--minetest.log("Forge I added to " .. teams.get_team(player:get_player_name()))
	end,
	remove = function(player)
		item_spawner.forges[teams.get_team(player:get_player_name())] = item_spawner.times.forge.lvl1
		item_spawner.update_forge()
		--minetest.log("Forge I removed from " .. teams.get_team(player:get_player_name()))
	end,
	name = "Forge I"},

	["forge_2"] = {
	add = function(player)
		item_spawner.forges[teams.get_team(player:get_player_name())] = item_spawner.times.forge.lvl3
		item_spawner.update_forge()
		--minetest.log("Forge II added to " .. teams.get_team(player:get_player_name()))
	end,
	remove = function(player)
		item_spawner.forges[teams.get_team(player:get_player_name())] = item_spawner.times.forge.lvl1
		item_spawner.update_forge()
		--minetest.log("Forge II removed from " .. teams.get_team(player:get_player_name()))
	end,
	name = "Forge II"},

	["forge_3"] = {
	add = function(player)
		item_spawner.forges[teams.get_team(player:get_player_name())] = item_spawner.times.forge.lvl4
		item_spawner.update_forge()
		--minetest.log("Forge III added to " .. teams.get_team(player:get_player_name()))
	end,
	remove = function(player)
		item_spawner.forges[teams.get_team(player:get_player_name())] = item_spawner.times.forge.lvl1
		item_spawner.update_forge()
		--minetest.log("Forge III removed from " .. teams.get_team(player:get_player_name()))
	end,
	name = "Forge III"},
}

shop.get_upgrade = function(inv, player, cost, upgrade, reqtext)
	if inv:contains_item("main", cost) then
		upgrades[upgrade].add(player)
		inv:remove_item("main", ItemStack(cost))
	else
		minetest.chat_send_player(player:get_player_name(), "You need to have " .. reqtext .. " in order to buy this item.")
	end
end

shop.remove_upgrade = function(player, upgrade)
	upgrades[upgrade].remove(player)
end

shop.remove_upgrades = function(player) -- used when player leaves game or game ends, also for /teams reset <param3>
	for i, upgrade in ipairs(upgrades) do
		upgrades[i].remove(player)
	end
end

shop.remove_all_upgrades = function()
	for pn in pairs(teams.players) do
		shop.remove_upgrades(minetest.get_player_by_name(pn))
	end
end

shop.find_upgrade = function(upgrade)
	if upgrades[upgrade] then
		return upgrades[upgrade]
	else
		return false
	end
end

teams.register_join_callback("remove_upgrades", {
	name = "remove_upgrades",
	func = function(player, team)
		shop.remove_upgrades(player)
	end
})

teams.register_start_callback("remove_upgrades", {
	name = "remove_upgrades",
	func = function()
		shop.remove_all_upgrades()
	end
})

teams.register_end_callback("remove_upgrades", {
	name = "remove_upgrades",
	func = function(team)
		shop.remove_all_upgrades()
	end
})

teams.register_leave_callback("remove_upgrades", {
	name = "remove_upgrades",
	func = function(player, team)
		shop.remove_upgrades(player)
	end
})

local function createUpgradesShopFormspec(player)
	local forge_lvl = {image = "default_steel_ingot.png", name = "forge_1", label = "Forge I"}
	if item_spawner.forges[teams.get_team(player:get_player_name())] == item_spawner.times.forge.lvl1 then
		forge_lvl = {image = "default_steel_ingot.png", name = "forge_1", label = "Forge I"}
	elseif item_spawner.forges[teams.get_team(player:get_player_name())] == item_spawner.times.forge.lvl2 then
		forge_lvl = {image = "default_gold_ingot.png", name = "forge_2", label = "Forge II"}
	elseif item_spawner.forges[teams.get_team(player:get_player_name())] == item_spawner.times.forge.lvl3 then
		forge_lvl = {image = "default_mese_crystal.png", name = "forge_3", label = "Forge III"}
	elseif item_spawner.forges[teams.get_team(player:get_player_name())] == item_spawner.times.forge.lvl4 then
		forge_lvl = {image = "default_mese_crystal.png", name = "forge_3", label = "Forge III"}
	end

	local formspec = "size[8,9]" .. "list[current_player;main;0,5;8,4;]" ..
			"image_button[0,0;1,1;heart.png;hp_extra;HP+]" ..
			"image_button[1,0;1,1;" .. forge_lvl.image .. ";" .. forge_lvl.name .. ";" .. forge_lvl.label .. "]"
	return formspec
end

shop.register_upgrade_shop = function(def)
	minetest.register_node("base_shop:" .. tostring(def.shop_name) .. "_upgrades_shop", {
		description = tostring(def.shop_type) .. " Upgrade Shop",
		drawtype = "nodebox",
		nodebox = {
			fixed = {
				{-0.5, -0.5, -0.45, 0.5, 0.5, 0.5},
			},
		},
		tiles = {
			"base_shop_side.png",
			"base_shop_side.png",
			"base_shop_side.png",
			"base_shop_side.png",
			"base_shop_front.png",
			"base_shop_side.png",
		},
		paramtype = "light",
		paramtype2 = "4dir",
		groups = {map_node = 1, shop = 1},
		on_blast = function() end,
		can_dig = default.can_dig_map,
		on_rightclick = function(pos, _, clicker)
			local name = clicker:get_player_name()
			--[[local formspec_begin = "size[8,9]"
			local formspec_end = "list[current_player;main;0,5;8,4;]"
			local formspec_mid = "image_button[0,0;1,1;heart.png;hp_extra;HP+]" ..
								 "image_button[1,0;1,1;default_steel_ingot.png;forge_1;Forge I]" ..
								 "image_button[2,0;1,1;default_gold_ingot.png;forge_2;Forge II]" ..
								 "image_button[3,0;1,1;default_mese_crystal.png;forge_3;Forge III]"
			local formspec_mid2 = "tooltip[hp_extra;+2 HP\nCost: 1 Diamond;grey;lightgreen]" ..
								  "tooltip[forge_1;Forge I\nCost: 4 Diamond;grey;lightgreen]" ..
								  "tooltip[forge_2;Forge II\nCost: 8 Diamond;grey;lightgreen]" ..
								  "tooltip[forge_3;Forge III\nCost: 16 Diamond;grey;lightgreen]"]]

			minetest.show_formspec(name, "base_shop:upgrades_" .. def.shop_type, createUpgradesShopFormspec(clicker))
		end,
	})

	minetest.register_on_player_receive_fields(function(player, formname, fields)
		if formname ~= "base_shop:upgrades_" .. def.shop_type then
			return
		end
		
		local inv = player:get_inventory()
		if fields.hp_extra then
			shop.get_upgrade(inv, player, "default:diamond 1", "hp_extra", "1 Diamond")
		elseif fields.forge_1 then
			shop.get_upgrade(inv, player, "default:diamond 4", "forge_1", "4 Diamond")
		elseif fields.forge_2 then
			shop.get_upgrade(inv, player, "default:diamond 8", "forge_2", "8 Diamond")
		elseif fields.forge_3 then
			shop.get_upgrade(inv, player, "default:diamond 16", "forge_3", "16 Diamond")
		end
		if not fields.enter and not fields.quit then
			minetest.show_formspec(player:get_player_name(), "base_shop:upgrades_" .. def.shop_type, createUpgradesShopFormspec(player))
		end
	end)
end

shop.register_upgrade_shop({
	shop_type = "Basic",
	shop_name = "basic",
})

minetest.register_chatcommand("shop", {
    privs = {
        interact = true,
    },
	description = "Usage: shop rm all|<upgrade>\n",
    func = function(name, param)
		local parts = param:split(" ")
		local cmd = parts[1]
		local has, missing = minetest.check_player_privs(name,  {server = true})

		if cmd == "rm" then
			if has then
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
			else
				return false, "Missing privilege: '" .. missing .. "'"
			end
		else
			return true, "Usage: teams <cmd> <param>"
		end
	end,
})

--[[
local max_hp = 24 -- 2 extra hearts
minetest.register_on_joinplayer(function(player)
	player:set_properties({hp_max = max_hp})
    player:set_hp(max_hp)
end)
]]

--player:get_inventory():add_item("main", "default:sword_diamond 1")
shop = {}

shop.basic_formspec = "size[8,9]item_image_button[0,0;1,1;default:sword_diamond;diamond_sword;Sword]list[current_player;main;0,5;8,4;]"

local replace_item = function(inv, type, level)
	if type == "sword" then
		if inv:contains_item("main", "default:sword_diamond") then inv:remove_item("main", ItemStack("default:sword_diamond")) end
		if inv:contains_item("main", "default:sword_wood") then inv:remove_item("main", ItemStack("default:sword_wood")) end
		if inv:contains_item("main", "default:sword_stone") then inv:remove_item("main", ItemStack("default:sword_stone")) end
		if inv:contains_item("main", "default:sword_steel") then inv:remove_item("main", ItemStack("default:sword_steel")) end
	end

	if type == "pick" then
		if inv:contains_item("main", "default:pick_diamond") then inv:remove_item("main", ItemStack("default:pick_diamond")) end
		if inv:contains_item("main", "default:pick_stone") then inv:remove_item("main", ItemStack("default:pick_stone")) end
		if inv:contains_item("main", "default:pick_steel") then inv:remove_item("main", ItemStack("default:pick_steel")) end
	end

	if type == "axe" then
		if inv:contains_item("main", "default:axe_diamond") then inv:remove_item("main", ItemStack("default:axe_diamond")) end
		if inv:contains_item("main", "default:axe_stone") then inv:remove_item("main", ItemStack("default:axe_stone")) end
		if inv:contains_item("main", "default:axe_steel") then inv:remove_item("main", ItemStack("default:axe_steel")) end
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
			local name = clicker:get_player_name()
			local formspec_begin = "size[8,9]"
			local formspec_end = "list[current_player;main;0,5;8,4;]"
			local formspec_mid = "item_image_button[0,0;1,1;default:sword_stone;stone_sword;1]" ..
								 "item_image_button[1,0;1,1;default:sword_steel;steel_sword;1]" ..
								 "item_image_button[2,0;1,1;default:sword_diamond;diamond_sword;1]" ..
								 "item_image_button[3,0;1,1;default:pick_stone;stone_pick;1]" ..
								 "item_image_button[4,0;1,1;default:pick_steel;steel_pick;1]" ..
								 "item_image_button[5,0;1,1;default:pick_diamond;diamond_pick;1]" ..
								 "item_image_button[0,1;1,1;default:stone;stone;16]" ..
								 "item_image_button[1,1;1,1;wool:" .. teams.get_team(name) .. ";wool;16]" ..
								 "item_image_button[2,1;1,1;default:sandstone;sandstone;12]" ..
								 "item_image_button[0,2;1,1;tnt:tnt;tnt;1]" ..
								 "item_image_button[1,2;1,1;fireball:fireball;fireball;1]" ..
								 "item_image_button[2,2;1,1;enderpearl:ender_pearl;enderpearl;1]"
			local formspec_mid2 = "tooltip[stone_sword;Stone Sword\nCost: 10 Steel;grey;white]" ..
								  "tooltip[steel_sword;Steel Sword\nCost: 7 Gold;grey;gold]" ..
								  "tooltip[diamond_sword;Diamond Sword\nCost: 4 Mese;grey;lightgreen]" ..
								  "tooltip[stone_pick;Stone Pickaxe\nCost: 6 Steel;grey;white]" ..
								  "tooltip[steel_pick;Steel Pickaxe\nCost: 4 Gold;grey;gold]" ..
								  "tooltip[diamond_pick;Diamond Pickaxe\nCost: 1 Mese;grey;lightgreen]" ..
								  "tooltip[wool;" .. teams.get_team(name) ..  " Wool\nCost: 4 Steel;grey;white]" ..
								  "tooltip[sandstone;Sandstone\nCost: 24 Steel;grey;white]" ..
								  "tooltip[stone;Stone\nCost: 4 Gold;grey;gold]" ..
								  "tooltip[obsidian;Obsidian\nCost: 4 Mese;grey;lightgreen]" ..
								  "tooltip[tnt;TNT\nCost: 4 Gold;grey;gold]" ..
								  "tooltip[fireball;Fireball\nCost: 40 Steel;grey;white]" ..
								  "tooltip[enderpearl;Enderpearl\nCost: 4 Mese;grey;lightgreen]"

			--item_image_button[0,0;1,1;default:sword_diamond;diamond_sword;Sword]
			if name then
				minetest.show_formspec(name, "base_shop:" .. def.shop_type, formspec_begin .. formspec_mid .. formspec_mid2 .. formspec_end)
			else
				minetest.chat_send_all("Player " .. name .. " attempted to use shop >> WARNING: variable 'name' is nil in function on_rightclick")
			end
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
		if fields.tnt then
			shop.buy_item(inv, player, "default:gold_ingot 4", "tnt:tnt", nil, "4 Gold Ingot")
		end
		if fields.fireball then
			shop.buy_item(inv, player, "default:steel_ingot 40", "fireball:fireball", nil, "40 Steel Ingot")
		end
		if fields.enderpearl then
			shop.buy_item(inv, player, "default:mese_crystal 4", "enderpearl:ender_pearl", nil, "4 Mese Crystal")
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
	["hp_extra"] = {add = function(player)
		local max_hp = 24 -- 2 extra hearts
		player:set_properties({hp_max = max_hp})
		player:set_hp(max_hp)
		minetest.log("HP Extra +2 added to " .. player:get_player_name())
	end, remove = function(player)
		local max_hp = 20 -- normal health
		player:set_properties({hp_max = max_hp})
		player:set_hp(max_hp)
		minetest.log("HP Extra +2 removed from " .. player:get_player_name())
	end, name = "HP Extra +2"},
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

shop.find_upgrade = function(upgrade)
	if upgrades[upgrade] then
		return upgrades[upgrade]
	else
		return false
	end
end

teams.register_join_callback("remove_upgrades", function(player, team)
	shop.remove_upgrades(player)
end)

teams.register_leave_callback("remove_upgrades", function(player, team)
	shop.remove_upgrades(player)
end)

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
			local formspec_begin = "size[8,9]"
			local formspec_end = "list[current_player;main;0,5;8,4;]"
			local formspec_mid = "image_button[0,0;1,1;heart.png;hp_extra;HP+]"
			local formspec_mid2 = "tooltip[hp_extra;+2 HP\nCost: 1 Diamond;grey;lightgreen]"

			if name then
				minetest.show_formspec(name, "base_shop:" .. def.shop_type, formspec_begin .. formspec_mid .. formspec_mid2 .. formspec_end)
			else
				minetest.chat_send_all("Player " .. name .. " attempted to use shop >> WARNING: variable 'name' is nil in function on_rightclick")
			end
		end,
	})

	minetest.register_on_player_receive_fields(function(player, formname, fields)
		if formname ~= "base_shop:" .. def.shop_type then
			return
		end
		
		local inv = player:get_inventory()
		if fields.hp_extra then
			shop.get_upgrade(inv, player, "default:diamond 1", "hp_extra", "1 Diamond")
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
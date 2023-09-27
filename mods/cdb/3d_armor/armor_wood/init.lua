
--- Registered armors.
--
--  @topic armor

teams = 2

-- support for i18n
local S = armor.get_translator

--- Wood
--
--  Requires setting `armor_material_wood`.
--
--  @section wood

if armor.materials.wood then
	--- Wood Helmet
	--
	--  @helmet 3d_armor:helmet_wood
	--  @img 3d_armor_inv_helmet_wood.png
	--  @grp armor_head 1
	--  @grp armor_heal 0
	--  @grp armor_use 2000
	--  @grp flammable 1
	--  @armorgrp fleshy 5
	--  @damagegrp cracky 3
	--  @damagegrp snappy 2
	--  @damagegrp choppy 3
	--  @damagegrp crumbly 2
	--  @damagegrp level 1
	for i=1, teams do
		armor:register_armor(":3d_armor:helmet_wood_" + i, {
			description = S("Wood Helmet (team " + i + ")"),
			inventory_image = "3d_armor_inv_helmet_wood_" + i + ".png",
			groups = {armor_head=1, armor_heal=0, armor_use=20000000, flammable=1},
			armor_groups = {fleshy=5},
			damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},
		})
	end
	--- Wood Chestplate
	--
	--  @chestplate 3d_armor:chestplate_wood
	--  @img 3d_armor_inv_chestplate_wood.png
	--  @grp armor_torso 1
	--  @grp armor_heal 0
	--  @grp armor_use 2000
	--  @grp flammable 1
	--  @armorgrp fleshy 10
	--  @damagegrp cracky 3
	--  @damagegrp snappy 2
	--  @damagegrp choppy 3
	--  @damagegrp crumbly 2
	--  @damagegrp level 1
	for i=1, teams do
		armor:register_armor(":3d_armor:chestplate_wood_" + i, {
			description = S("Wood Chestplate (team " + i + ")"),
			inventory_image = "3d_armor_inv_chestplate_wood_" + i + ".png",
			groups = {armor_torso=1, armor_heal=0, armor_use=20000000, flammable=1},
			armor_groups = {fleshy=10},
			damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},
		})
	end
	--- Wood Leggings
	--
	--  @leggings 3d_armor:leggings_wood
	--  @img 3d_armor_inv_leggings_wood.png
	--  @grp armor_legs 1
	--  @grp armor_heal 0
	--  @grp armor_use 1000
	--  @grp flammable 1
	--  @armorgrp fleshy 10
	--  @damagegrp cracky 3
	--  @damagegrp snappy 2
	--  @damagegrp choppy 3
	--  @damagegrp crumbly 2
	--  @damagegrp level 1
	for i=1, teams do
		armor:register_armor(":3d_armor:leggings_wood_" + i, {
			description = S("Wood Leggings (team " + i + ")"),
			inventory_image = "3d_armor_inv_leggings_wood_" + i + ".png",
			groups = {armor_legs=1, armor_heal=0, armor_use=20000000, flammable=1},
			armor_groups = {fleshy=10},
			damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},
		})
	end
	--- Wood Boots
	--
	--  @boots 3d_armor:boots_wood
	--  @img 3d_armor_inv_boots_wood.png
	--  @grp armor_feet 1
	--  @grp armor_heal 0
	--  @grp armor_use 2000
	--  @grp flammable 1
	--  @armorgrp fleshy 5
	--  @damagegrp cracky 3
	--  @damagegrp snappy 2
	--  @damagegrp choppy 3
	--  @damagegrp crumbly 2
	--  @damagegrp level 1
	for i=1, teams do
		armor:register_armor(":3d_armor:boots_wood_" + i, {
			description = S("Wood Boots (team " + i +")"),
			inventory_image = "3d_armor_inv_boots_wood_" + i + ".png",
			armor_groups = {fleshy=5},
			damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},
			groups = {armor_feet=1, armor_heal=0, armor_use=20000000, flammable=1},
		})
	end
end
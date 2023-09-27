--Mod-specific global variable
projectile = {}

--A list of registered projectile entites, indexed by the category of weapon that uses them.
projectile.registered_projectiles = {}

--Per-player list of much a projectile weapon has been charged.
projectile.charge_levels = {}



--MP = Mod Path
local mp = minetest.get_modpath(minetest.get_current_modname())..'/'

--In here is every publicly available function that this mod uses.
dofile(mp.."api.lua")

--In here is the registration of ammo items that this mod provides, as well as crafting recipes for weapons and ammo.
dofile(mp.."crafts.lua")



--A helper function to cancel a player's charge when necessary.
local function uncharge_player(player)
	--Useful shorthand
	local pname = player:get_player_name()

	--If there is charge data...
	if projectile.charge_levels[pname] then
		--Get store the previous slot for possible use after charge data deletion.
		local old_slot = projectile.charge_levels[pname].slot
		--Get the projectile weapon. get_wielded_item() can't be used, since the weapon may no longer be held.
		local wep = player:get_inventory():get_stack("main", old_slot)

		--If the weapon was /pulverized or otherwise deleted without triggering a callback...
		if wep:is_empty() then
			--Delete the entry directly, which normally happens inside the weapon's on_use function.
			projectile.charge_levels[pname] = nil
		else
			--Call the weapon's on_use function, which will cancel it.
			wep:get_definition().on_use(wep, player, true)
		end

		--Update the player's inventory with any modifications.
		player:get_inventory():set_stack("main", old_slot, wep)
	end
end

--Globalsteps are used to either cancel a charge if a player switches weapons, or to update the weapon sprite when charging is complete.
minetest.register_globalstep(function(dtime)
	--For each player on the server...
	for _, player in pairs(minetest.get_connected_players()) do
		--Useful shorthand
		local pname = player:get_player_name()

		--If this player is currently charging a projectile weapon...
		if projectile.charge_levels[pname] then
			--If the player's selected hotbar slot changed or their weapon was deleted somehow...
			if player:get_wield_index() ~= projectile.charge_levels[pname].slot or player:get_wielded_item():is_empty() then
				--Cancel their charge.
				uncharge_player(player)

			--Otherwise, as long as the player doesn't change weapon...
			else
				--Add a little charge, according the how much time that has passed since the last globalstep.
				projectile.charge_levels[pname].charge = projectile.charge_levels[pname].charge + dtime

				--Get the charging weapon and its definition
				local wep = player:get_wielded_item()
				local def = wep:get_definition()

				--if the weapon has a listed full_charge_name, meaning it hasn't already fully charged,
				--but now the charge level has reached or exceeded the max...
				if def.full_charge_name and projectile.charge_levels[pname].charge >= def.charge_time then
					--Once this happens, replace the weapon with a fully charged sprite version.
					wep:set_name(def.full_charge_name)
					player:set_wielded_item(wep)

					--Enable a callback that can occur when the weapon is fully charged
					if def.on_charge_full then
						def.on_charge_full(wep, player)
					end
				end
			end
		end
	end
end)

--When a weapon is charging, it's a lot harder to check for when the stack has moved elsewhere, at least in terms of checking it.
--So, if a player tries any inventory action related to a charging projectile weapon, prevent it.
minetest.register_allow_player_inventory_action(function(player, action, inv, info)
	if (action == "take" and minetest.get_item_group(info.stack:get_name(), "projectile_weapon") >= 2) or
			(action == "put" and minetest.get_item_group(inv:get_stack(info.listname, info.index):get_name(), "projectile_weapon") >= 2) or
			(action == "move" and 
			(minetest.get_item_group(inv:get_stack(info.from_list, info.from_index):get_name(), "projectile_weapon") >= 2 or
			minetest.get_item_group(inv:get_stack(info.to_list, info.to_index):get_name(), "projectile_weapon") >= 2)) then
		return 0
	end
end)

--If a player leaves, cancel their charge.
minetest.register_on_leaveplayer(function(player)
	uncharge_player(player)
end)

--If a server is shutdown, cancel all charges.
minetest.register_on_shutdown(function()
	for _, player in pairs(minetest.get_connected_players()) do
		uncharge_player(player)
	end
end)

--The basic bow. It is more powerful than a slingshot, but it takes way longer to charge and ammunition is harder to get.
projectile.register_weapon("projectile:bow",  {
	description = "Bow",
	inventory_image = "projectile_bow.png",
	inventory_image_2 = "projectile_bow_charged.png",
	inventory_image_3 = "projectile_bow_charged_full.png",
	durability = 100,
	rw_category = "bow",
	charge = true,
	fire_while_charging = true,
	charge_time = 2,

	on_charge_begin = function(wep, user)
		projectile.charge_levels.sound = minetest.sound_play("projectile_bow_drawn_paveroux", {gain = 1.0, object = user})
	end,

	after_fire = function(wep, user)
		minetest.sound_play("projectile_bow_release_porkmuncher", {gain = 1.0, pos = user:get_pos()}, true)
	end
})

--A helper function for mese projectiles, to check if a particular node can be powered.
local is_mesecon = function(pos)
	local def = minetest.registered_nodes[minetest.get_node(pos).name]

	return def and def.mesecons
end

--The basic arrow, which has twice the power of a rock.
projectile.register_projectile("projectile:arrow", "bow", "projectile:arrow", {
	damage = 10,
	speed = 30,

	initial_properties = {
		visual = "mesh",
		mesh = "projectile_arrow.obj",
		textures = {"projectile_arrow_texture.png"}
	},

	_on_step = function(self, dtime)
		projectile.autorotate_arrow(self, dtime)

		if fire then
			local selfo = self.object
			local node = minetest.get_node(selfo:get_pos())

			if minetest.get_item_group(node.name, "lava") > 0 or minetest.get_item_group(node.name, "fire") > 0 then
				local arrow = minetest.add_entity(selfo:get_pos(), "projectile:arrow_fire")
				local arrowlua = arrow:get_luaentity()

				arrow:set_velocity(selfo:get_velocity())
				arrow:set_acceleration(selfo:get_acceleration())
				arrow:set_rotation(selfo:get_rotation())

				arrowlua.level = self.level
				arrowlua.damage = 12
				arrowlua.owner = self.owner
				arrowlua.oldvel = self.oldvel
				arrowlua.timer = self.timer

				selfo:remove()
			end
		end
	end
})

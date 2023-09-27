
--This function registers a weapon able to shoot projectiles
function projectile.register_weapon(name, def)
	--either create a groups table for the definition, or use the provided one
	def.groups = def.groups or {}
	--Every projectile weapon belongs to the projectile_weapon group.
	def.groups.projectile_weapon = 1

	--Charge time defaults to 1 second
	def.charge_time = def.charge_time or 1
	--The weapon's damage multiplier defaults to 1.
	def.damage = def.damage or 1
	--The weapon's speed multiplier defaults to 1.
	def.speed = def.speed or 1

	--A function that determines when a weapon can fire. If none is provided in a definition, a weapon can always fire.
	--Note that it does not prevent the need for ammunition.
	def.can_fire = def.can_fire or function() return true end

	--If this weapons has to be charged...
	if def.charge then
		--Define a function to reset the weapon's sprite and delete the player's charge data.
		local uncharge = function(wep, user, cancelled)
			--If nothing was fired and the weapon defines an on_cancel function, call it.
			if cancelled and def.on_cancel then
				def.on_cancel(wep, user)
			end

			if projectile.charge_levels[user:get_player_name()] and projectile.charge_levels[user:get_player_name()].sound then
				minetest.sound_stop(projectile.charge_levels[user:get_player_name()].sound)
			end

			--Delete charge data.
			projectile.charge_levels[user:get_player_name()] = nil

			--Change the name of the stack to transform it back to its uncharged form.
			wep:set_name(name)

			return wep
		end

		--A function that begins a new charge, or fires a shot if the player is charging.
		local charge = function(wep, user)
			--If it is allowed to fire...
			if def.can_fire(wep, user) then
				local pname = user:get_player_name()

				--If there is no charge data yet...
				if not projectile.charge_levels[pname] then
					local inv = user:get_inventory()

					--Look for ammo in the player's inventory, starting from the first slot.
					for i = 1, inv:get_size("main") do
						--Get the itemstack of the current slot.
						local ammo = inv:get_stack("main", i)

						--If the stack is there, and it's registered as ammo that this weapon can use...
						if not ammo:is_empty() and projectile.registered_projectiles[def.rw_category][ammo:get_name()] then
							--Create new charge data. Store the inventory slot of the weapon, and start the charge at 0
							projectile.charge_levels[pname] = {slot = user:get_wield_index(), charge = 0}

							--As feedback for the charge beginning, change the weapon's sprite to show it loaded.
							--I originally wanted the item to be shown loaded with specific ammo, but it doesn't seem to be possible.
							wep = ItemStack({name = name.."_2", wear = wep:get_wear()})

							--If a callback is defined to do something when a charge begins, call it now.
							if def.on_charge_begin then
								def.on_charge_begin(wep, user)
							end

							--Once ammo is found, the search can be stopped.
							break
						end
					end

					--If no ammo was found, a charge won't start at all. No dry-firing allowed.

				--Otherwise, if there is charge data...
				else
					--If a callback is defined to do something right before firing, call it now.
					if def.on_fire then
						def.on_fire(wep, user)
					end

					--Shoot out the projectile
					projectile.shoot(wep, user, projectile.charge_levels[pname].charge)

					--If a callback is defined to do something right after firing, call it now.
					if def.after_fire then
						def.after_fire(wep, user)
					end

					--Then, end the charge
					uncharge(wep, user, false)
				end
			end

			return wep
		end

		--Right-click to start a charge. Right-click again to fire.
		def.on_place = charge
		def.on_secondary_use = charge
		--Left-click to cancel a charge without firing.
		def.on_use = uncharge

		--Start the creating of the partially and fully charged versions of this item, first by copying the definition.
		local def2 = table.copy(def)
		local def3 = table.copy(def)

		--The partially and fully-charged versions have specific inventory images
		def2.inventory_image = def.inventory_image_2
		def3.inventory_image = def.inventory_image_3
		--The projectile_weapon group rating increases with charge level
		def2.groups.projectile_weapon = 2
		def3.groups.projectile_weapon = 3
		--Partially charged weapons cannot be grabbed from the creative inventory.
		def2.groups.not_in_creative_inventory = 1
		def3.groups.not_in_creative_inventory = 1

		--Weapons that need charging can only be fired before fully charging if def.fire_while_charging is set to true.
		if def.charge and not def.fire_while_charging then
			def2.on_place = nil
			def2.on_secondary_use = nil
		end

		--Some versions store the names of different versions, for convenience.
		--The partially-charged version stores the name of the fully charged version, to be used when transitioning to the fully charged version.
		def2.full_charge_name = name.."_3"
		--Full and partial charge versions can both be cancelled, so they remember the name of the uncharged version
		def2.no_charge_name = name
		def3.no_charge_name = name

		--Finally, register the partially and fully charged projectile weapons.
		minetest.register_tool(name.."_2", def2)
		minetest.register_tool(name.."_3", def3)
	else
		--Otherwise, right-click simply shoots the projectile.
		def.on_place = function(wep, user)
			--If it is allowed to fire...
			if def.can_fire(wep, user) then
				--Shoot every time on_place is called.
				projectile.shoot(wep, user)
			end
		end

		def.on_secondary_use = def.on_place
	end

	--Finally, register the projectile weapon here.
	--This is the only thing that happens regardless of if the weapon has to charge or not.
	minetest.register_tool(name, def)
end

--Register a projectile that can be fired by a weapon.
--Note that it also has to define what kind of weapon can fire it, and the item version of itself.
function projectile.register_projectile(name, usable_by, ammo, def)
	--First, check that a table exists for that particular weapon category. If not, make it.
	projectile.registered_projectiles[usable_by] = projectile.registered_projectiles[usable_by] or {}
	--Then, add this projectile to said table.
	projectile.registered_projectiles[usable_by][ammo] = name

	--Default initial properties for the projectile
	--Including the table itself, if it wasn't already created.
	def.initial_properties = def.initial_properties or {}
	--The projectile is always physical. It has to hit stuff, after all.
	def.initial_properties.physical = true
	--The projectile also definitely has to be able to hit other entities.
	def.initial_properties.collide_with_objects = true
	--By default, the projectile's hitbox is half a block in size.
	def.initial_properties.collisionbox = def.initial_properties.collisionbox or  {-.25, 0, -.25, .25, .5, .25}
	--The projectile can't be hit by players.
	def.initial_properties.pointable = false
	--By default, the projectile is a flat image, provided by the "image" field.
	def.initial_properties.visual = def.initial_properties.visual or "sprite"
	def.initial_properties.textures = def.initial_properties.textures or {def.image}
	--By default, the projectile's visual size is also half size.
	def.initial_properties.visual_size = def.initial_properties.visual_size or {x = 0.5, y = 0.5, z = 0.5}
	--The projectile won't be saved if it becomes unloaded.
	def.initial_properties.static_save = false

	--collide_self allows projectiles fired by the same person to strike each other. This is true by default.
	if def.collide_self == nil then
		def.collide_self = true
	end

	--"visible" can be used as a shorthand to set itself in initial_properties.
	if def.visible == false then
		def.initial_properties.is_visible = false
	end

	--During each of this entity's steps...
	def.on_step = function(self, dtime, info)
		--Let projectiles define their own on_step if they need to
		if self._on_step then
			self._on_step(self, dtime, info)
		end

		--A little shorthand
		local selfo = self.object
		--By default, assume nothing was hit this step.
		local hit = false

		--selfo:get_pos() is used to know if remove() was called in the _on_step function.
		if not selfo:get_pos() then
			return
		end

		--For each collision that was found...
		for k, c in pairs(info.collisions) do
			--If it's a node, don't do anything more than acknowledging that something was hit.
			if c.type == "node" then
				hit = true

				--Get the definition of the node that was hit...
				local ndef = minetest.registered_nodes[minetest.get_node(c.node_pos).name]
				--If the definition exists and defines a sound for being dug...
				if ndef and ndef.sounds and ndef.sounds.dug then
					--Play that sound
					minetest.sound_play(ndef.sounds.dug, {gain = 1.0, pos = c.node_pos}, true)
				end

			--If it's an object...
			else
				--As long as that object isn't the player who fired this projectile and the target isn't already dead...
				--And the target isn't a projectile owned by the same player when collide_self is disabled...
				--And the target isn't in the same party as this projectile's owner...
				if not (c.object:is_player() and self.owner == c.object:get_player_name()) and c.object:get_hp() > 0
						and not (self.collide_self == false and not c.object:is_player() and self.owner == c.object:get_luaentity().owner) 
						and not projectile.in_same_party(self, c.object) then
					--Acknowledge the hit
					hit = true
					--Deal damage to the target.
					c.object:punch(selfo, 1, {full_punch_interval = 1, damage_groups = {fleshy = def.damage * self.level * self.damage}}, vector.normalize(selfo:get_velocity()))
				else
					--Otherwise, pass by the object as best as possible. 
					selfo:set_velocity(self.oldvel)
				end
			end
		end

		--If this projectile hit something...
		if hit then
			--Grant the entity an on_impact function that it can define
			if self.on_impact then
				self:on_impact(info.collisions)
			end

			if node_damage and minetest.settings:get_bool("placeable_impacts_damage_nodes") then
				for _, c in pairs(info.collisions) do
					if c.type == "node" then
						node_damage.damage(c.node_pos)
						break
					end
				end
			end

			--Make the projectile destroy itself.
			selfo:remove()
		end
	end

	--Finally, register the entity.
	minetest.register_entity(name, def)
end

--A function that creates and launches a function out of a player's side when they use a projectile weapon.
function projectile.shoot(wep, user, level)
	--Some useful shorthands
	local pname = user:get_player_name()
	local inv = user:get_inventory()
	local def = wep:get_definition()

	--A projectile isn't spawned directly inside a player, and it doesn't come from the center of the screen.
	--It does start directly in front of the player...
	local pos = user:get_look_dir()
	--But then it's shifted to the right of the player, where it looks like the weapon is held.
	pos = vector.rotate(pos, {x=0 , y = -math.pi / 4, z=0})
	--Then it's shifted up by the player's face.
	pos.y = 1
	--The user's actual position is added last, to make rotating easier.
	pos = vector.add(pos, user:get_pos())

	--Charge level depends on how long the player waited before firing. 1 = 100% charge.
	level = math.min(level / def.charge_time, 1)

	--Look through each inventory slot...
	for i = 1, inv:get_size("main") do
		--Get the stack itself
		local ammo = inv:get_stack("main", i)
		--Get the name of the entity that will be created by this ammo type.
		local ammo_entity = projectile.registered_projectiles[def.rw_category][ammo:get_name()]

		--If there is an item stack, and it's registered as an ammo type that this weapon can use...
		if not ammo:is_empty() and ammo_entity then
			local adef = minetest.registered_entities[ammo_entity]

			--Fire an amount of projectiles at once according to the ammo's defined "count".
			for n = 1, (adef.count or 1) do
				--Create the projectile entity at the determined position
				local projectile = minetest.add_entity(pos, ammo_entity)
				--A shorthand of the luaentity version of the projectile, where data can easily be stored
				local luapro = projectile:get_luaentity()

				--Set velocity according to the direction it was fired. Speed is determined by the weapon, ammo, and how long the weapon was charged.
				projectile:set_velocity(vector.multiply(user:get_look_dir(), luapro.speed * level * def.speed))
				--An acceleration of -9.81y is how gravity is applied.
				projectile:set_acceleration({x=0, y=-9.81, z=0})

				--If the ammo defines a spread, randomly rotate the direction of velocity by that given radius.
				if adef.spread then
					local rx = (math.random() * adef.spread * 2 - adef.spread) * math.pi / 180
					local ry = (math.random() * adef.spread * 2 - adef.spread) * math.pi / 180

					projectile:set_velocity(vector.rotate(projectile:get_velocity(), {x = rx, y = ry, z = 0}))
				end

				--Store level for later, to determine impact damage
				luapro.level = level
				--Also store the projectile's damage itself.
				luapro.damage = def.damage
				--The player's name is stored to prevent hitting yourself
				--And by "hitting yourself" I mean accidentally being hit by the arrow just by firing it at a somewhat low angle, the moment it spawns.
				luapro.owner = pname
				--Store the initial velocity for passing by objects when needed.
				luapro.oldvel = projectile:get_velocity()
			end

			--If the player isn't in creative mode, some weapon durability and ammo is consumed.
			if not minetest.is_creative_enabled(pname) then
				ammo:take_item(1)
				inv:set_stack("main", i, ammo)

				wep:add_wear(65536 / (def.durability or 100))
			end

			--Once the ammo is found, the search is stopped.
			break
		end
	end

	return wep
end

--A helper function to know when the party of a projectile's owner and target is the same.
function projectile.in_same_party(projectile, target)
	--Automatically return false if:
	--The parties mod isn't included.
	--The target isn't a player.
	--The projectile's target and/or owner isn't in a party/
	if not parties or not target:is_player() or not parties.is_player_in_party(projectile.owner) or not parties.is_player_in_party(target:get_player_name()) then 
		return false 
	end

	--Return true only if the projectile's owner and target and under the same party leadership.
	return parties.get_party_leader(projectile.owner) == parties.get_party_leader(target:get_player_name())
end

--A helper functions for arrows in general, as they rotate themselves according to how they move.
function projectile.autorotate_arrow(self)
	--Shorthand for velocity
	local v = self.object:get_velocity()
	--Set calculate rotation according to velocity
	local rot = vector.dir_to_rotation(v)

	--Define a timer for itself. Based on how fast its currently moving, and how far the timer has progressed,
	--this makes it seem to spin through the air, with the tip still always pointing forward.
	self.timer = (self.timer or 0) + (v.x + v.y + v.z) / 30
	rot.z = rot.z + self.timer

	--Apply the calculated rotation.
	self.object:set_rotation(rot)
end
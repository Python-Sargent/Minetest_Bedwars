potions = {}

potions.effects = {}

potions.huds = {}

potions.register_effect_hud = function(name)
    potions.huds[name] = {
        image = "potions_effect_" .. name .. ".png",
    }
end

potions.remove_hud = function(player, effect)
    player:hud_remove(potions.players[player:get_player_name()].hud[effect])
end

potions.remove_all_hud = function(player)
    for effect_name in pairs(potions.players[player:get_player_name()].hud) do
        potions.remove_hud(player, effect_name)
    end
end

potions.update_hud = function(player)
    potions.remove_all_hud(player)
    local count = 0
    for effect_name in pairs(potions.players[player:get_player_name()].effects) do
        potions.players[player:get_player_name()].hud[effect_name] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 1 - count / 20, y = 0.05},
            offset    = {x = 0, y = 0},
            text      = potions.huds[effect_name].image .. "^[opacity:"..math.min(potions.players[player:get_player_name()].effects[effect_name].time * 10, 255),
            scale     = { x = 5, y = 5},
            alignment = { x = -1, y = 0 },
        })
        count = count + 1
    end
end

potions.register_effect = function(effect)
    potions.effects[effect.name] = effect
    potions.register_effect_hud(effect.name)
end

potions.players = {}

potions.remove_effect = function(player, effect)
    potions.players[player:get_player_name()].effects[effect].on_end(player)
    potions.remove_hud(player, effect)
    potions.players[player:get_player_name()].effects[effect] = nil
end

potions.remove_all_effects = function(player)
    if potions.players[player:get_player_name()] == nil then return end
    for effect_name in pairs(potions.players[player:get_player_name()].effects) do
        potions.remove_effect(player, effect_name)
    end
end

teams.register_join_callback("init_effects", {
	name = "init_effects",
	func = function(player, team)
		potions.players[player:get_player_name()] = {effects = {}, hud = {}}
        potions.remove_all_effects(player)
	end
})

teams.register_die_callback("remove_effects", {
	name = "remove_effects",
	func = function(player, team)
		potions.remove_all_effects(player)
	end
})

teams.register_leave_callback("remove_effects", {
	name = "remove_effects",
	func = function(player, team)
		potions.remove_all_effects(player)
        potions.players[player:get_player_name()] = nil
	end
})

local function indexOf(table, name)
    local count = 0
    for n in pairs(table) do
        count = count + 1
        if n == name then
            return count
        end
    end
    return nil
end

potions.add_effect = function(player, effect, time, strength)
    potions.players[player:get_player_name()].effects[effect] = potions.effects[effect]
    potions.players[player:get_player_name()].effects[effect].time = time
    potions.players[player:get_player_name()].effects[effect].on_apply(player, strength)
    potions.update_hud(player)
end

potions.do_effects = function(dtime)
    for pn in pairs(potions.players) do
        local effects = potions.players[pn].effects
        for effect_name in pairs(effects) do
            if effects[effect_name].time > dtime then
                effects[effect_name].on_step(minetest.get_player_by_name(pn), dtime)
                potions.players[pn].effects[effect_name].time = potions.players[pn].effects[effect_name].time - dtime
            else
                potions.remove_effect(minetest.get_player_by_name(pn), effect_name)
            end
        end
    end
end

minetest.register_globalstep(function(dtime)
    potions.do_effects(dtime)
end)

potions.register_effect({
    name = "jump_boost",
    on_apply = function(player, strength)
        player:set_physics_override({
            jump = 1 * strength
        })
    end,
    on_end = function(player)
        player:set_physics_override({
            jump = 1
        })
        minetest.chat_send_player(player:get_player_name(), "Your jump boost effect ran out.")
    end,
    on_step = function(player, dtime) potions.update_hud(player) end,
    time = 0,
})

potions.register_effect({
    name = "speed",
    on_apply = function(player, strength)
        player:set_physics_override({
            speed = 1 * strength
        })
    end,
    on_end = function(player)
        player:set_physics_override({
            speed = 1
        })
        minetest.chat_send_player(player:get_player_name(), "Your speed effect ran out.")
    end,
    on_step = function(player, dtime) potions.update_hud(player) end,
    time = 0
})

potions.register_potion = function(name, def)
    minetest.register_craftitem("potions:" .. name .. "_potion", {
        description = def.description .. " Potion",
        inventory_image = "potions_" .. name .. "_potion.png",
        on_use = function(itemstack, user, pointed_thing)
            if potions.effects[name] and potions.players[user:get_player_name()] then
                potions.add_effect(user, name, def.time, def.strength)
                user:get_inventory():remove_item("main", "potions:" .. name .. "_potion")
            end
        end
    })
end

potions.register_potion("jump_boost", {
    description = "Jump Boost",
    strength = 2,
    time = 30,
})

potions.register_potion("speed", {
    description = "Speed",
    strength = 2,
    time = 30,
})
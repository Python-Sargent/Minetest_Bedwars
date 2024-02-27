minetest.register_node("turret:turret", {
    description = "Defensive Turret",
    paramtype = "light",
    paramtype2 = "4dir",
    tiles = {
        "turret_top.png",
        "turret_bottom.png",
        "turret_side.png",
        "turret_side.png",
        "turret_side.png",
        "turret_front.png",
    },
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {-0.25, -0.5, -0.4, 0.25, 0.5, 0.5}
    },
    after_place_node = function(pos, placer, itemstack, pointed_thing) 
        local meta = minetest.get_meta(pos)
        meta:set_string("owner", placer:get_player_name())
    end,
    on_construct = function(pos, node)
        local timer = minetest.get_node_timer(pos)
        timer:start(120)
    end,
    on_timer = function(pos, elapsed)
        minetest.set_node(pos, {name="air"}) --remove turret
    end,
})

minetest.register_abm({
    label = "Turret Damage",
    nodenames = {"turret:turret"},
    interval = 1,
    chance = 1,
    catch_up = false,
    action = function(pos, node)
        local closest_d = 5
        local closest_name

        for i, obj in ipairs(minetest.get_objects_inside_radius(pos, closest_d)) do
            if minetest.is_player(obj) then
                local distance = vector.length(vector.subtract(obj:get_pos(), pos))
                if distance < closest_d then
                    closest_d = distance
                    closest_name = obj:get_player_name()
                end
            end
        end
        if closest_name ~= nil then
            local node_meta = minetest.get_meta(pos)
            if teams.get_team(closest_name) ~= teams.get_team(node_meta:get_string("owner")) then
                local player = minetest.get_player_by_name(closest_name)
                player:set_hp(player:get_hp() - 2)
            end
        end
    end,
})
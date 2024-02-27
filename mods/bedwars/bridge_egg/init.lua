bridge_egg = {}
local t = minetest.get_translator("bridge_egg")
local callbacks = {}

minetest.register_craftitem("bridge_egg:bridge_egg", {
  description = ("Bridge Egg"),
  inventory_image = "bridge_egg.png",
  stack_max = 16,
  on_use =
    function(_, player, pointed_thing)
      local throw_starting_pos = vector.add({x=0, y=-1.5, z=0}, player:get_pos())
      local ender_pearl = minetest.add_entity(throw_starting_pos, "bridge_egg:thrown_bridge_egg", player:get_player_name())

      minetest.after(0, function() player:get_inventory():remove_item("main", "bridge_egg:bridge_egg") end)
    
      minetest.sound_play("fireball_throw", {max_hear_distance = 15, pos = player:get_pos()})
    end,
  
})

-- entity declaration
local thrown_bridge_egg = {
  initial_properties = {
    hp_max = 1,
    physical = true,
    collide_with_objects = false,
    collisionbox = {-0.4, -0.4, -0.4, 0.4, 0.4, 0.4},
    visual = "wielditem",
    visual_size = {x = 0.5, y = 0.5},
    textures = {"bridge_egg:bridge_egg"},
    spritediv = {x = 1, y = 1},
    initial_sprite_basepos = {x = 0, y = 0},
    pointable = false,
    speed = 100,
    gravity = 10,
    lifetime = 60,
  },
  start_pos = vector.new(),
  player_name = ""
}

function thrown_bridge_egg:on_step(dtime, moveresult)  
  local collided_with_node = moveresult.collisions[1] and moveresult.collisions[1].type == "node"

  if collided_with_node then
    
    --create the bridge

    self.object:remove()
  end
end

function thrown_bridge_egg:on_activate(staticdata)
  if not staticdata or not minetest.get_player_by_name(staticdata) then
    self.object:remove()
    return
  end

  self.player_name = staticdata
  local player = minetest.get_player_by_name(staticdata)
  local yaw = player:get_look_horizontal()
  local pitch = player:get_look_vertical()
  local dir = player:get_look_dir()

  self.object:set_rotation({x = -pitch, y = yaw, z = 0})
  self.object:set_velocity({
      x=(dir.x * self.initial_properties.speed),
      y=(dir.y * self.initial_properties.speed),
      z=(dir.z * self.initial_properties.speed),
  })
  self.object:set_acceleration({x=dir.x*-4, y=-self.initial_properties.gravity, z=dir.z*-4})

  minetest.after(self.initial_properties.lifetime, function() self.object:remove() end)
end

minetest.register_entity("bridge_egg:thrown_bridge_egg", thrown_bridge_egg)

-- on_bridge(hit_node)
function bridge_egg.on_bridge(pos1, pos2, team)
  
end

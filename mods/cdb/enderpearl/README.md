<h2> Functions </h2>

**enderpearl.block_teleport(player, [duration])**

Stops the player from teleporting for the specified duration
(if it isn't nil). To allow a player to teleport again just set
the duration to 0.

<br>

<h2> Callbacks </h2>

**enderpearl.on_teleport(function(hit_node) end)**

Called when the enderpearl hits a node.
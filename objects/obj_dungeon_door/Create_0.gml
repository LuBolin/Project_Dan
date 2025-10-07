/// Dungeon Door - Create

// door_type and target_room are set via object properties in the room editor
// door_type: "entry" or "exit"
// target_room: which room to go to when player collides (for exit doors)

// Entry door fade system
fade_timer = 0;
fade_duration = 60; // 1 second at 60fps
should_fade = false;

// Set sprite based on door type
if (door_type == "entry") {
    // Use entry door sprite if it exists, otherwise keep default
    if (sprite_exists(spr_dungeon_entry_door)) {
        sprite_index = spr_dungeon_entry_door;
    } else {
        image_blend = c_green; // Fallback to greenish tint
    }

    // Spawn or move player at entry door and start fade
    if (!instance_exists(obj_player)) {
        // Create player if doesn't exist (first time entering level)
        var player = instance_create_layer(x, y, layer, obj_player);
        player.image_xscale = 0.25;
        player.image_yscale = 0.25;
    } else {
        // Move existing player (returning from alchemy)
        obj_player.x = x;
        obj_player.y = y;

        // Ensure camera is following the player
        var cam_inst = instance_exists(obj_camera) ? instance_find(obj_camera, 0) : noone;
        if (cam_inst == noone) {
            cam_inst = instance_create_layer(x, y, layer, obj_camera);
        }
        cam_inst.follow = obj_player;
        cam_inst.smooth = 0.12;
        cam_inst.preferred_ratio = 0.2;
    }
    should_fade = true;
} else {
    // Exit doors keep the default sprite (spr_dungeon_door)
    image_blend = c_ltgray; // Exit doors are light gray
}

/// @function shoot_projectile(projectile)
/// @param {Id.Instance} _entity The entity the projectile was fired from
/// @param {Struct} projectile The type of projectile fired
function spawn_and_set_projectile(_entity, projectile, target_x, target_y) {
    var ang  = point_direction(_entity.x, _entity.y, target_x, target_y);
    var r    = player_radius_simple(_entity);
    var gap  = 8;

    var sx = _entity.x + lengthdir_x(r + gap, ang);
    var sy = _entity.y + lengthdir_y(r + gap, ang);

	var inst = instance_create_layer(sx, sy, "Instances", obj_projectile);

	if (inst != noone) {
        if (is_struct(projectile)) {
            // Store the projectile struct for behavior callbacks
            inst.proj_data = projectile;

            // Copy properties from projectile struct to instance
            if (!is_undefined(projectile.damage))     inst.damage     = projectile.damage;
            if (!is_undefined(projectile.speed)) {
                // Convert speed from units per second to pixels per frame
                // units/sec * pixels/unit / frames/sec = pixels/frame
                inst.speed = (projectile.speed * global.UNIT_LENGTH) / game_get_speed(gamespeed_fps);
            }
            if (!is_undefined(projectile.life_steps)) inst.life_steps = projectile.life_steps;
            if (!is_undefined(projectile.sprite_index)) inst.sprite_index = projectile.sprite_index;
            if (!is_undefined(projectile.kb_speed)) inst.kb_speed  = projectile.kb_speed;
            if (!is_undefined(projectile.kb_distance)) inst.kb_distance  = projectile.kb_distance;
			if (!is_undefined(projectile.scale)) {
				inst.image_xscale = projectile.scale;
				inst.image_yscale = projectile.scale;
			}
        }

        inst.creator = _entity;
        inst.direction = ang;
        inst.image_angle = ang;

        // Call on_launch callback if it exists
        if (is_struct(projectile) && variable_struct_exists(projectile, "on_launch")) {
            projectile.on_launch(inst);
        }
    }
}


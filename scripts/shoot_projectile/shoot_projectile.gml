/// @function shoot_projectile(projectile)
/// @param {Id.Instance} _player The player the projectile was fired from
/// @param {Struct} projectile The type of projectile fired
function spawn_and_set_projectile(_player, projectile) {
    var ang  = point_direction(_player.x, _player.y, mouse_x, mouse_y);
    var r    = player_radius_simple(_player);
    var gap  = 3;

    var sx = _player.x + lengthdir_x(r + gap, ang);
    var sy = _player.y + lengthdir_y(r + gap, ang);

	var inst = instance_create_layer(sx, sy, "Instances", obj_projectile);
	
	if (inst != noone) {
        // attach prototype struct so obj_projectile can read proj_data if it expects it
        if (is_struct(projectile)) {
            inst.proj_data = projectile;
            // copy commonly used fields so Create/Step can rely on them directly
            if (!is_undefined(projectile.damage))     inst.damage     = projectile.damage;
            if (!is_undefined(projectile.speed))      inst.speed      = projectile.speed;
            if (!is_undefined(projectile.life_steps)) inst.life_steps = projectile.life_steps;
            if (!is_undefined(projectile.sprite_index)) inst.sprite_index = projectile.sprite_index;
            if (!is_undefined(projectile.knockback)) inst.knockback  = projectile.knockback;
			if (!is_undefined(projectile.projectile_type)) inst.projectile_type  = projectile.projectile_type;
        }

        inst.creator = _player;
        inst.direction = ang;
        inst.image_angle = ang;
    }
}


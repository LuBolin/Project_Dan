function GourdBase() constructor {
    name = "";
	color = c_black;

	cooldown = 0;
	cooldown_timer = 0;

	projectile = ProjectileBase;

    can_use = function () {
        return (cooldown_timer <= 0);
    }

    trigger_cd = function () {
        cooldown_timer = cooldown * game_get_speed(gamespeed_fps);
    }

    step = function () {
        if (cooldown_timer > 0) cooldown_timer -= 1;
    }

    use = function(_p) {
        if (can_use()) {
			var proj = new projectile();
			// Check if projectile is implemented (has speed property)
			if (variable_struct_exists(proj, "speed")) {
				spawn_and_set_projectile(_p, proj, mouse_x, mouse_y);
				trigger_cd();
			} else {
				// Unimplemented projectile - show message on screen
				show_debug_message(name + " is unimplemented");
			}
        }
    };
}

function gourd_create(_constructor) {
    return new _constructor();
}

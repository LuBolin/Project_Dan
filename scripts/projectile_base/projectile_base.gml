function ProjectileBase() constructor {
	name = "";
	speed       = 0;           // pixels per step
	direction   = 0;            // set at spawn
	image_angle = direction;    // rotate sprite to flight dir
	damage      = 0;
	life_steps  = game_get_speed(gamespeed_fps);  // ~1s lifetime
	creator     = noone;        // set to the player when spawning
	knockback = 0;
	sprite_index = -1;
	projectile_type = ProjectileBase;
}

function projectile_create(_constructor) {
    return new _constructor();
}

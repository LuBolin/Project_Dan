// Global constant: One unit = 64 pixels (player size is 64x64, which is 1 unit)
global.UNIT_LENGTH = 64;

function ProjectileBase() constructor {
	name = "";
	speed       = 0;
	damage      = 0;
	life_steps  = game_get_speed(gamespeed_fps);
	kb_speed = 0;
	kb_distance = 0;
	sprite_index = -1;
	scale = 1.0;

	on_hit = function(projectile_inst, target) {
		// Default: do nothing
	}
}

function projectile_create(_constructor) {
    return new _constructor();
}

function ProjectileFireball() constructor { // test placeholder projectile
	name = "Fireball";
	speed       = 8;           // pixels per step
	direction   = 0;            // set at spawn
	image_angle = direction;    // rotate sprite to flight dir
	damage      = 2;
	life_steps  = game_get_speed(gamespeed_fps) * 1.2;  // ~1.2s lifetime
	creator     = noone;        // set to the player when spawning
	knockback = 2;
	sprite_index = spr_fire_projectile;
	projectile_type = ProjectileFireball;
}

function ProjectileRock() constructor { // test placeholder projectile
	name = "Rock";
	speed       = 8;           // pixels per step
	direction   = 0;            // set at spawn
	image_angle = direction;    // rotate sprite to flight dir
	damage      = 4;
	life_steps  = game_get_speed(gamespeed_fps) * 1.2;  // ~1.2s lifetime
	creator     = global.player;        // set to the player when spawning
	knockback = 0;
	sprite_index = spr_rock;
	projectile_type = ProjectileRock;
}

function ProjectileWaterBall() constructor {
	name = "Water Ball";
	speed       = 8;           // pixels per step
	direction   = 0;            // set at spawn
	image_angle = direction;    // rotate sprite to flight dir
	damage      = 2;
	life_steps  = game_get_speed(gamespeed_fps) * 1.2;  // ~1.2s lifetime
	creator     = global.player;        // set to the player when spawning
	knockback = 2;
	sprite_index = spr_water_ball;
	projectile_type = ProjectileWaterBall;
}

function ProjectileWindGust() constructor {
	name = "Wind Gust";
	speed       = 8;           // pixels per step
	direction   = 0;            // set at spawn
	image_angle = direction;    // rotate sprite to flight dir
	damage      = 0;
	life_steps  = game_get_speed(gamespeed_fps) * 1.2;  // ~1.2s lifetime
	creator     = global.player;        // set to the player when spawning
	knockback = 4;
	sprite_index = spr_wind_gust;
	projectile_type = ProjectileWindGust;
}

function ProjectileMudBall() constructor {
	name = "Mud Ball";
	speed       = 8;           // pixels per step
	direction   = 0;            // set at spawn
	image_angle = direction;    // rotate sprite to flight dir
	damage      = 0;
	life_steps  = game_get_speed(gamespeed_fps) * 1.2;  // ~1.2s lifetime
	creator     = global.player;        // set to the player when spawning
	knockback = 4;
	sprite_index = spr_mud_ball;
	projectile_type = ProjectileMudBall;
}

function ProjectileHurricane() constructor {
	name = "Hurricane";
	speed       = 8;           // pixels per step
	direction   = 0;            // set at spawn
	image_angle = direction;    // rotate sprite to flight dir
	damage      = 0;
	life_steps  = game_get_speed(gamespeed_fps) * 1.2;  // ~1.2s lifetime
	creator     = global.player;        // set to the player when spawning
	knockback = 4;
	sprite_index = spr_hurricane;
	projectile_type = ProjectileHurricane;
}

}
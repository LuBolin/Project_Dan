/// Steam Cloud - Create Event

// Owner (player who created the steam)
owner = noone;

// Visual properties
image_alpha = 0;
fade_in_duration = 15;  // frames to fade in
fade_out_duration = 30; // frames to fade out

// Scale to cover good area around player (adjust as needed)
image_xscale = 2.6;  // increased by 30%
image_yscale = 2.6;  // increased by 30%

// Collision radius for damage (matches the actual sprite visual size, not oversized)
collision_radius = 83; // pixels - increased by 30% (was 64)

// Lifespan: 5 seconds total
life_duration = game_get_speed(gamespeed_fps) * 5;
life_timer = life_duration;

// Damage properties
damage_per_tick = 1;
tick_rate = 30; // Damage every 30 frames (0.5 seconds at 60fps)
tick_counter = 0;

// Damage target configuration
damage_enemies = true;  // Default: damage enemies
damage_player = !damage_enemies;  // Default: don't damage player
creator = noone;        // Who created this pool (for identification)

// Track which enemies have been hit recently to prevent instant re-hits
hit_cooldown_map = ds_map_create(); // enemy_id -> last_hit_time

// Set depth so it renders above ground but below player/enemies
depth = 100;

// Rotation for visual effect
rotation_speed = 0.5; // degrees per frame
// Scale to reasonable size
image_xscale = 1.0;
image_yscale = 1.0;

// Lifespan: 8 seconds (longer than mud for more damage)
life_timer = game_get_speed(gamespeed_fps) * 8;

// Track which enemies have been hit recently to prevent instant re-hits
hit_cooldown_map = ds_map_create(); // enemy_id -> last_hit_time

// Damage properties
damage_per_tick = 2; // Higher damage than steam
tick_rate = 20; // Damage every 20 frames (~0.33 seconds at 60fps)
tick_counter = 0;

// Burn effect properties
burn_duration = game_get_speed(gamespeed_fps) * 2; // 2 second burn
burn_damage = 1; // 1 damage per second

// Set depth so it renders below most objects
depth = 500;

// Visual fade-in/out
alpha = 0;
fade_in_duration = 15; // frames
fade_out_duration = 30; // frames

// Glow effect for visual feedback
glow_timer = 0;
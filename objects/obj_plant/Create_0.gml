// Owner (player who created the healing area)
owner = noone;

// Visual properties
image_alpha = 0;
fade_in_duration_seconds = 0.33;  // seconds to fade in
fade_out_duration_seconds = 0.5;  // seconds to fade out
fade_in_duration = fade_in_duration_seconds * game_get_speed(gamespeed_fps);  // Convert to frames
fade_out_duration = fade_out_duration_seconds * game_get_speed(gamespeed_fps); // Convert to frames

// Scale to reasonable healing area size
image_xscale = 2.5;  // Larger than steam for healing area
image_yscale = 2.5;

// Healing radius for player detection
healing_radius = 80; // pixels - generous healing area

// Lifespan: 8 seconds total
life_duration_seconds = 8;
life_duration = life_duration_seconds * game_get_speed(gamespeed_fps);
life_timer = life_duration;

// Healing properties
heal_per_tick = 1; // Amount of health restored per tick
tick_rate_seconds = 1.5; // Heal every 0.75 seconds
tick_rate = tick_rate_seconds * game_get_speed(gamespeed_fps); // Convert to frames
tick_counter = 0;

// Track when player was last healed to prevent spam healing
last_heal_time = 0;
heal_cooldown_seconds = 0.5; // 0.5 seconds between heals
heal_cooldown = heal_cooldown_seconds * 1000; // Convert to milliseconds for current_time

// Set depth so it renders below player but above ground
depth = 200;

// Rotation for visual effect
rotation_speed = 0.3; // degrees per frame (slower than steam for peaceful feel)

// Healing particle effect timer
particle_timer = 0;
particle_interval_seconds = 0.5; // Create ambient particles every 0.5 seconds
particle_interval = particle_interval_seconds * game_get_speed(gamespeed_fps);

heal_enemies = false
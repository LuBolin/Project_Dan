// Owner (player who created the healing area)
owner = noone;

// Visual properties
image_alpha = 0;
fade_in_duration = 20;  // frames to fade in
fade_out_duration = 30; // frames to fade out

// Scale to reasonable healing area size
image_xscale = 2.5;  // Larger than steam for healing area
image_yscale = 2.5;

// Healing radius for player detection
healing_radius = 80; // pixels - generous healing area

// Lifespan: 8 seconds total
life_duration = game_get_speed(gamespeed_fps) * 8;
life_timer = life_duration;

// Healing properties
heal_per_tick = 1; // Amount of health restored per tick
tick_rate = 45; // Heal every 45 frames (0.75 seconds at 60fps)
tick_counter = 0;

// Track when player was last healed to prevent spam healing
last_heal_time = 0;
heal_cooldown = 500; // 0.5 seconds between heals (in milliseconds)

// Set depth so it renders below player but above ground
depth = 200;

// Rotation for visual effect
rotation_speed = 0.3; // degrees per frame (slower than steam for peaceful feel)

// Healing particle effect timer
particle_timer = 0;
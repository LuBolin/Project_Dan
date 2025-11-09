// Scale to reasonable size
image_xscale = 0.25;
image_yscale = 0.25;

// Compute base (unscaled) diameter and initial radius
var base_w = sprite_get_width(sprite_index);
var base_h = sprite_get_height(sprite_index);
aoe_base_diam = max(base_w, base_h);
aoe_radius = (aoe_base_diam * max(image_xscale, image_yscale)) * 0.5;

// Lifespan: 8 seconds (longer than mud for more damage)
life_timer = game_get_speed(gamespeed_fps) * 8;

// Track which entities have been hit recently to prevent instant re-hits
hit_cooldown_map = ds_map_create(); // entity_id -> last_hit_time

// Damage properties
damage_per_tick = 1.5; // Higher damage than steam
tick_rate = 50; // Damage every 50 frames (~0.83 seconds at 60fps)
tick_counter = 0;

// Burn effect properties
burn_duration = game_get_speed(gamespeed_fps) * 2; // 2 second burn
burn_damage = 1; // 1 damage per second

// Damage target configuration
creator = noone;        // Who created this pool (for identification)

// Set depth so it renders below most objects
depth = 300;

// Visual fade-in/out
alpha = 0;
fade_in_duration = 15; // frames
fade_out_duration = 30; // frames

// Glow effect for visual feedback
glow_timer = 0;
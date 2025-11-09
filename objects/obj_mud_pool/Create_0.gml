// Scale to reasonable size (128px sprite -> ~128px displayed for good coverage)
image_xscale = 0.25;
image_yscale = 0.25;

// Compute base (unscaled) diameter and initial radius
var base_w = sprite_get_width(sprite_index);
var base_h = sprite_get_height(sprite_index);
aoe_base_diam = max(base_w, base_h);
aoe_radius = (aoe_base_diam * max(image_xscale, image_yscale)) * 0.5;

// Lifespan: 5 seconds
life_timer = game_get_speed(gamespeed_fps) * 5;

// Overrides lifespan to last forever
is_forever = false;

// Track which enemies are currently slowed
slowed_enemies = ds_list_create();

// Slow effect percentage
slow_amount = 0.5; // 50% slow

// Set depth so it renders below most objects
depth = 300;

// Visual fade-in/out
alpha = 0;
fade_in_duration = 15; // frames
fade_out_duration = 30; // frames

// Damage target configuration
damage_enemies = true;  // Default: damage enemies
damage_player = !damage_enemies;  // Default: don't damage player
creator = noone;        // Who created this pool (for identification)
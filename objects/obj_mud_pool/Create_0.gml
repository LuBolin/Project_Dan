/// Mud Pool - Create Event

// Scale to reasonable size (128px sprite -> ~128px displayed for good coverage)
image_xscale = 1.0;
image_yscale = 1.0;

// Lifespan: 5 seconds
life_timer = game_get_speed(gamespeed_fps) * 5;

// Track which enemies are currently slowed
slowed_enemies = ds_list_create();

// Slow effect percentage
slow_amount = 0.3; // 30% slow

// Set depth so it renders below most objects
depth = 500;

// Visual fade-in/out
alpha = 0;
fade_in_duration = 15; // frames
fade_out_duration = 30; // frames

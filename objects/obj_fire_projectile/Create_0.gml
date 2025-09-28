speed       = 8;           // pixels per step
direction   = 0;            // set at spawn
image_angle = direction;    // rotate sprite to flight dir
damage      = 10;
life_steps  = game_get_speed(gamespeed_fps) * 1.2;  // ~1.2s lifetime
creator     = noone;        // set to the player when spawning
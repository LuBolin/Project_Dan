// Initialize projectile data, will get overridden by spawn_and_set_projectiles
proj_data = {};
creator = noone;
damage = 1;
speed = 0;
life_steps = game_get_speed(gamespeed_fps);
kb_speed = 0;
kb_distance = 0;

// Set depth so projectiles render above most objects
depth = -5;
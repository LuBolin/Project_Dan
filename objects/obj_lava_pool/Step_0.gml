// Decrease lifetime
life_timer--;

// Fade in at start
if (life_timer > game_get_speed(gamespeed_fps) * 8 - fade_in_duration) {
    alpha = min(1, alpha + (1 / fade_in_duration));
}
// Fade out near end
else if (!is_forever && life_timer <= fade_out_duration) {
    alpha = max(0, alpha - (1 / fade_out_duration));
}
// Fully visible
else {
    alpha = 1;
}

// Glow animation
glow_timer += 0.1;

// Destroy when lifetime expires
if (!is_forever && life_timer <= 0) {
    ds_map_destroy(hit_cooldown_map);
    instance_destroy();
    exit;
}

// Keep radius in sync with scale (eruption may resize)
aoe_radius = (aoe_base_diam * max(image_xscale, image_yscale)) * 0.5;

// Advance tick counter
tick_counter++;
var do_damage = (tick_counter >= tick_rate);
if (do_damage) tick_counter = 0;

// Gather entities once per frame (not per tick) — damage only if do_damage true
var entities_to_check = [];

if (damage_enemies) {
    var enemy_list = ds_list_create();
    var n = collision_circle_list(x, y, aoe_radius, obj_enemy_abstract, false, true, enemy_list, false);
    for (var i = 0; i < n; i++) {
        var e = enemy_list[| i];
        if (instance_exists(e)) array_push(entities_to_check, e);
    }
    ds_list_destroy(enemy_list);
}

if (damage_player && instance_exists(obj_player)) {
    if (point_distance(x, y, obj_player.x, obj_player.y) <= aoe_radius) {
        array_push(entities_to_check, obj_player);
    }
}

// Apply damage ONLY on tick frames
if (do_damage) {
    for (var j = 0; j < array_length(entities_to_check); j++) {
        var ent = entities_to_check[j];
        if (!instance_exists(ent)) continue;

        damage_entity(ent, damage_per_tick);
        add_status_effect(ent, new BurnEffect(burn_duration, burn_damage));
    }
}

// Prune dead entries if you still track hit_cooldown_map (not needed now)
// If you remove hit_cooldown_map entirely, delete this block and its creation/destruction.
if (ds_exists(hit_cooldown_map, ds_type_map)) {
    var key = ds_map_find_first(hit_cooldown_map);
    while (!is_undefined(key)) {
        var next_key = ds_map_find_next(hit_cooldown_map, key);
        if (!instance_exists(key)) {
            ds_map_delete(hit_cooldown_map, key);
        }
        key = next_key;
    }
}
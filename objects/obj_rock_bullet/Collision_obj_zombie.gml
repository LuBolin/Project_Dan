if (!has_hit) {
    has_hit = true;
    damage_entity(other, damage);
    add_status_effect(other, new StunEffect(game_get_speed(gamespeed_fps) * 0.5));
    instance_destroy();
}

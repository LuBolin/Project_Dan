damage_entity(other, damage)
apply_knockback(self, other, knockback)
if (projectile_type == ProjectileRock) {
    add_status_effect(other, new StunEffect(game_get_speed(gamespeed_fps) * 0.5));
}
if (projectile_type != ProjectileWindGust) {
	instance_destroy(); // bullet disappears on hit
}

damage_entity(other, base_damage)
apply_knockback(self, other, 2, 40)  // speed: 2, distance: 40
apply_knockback(other, self, 0.3, 0.3, undefined, 20, true)
alarm[0] = game_get_speed(gamespeed_fps) 

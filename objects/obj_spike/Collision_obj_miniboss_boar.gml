apply_knockback(self, other, 2, 40)  // speed: 2, distance: 40
add_status_effect(other, new StunEffect(150))
damage_entity(other, base_damage)

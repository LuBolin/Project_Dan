// Check if player is invulnerable before applying ANY effects
if (variable_instance_exists(other, "invuln") && other.invuln) {
    apply_knockback(self, other, 2, 40); // push boar away for feedback
    exit;
}

apply_knockback(self, other, 2, 40); // Knockback player

if (!pause || is_charging) {

    if (is_charging) {
        apply_knockback(self, other, 3, global.UNIT_LENGTH * 2); // Knockback player
    }
    damage_entity(other, base_damage);
    apply_knockback(other, self, 0.3, 0.3, undefined, 20, true); // Knockback Boar
}
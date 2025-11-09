// Check if player is invulnerable before applying damage
if (variable_instance_exists(other, "invuln") && other.invuln) {
    // Still apply knockback to enemy when they hit invulnerable player
    apply_knockback(self, other, 2, 40);
    exit; // Don't damage or knockback player
}

apply_knockback(self, other, 2, 40); // Knockback enemy

if (!pause) {
    damage_entity(other, base_damage);
    apply_knockback(other, self, 0.3, 0.3, undefined, 20, true); // Knockback player
}

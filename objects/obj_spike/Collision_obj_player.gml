// Player invulnerability check
if (variable_instance_exists(other, "invuln") && other.invuln) {
    exit; // no damage, no knockback
}

// Vulnerable → apply damage/knockback
apply_knockback(self, other, 2, 40);
damage_entity(other, base_damage);
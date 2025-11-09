// Reset red flash
image_blend = c_white;

// CHANGED: Only clear invuln if no InvincibilityEffect is active
var has_invuln_effect = false;
if (variable_instance_exists(self, "status_effects_list")) {
    for (var i = 0; i < array_length(status_effects_list); i++) {
        var eff = status_effects_list[i];
        if (is_struct(eff) && variable_struct_exists(eff, "get_type") && eff.get_type() == "Invincible") {
            has_invuln_effect = true;
            break;
        }
    }
}

// Only reset invuln flag if no status effect is managing it
if (!has_invuln_effect) {
    invuln = false;
}
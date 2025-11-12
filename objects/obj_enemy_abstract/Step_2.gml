// Don't touch stationary trees
if (object_index == obj_evil_tree || object_index == obj_miniboss_tree) {
    exit;
}

// Default: 1 = sprite faces right, -1 = faces left
if (!variable_instance_exists(self, "sprite_face_dir")) sprite_face_dir = 1;

// If this frame’s movement was caused by knockback/charge, don’t update facing
if (variable_instance_exists(self, "moved_by_knockback") && moved_by_knockback) exit;

// Face by horizontal movement this frame; fallback to face player
var dx = x - xprevious;
var face_sign = 0;
if (abs(dx) > 0.1) {
    face_sign = sign(dx);
} else if (instance_exists(obj_player)) {
    var delta = obj_player.x - x;
    if (abs(delta) > 1) face_sign = sign(delta);
}

if (face_sign != 0) {
    var base_mag = max(0.0001, abs(image_xscale));
    image_xscale = base_mag * sprite_face_dir * face_sign;
}
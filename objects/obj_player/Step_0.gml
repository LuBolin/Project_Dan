update_status_effects(self);

if (hp <= 0) exit;

var input_dirn_x = 0;
var input_dirn_y = 0;

if (keyboard_check(ord("A"))) input_dirn_x -= 1;
if (keyboard_check(ord("D"))) input_dirn_x += 1;
if (keyboard_check(ord("W"))) input_dirn_y -= 1;
if (keyboard_check(ord("S"))) input_dirn_y += 1;

var magnitude = sqrt(input_dirn_x * input_dirn_x + input_dirn_y * input_dirn_y);
var vel_hori = (magnitude == 0 ? 0 : (input_dirn_x / magnitude)) * move_speed;
var vel_vert = (magnitude == 0 ? 0 : (input_dirn_y / magnitude)) * move_speed;

move_and_collide(vel_hori, vel_vert, colliders, undefined, undefined, undefined, move_speed, move_speed);

if (input_dirn_x != 0) {
    var scale = abs(image_xscale);
    image_xscale = (input_dirn_x > 0) ? scale : -scale;
}

if (shoot_cooldown > 0) shoot_cooldown--;

for (var i = 0; i < array_length(self.inv); i++) {
    self.inv[i].step();
}
// obj_player - Step Event
var input_dirn_x = 0;
var input_dirn_y = 0;

// WASD input
if (keyboard_check(ord("A"))) input_dirn_x -= 1;
if (keyboard_check(ord("D"))) input_dirn_x += 1;
if (keyboard_check(ord("W"))) input_dirn_y -= 1;
if (keyboard_check(ord("S"))) input_dirn_y += 1;

var magnitude = sqrt(input_dirn_x * input_dirn_x + input_dirn_y * input_dirn_y);
var vel_hori = (magnitude == 0 ? 0 : (input_dirn_x / magnitude)) * move_speed + knockback_x;
var vel_vert = (magnitude == 0 ? 0 : (input_dirn_y / magnitude)) * move_speed + knockback_y;
    
move_and_collide(vel_hori, vel_vert, colliders, undefined, undefined, undefined, move_speed, move_speed);

// Flip sprite based on last direction moved
if (input_dirn_x != 0) {
    var scale = abs(image_xscale);
    image_xscale = (input_dirn_x > 0) ? scale : -scale;
}

// Shoot projectile cooldown tick
if (shoot_cooldown > 0) shoot_cooldown--;
// obj_player - Step Event
var input_dirn_x = 0;
var input_dirn_y = 0;

// WASD input
if (keyboard_check(ord("A"))) input_dirn_x -= 1;
if (keyboard_check(ord("D"))) input_dirn_x += 1;
if (keyboard_check(ord("W"))) input_dirn_y -= 1;
if (keyboard_check(ord("S"))) input_dirn_y += 1;

// If there’s movement input
if (input_dirn_x != 0 || input_dirn_y != 0) {
    // Get direction in degrees
    direction = point_direction(0, 0, input_dirn_x, input_dirn_y);
    // Apply movement speed
    speed = move_speed;
} else {
    speed = 0; // Stop when no keys pressed
}
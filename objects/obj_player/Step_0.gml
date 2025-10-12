update_status_effects(self);

if (hp <= 0) {
    // Player died - make non-persistent and return to main menu
    persistent = false;
    instance_destroy();
    room_goto(MainMenu);
    exit;
}

// Check if stunned - if so, skip movement input
var input_dirn_x = 0;
var input_dirn_y = 0;

if (!variable_instance_exists(self, "is_stunned") || !is_stunned) {
    if (keyboard_check(ord("A"))) input_dirn_x -= 1;
    if (keyboard_check(ord("D"))) input_dirn_x += 1;
    if (keyboard_check(ord("W"))) input_dirn_y -= 1;
    if (keyboard_check(ord("S"))) input_dirn_y += 1;

    var magnitude = sqrt(input_dirn_x * input_dirn_x + input_dirn_y * input_dirn_y);

    // Convert units per second to pixels per frame
    // units/sec * pixels/unit / frames/sec = pixels/frame
    var move_speed_this_frame = (move_speed_ups * global.UNIT_LENGTH) / game_get_speed(gamespeed_fps);

    var vel_hori = (magnitude == 0 ? 0 : (input_dirn_x / magnitude)) * move_speed_this_frame;
    var vel_vert = (magnitude == 0 ? 0 : (input_dirn_y / magnitude)) * move_speed_this_frame;

    move_and_collide(vel_hori, vel_vert, colliders, undefined, undefined, undefined, move_speed_this_frame, move_speed_this_frame);

    if (input_dirn_x != 0) {
        var scale = abs(image_xscale);
        image_xscale = (input_dirn_x > 0) ? scale : -scale;
    }
}

for (var i = 0; i < array_length(self.inv); i++) {
    self.inv[i].step();
}
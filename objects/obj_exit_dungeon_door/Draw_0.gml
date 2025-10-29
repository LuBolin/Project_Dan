// Draw the door if it's on screen
if (is_on_screen) {
    image_xscale = 2;
    image_yscale = 2;
    draw_self()

    draw_set_alpha(1);
    if (to_kill > 0) {
        // Both door and lock have center origins, so just draw at same position
        // Lock sprite is 1280x1280, door is 128x128, so scale lock down by factor of 10
        var lock_scale_x = ( (sprite_width) / sprite_get_width(spr_lock)) / image_xscale;
        var lock_scale_y = ( (sprite_height) / sprite_get_height(spr_lock)) / image_yscale;

        draw_sprite_ext(spr_lock, 0, x, y, lock_scale_x, lock_scale_y, 0, c_white, 1);
    }
}
// Draw arrow indicator if door is off-screen
else {
    // Draw arrow pointing to door location
    // Draw the arrow twice: once in yellow as a background glow, once normally on top
    var arrow_color = make_colour_rgb(255, 255, 0);
    draw_sprite_ext(spr_aim_arrow, 0, arrow_x, arrow_y, 0.75, 0.75, arrow_angle, arrow_color, 0.6);
}

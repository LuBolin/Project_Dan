// Draw the door if it's on screen
if (is_on_screen) {
    image_xscale = 2;
    image_yscale = 2;

    draw_set_alpha(1);
    if (to_kill > 0) {
        draw_sprite_ext(spr_locked_door, 0, x, y, 2, 2, 0, c_white, 1);
    } else {
        draw_self()
    }
}
// Draw arrow indicator if door is off-screen
else {
    // Draw arrow pointing to door location
    // Draw the arrow twice: once in yellow as a background glow, once normally on top
    var arrow_color = make_colour_rgb(255, 255, 0);
    draw_sprite_ext(spr_aim_arrow, 0, arrow_x, arrow_y, 0.75, 0.75, arrow_angle, arrow_color, 0.6);
}

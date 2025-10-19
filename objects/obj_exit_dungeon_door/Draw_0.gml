draw_self()

draw_set_alpha(1);
if (to_kill > 0) {
    
    
    // Both door and lock have center origins, so just draw at same position
    // Lock sprite is 1280x1280, door is 128x128, so scale lock down by factor of 10
    var lock_scale_x = image_xscale * (sprite_width / sprite_get_width(spr_lock));
    var lock_scale_y = image_yscale * (sprite_height / sprite_get_height(spr_lock));

    draw_sprite_ext(spr_lock, 0, x, y, lock_scale_x, lock_scale_y, 0, c_white, 1);
}

// cover-scaled animated backdrop behind all GUI
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

if (sprite_exists(spr_alchemy_bg_anim)) {
    var sw = sprite_get_width(spr_alchemy_bg_anim);
    var sh = sprite_get_height(spr_alchemy_bg_anim);

    var scale = max(gui_w / sw, gui_h / sh);

    // Draw at center of screen (sprite origin is already center)
    var draw_x = gui_w * 0.5;
    var draw_y = gui_h * 0.5;

    var subimg = floor(backdrop_frame);
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_sprite_ext(spr_alchemy_bg_anim, subimg, draw_x, draw_y, scale, scale, 0, c_white, 1);

    // darken backdrop only
    draw_set_color(c_black);
    draw_set_alpha(clamp(backdrop_darken_alpha, 0, 1));
    draw_rectangle(0, 0, gui_w, gui_h, false);
    draw_set_alpha(1);
}
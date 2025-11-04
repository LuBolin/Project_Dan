// cover-scaled animated backdrop behind all GUI
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

if (sprite_exists(spr_alchemy_crafting_backdrop)) {
    var sw = sprite_get_width(spr_alchemy_crafting_backdrop);
    var sh = sprite_get_height(spr_alchemy_crafting_backdrop);

    var scale = max(gui_w / sw, gui_h / sh);
    var draw_w = sw * scale;
    var draw_h = sh * scale;
    var draw_x = (gui_w - draw_w) * 0.5;
    var draw_y = (gui_h - draw_h) * 0.5;

    var subimg = floor(backdrop_frame);
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_sprite_ext(spr_alchemy_crafting_backdrop, subimg, draw_x, draw_y, scale, scale, 0, c_white, 1);

    // darken backdrop only
    draw_set_color(c_black);
    draw_set_alpha(clamp(backdrop_darken_alpha, 0, 1));
    draw_rectangle(0, 0, gui_w, gui_h, false);
    draw_set_alpha(1);
}
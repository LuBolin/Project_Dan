image_xscale = sign(image_xscale);
image_yscale = 1;
draw_self()

var sw = max(1, sprite_get_width(spr_gourd_icon));
var sh = max(1, sprite_get_height(spr_gourd_icon));
var scale = 20 / max(sw, sh); // keep aspect

// draw tinted icon
draw_set_alpha(1);
var gourd_color = (is_struct(inv[sel_slot]) && variable_struct_exists(inv[sel_slot], "color")) ? inv[sel_slot].color : c_white;
draw_sprite_ext(spr_gourd_icon, 0, x - 10 * image_xscale, y + 20, scale, scale, 0, gourd_color, 1);

// Debug: Draw collision shape
if (global.debug_draw_collisions) {
    draw_set_color(c_red);
    draw_ellipse(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
    draw_set_color(c_white);
}
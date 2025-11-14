image_xscale = sign(image_xscale);
image_yscale = 1;
draw_self()

var sw = max(1, sprite_get_width(spr_gourd_icon));
var sh = max(1, sprite_get_height(spr_gourd_icon));
var scale = 20 / max(sw, sh); // keep aspect

// draw tinted icon
draw_set_alpha(1);
var gourd_color = (is_struct(inv[sel_slot]) && variable_struct_exists(inv[sel_slot], "color")) ? inv[sel_slot].color : c_white;
// Always draw gourd on the left side (bottom left) regardless of facing direction
draw_sprite_ext(spr_gourd_icon, 0, x - 10, y + 20, scale, scale, 0, gourd_color, 1);

// Debug: Draw collision shape
if (global.debug_draw_collisions) {
    draw_set_color(c_red);
    draw_ellipse(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
    draw_set_color(c_white);
}

// For drawing sprite effects if and when we have them (like a fire for BurnEffect)
if (!is_undefined(effect_sprite)) {
    var frame = 0;
    if (sprite_exists(effect_sprite) && !is_undefined(effect_sprite_frame)) {
        frame = floor(effect_sprite_frame) mod sprite_get_number(effect_sprite);
    }
    // Target width ~25px → scale based on current sprite width (32px → ~0.78)
    var eff_w = max(1, sprite_get_width(effect_sprite));
    var eff_scale = 25 / eff_w;
    draw_sprite_ext(effect_sprite, frame, x, y + 20, eff_scale, eff_scale, 0, c_white, 1);
}

// Draw status effects above player head
if (array_length(status_texts) > 0) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_font(-1); // Use default font

    // Position above player sprite
    var status_x = x;
    var status_y = y - sprite_height / 2 - 10; // Above player head

    // Draw each status text
    for (var i = 0; i < array_length(status_texts); i++) {
        var text = status_texts[i];

        // Draw text shadow for readability
        draw_set_color(c_black);
        draw_text(status_x + 1, status_y - (i * 12) + 1, text);

        // Draw text in golden color for player status effects
        draw_set_color(c_yellow);
        draw_text(status_x, status_y - (i * 12), text);
    }

    // Reset draw settings
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
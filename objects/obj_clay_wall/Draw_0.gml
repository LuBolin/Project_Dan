// Draw the wall sprite with fade effect
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, alpha);

// Debug: Draw collision shape if enabled
if (global.debug_draw_collisions) {
    draw_set_color(c_orange);
    draw_set_alpha(alpha * 0.3);

    // Get sprite collision mask dimensions from sprite asset
    // spr_clay_wall has bbox: left:53, right:73, top:49, bottom:111
    var mask_left = 53;
    var mask_right = 73;
    var mask_top = 49;
    var mask_bottom = 111;

    // Get sprite origin
    var origin_x = sprite_get_xoffset(sprite_index);
    var origin_y = sprite_get_yoffset(sprite_index);

    // Calculate corners relative to origin
    var left_offset = (mask_left - origin_x) * image_xscale;
    var right_offset = (mask_right - origin_x) * image_xscale;
    var top_offset = (mask_top - origin_y) * image_yscale;
    var bottom_offset = (mask_bottom - origin_y) * image_yscale;

    // Rotate the four corners using lengthdir for correct GameMaker rotation
    // Top-left
    var tl_dist = point_distance(0, 0, left_offset, top_offset);
    var tl_angle = point_direction(0, 0, left_offset, top_offset);
    var tl_x = x + lengthdir_x(tl_dist, tl_angle + image_angle);
    var tl_y = y + lengthdir_y(tl_dist, tl_angle + image_angle);

    // Top-right
    var tr_dist = point_distance(0, 0, right_offset, top_offset);
    var tr_angle = point_direction(0, 0, right_offset, top_offset);
    var tr_x = x + lengthdir_x(tr_dist, tr_angle + image_angle);
    var tr_y = y + lengthdir_y(tr_dist, tr_angle + image_angle);

    // Bottom-right
    var br_dist = point_distance(0, 0, right_offset, bottom_offset);
    var br_angle = point_direction(0, 0, right_offset, bottom_offset);
    var br_x = x + lengthdir_x(br_dist, br_angle + image_angle);
    var br_y = y + lengthdir_y(br_dist, br_angle + image_angle);

    // Bottom-left
    var bl_dist = point_distance(0, 0, left_offset, bottom_offset);
    var bl_angle = point_direction(0, 0, left_offset, bottom_offset);
    var bl_x = x + lengthdir_x(bl_dist, bl_angle + image_angle);
    var bl_y = y + lengthdir_y(bl_dist, bl_angle + image_angle);

    // Draw filled rotated rectangle
    draw_triangle(tl_x, tl_y, tr_x, tr_y, br_x, br_y, false);
    draw_triangle(tl_x, tl_y, br_x, br_y, bl_x, bl_y, false);

    draw_set_alpha(1);
    draw_set_color(c_orange);

    // Draw outline
    draw_line_width(tl_x, tl_y, tr_x, tr_y, 2);
    draw_line_width(tr_x, tr_y, br_x, br_y, 2);
    draw_line_width(br_x, br_y, bl_x, bl_y, 2);
    draw_line_width(bl_x, bl_y, tl_x, tl_y, 2);

    draw_set_color(c_white);
}
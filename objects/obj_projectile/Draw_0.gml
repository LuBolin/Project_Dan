if (!hide_self) {
    draw_self();
}


// Call on_draw callback if it exists
if (variable_struct_exists(proj_data, "on_draw")) {
    proj_data.on_draw(self);
}


// Debug: Draw collision shape
if (global.debug_draw_collisions) {
    draw_set_color(c_red);
    draw_ellipse(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
    draw_set_color(c_white);
}

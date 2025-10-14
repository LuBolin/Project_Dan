draw_self()    
// use gourd's color if present
    //if (is_struct(g) && !is_undefined(g.color)) {
        //node_col = g.color;
    //}

// compute scale for target pixel size
var sw = max(1, sprite_get_width(spr_gourd_icon));
var sh = max(1, sprite_get_height(spr_gourd_icon));
var scale = 20 / max(sw, sh); // keep aspect

// draw tinted icon
draw_set_alpha(1);
draw_sprite_ext(spr_gourd_icon, 0, x - 10 * image_xscale, y + 20, scale, scale, 0, inv[sel_slot].color , 1);
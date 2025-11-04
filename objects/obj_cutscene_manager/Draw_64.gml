draw_set_alpha(0.5);
draw_set_color(c_black);
draw_rectangle(0, 0, gui_width, gui_height, false);
draw_set_alpha(1);

if (show_lightning) {
    draw_set_alpha(lightning_alpha * 0.7);
    draw_set_color(c_white);
    draw_rectangle(0, 0, gui_width, gui_height, false);
    draw_set_alpha(1);
    
    if (sprite_exists(spr_lightning_strike)) {
        var lightning_scale = min(gui_width / sprite_get_width(spr_lightning_strike), 
                                 gui_height / sprite_get_height(spr_lightning_strike)) * 1.2;
        var lightning_x = gui_width / 2;
        var lightning_y = gui_height / 2;
        
        var anim_speed = 0.3;
        var frame = floor((lightning_timer * anim_speed) % sprite_get_number(spr_lightning_strike));
        
        draw_sprite_ext(spr_lightning_strike, frame, lightning_x, lightning_y, 
                       lightning_scale, lightning_scale, 0, c_white, lightning_alpha);
    }
}

draw_set_alpha(0.95);
draw_set_color(col_dialog_bg);
draw_rectangle(0, dialog_box_y, gui_width, gui_height, false);
draw_set_alpha(1);

draw_set_color(col_dialog_border);
draw_rectangle(0, dialog_box_y, gui_width, gui_height, true);
draw_line_width(0, dialog_box_y, gui_width, dialog_box_y, 3);

if (speaker_portraits[current_line] != noone) {
    draw_set_color(make_color_rgb(30, 25, 20));
    draw_rectangle(portrait_x - 5, portrait_y - 5, 
                  portrait_x + portrait_size + 5, portrait_y + portrait_size + 5, false);
    
    draw_set_color(col_dialog_border);
    draw_rectangle(portrait_x - 5, portrait_y - 5, 
                  portrait_x + portrait_size + 5, portrait_y + portrait_size + 5, true);
    
    if (sprite_exists(speaker_portraits[current_line])) {
        var sprite_w = sprite_get_width(speaker_portraits[current_line]);
        var sprite_h = sprite_get_height(speaker_portraits[current_line]);
        var scale = min(portrait_size / sprite_w, portrait_size / sprite_h) * 0.9;
        
        var portrait_blend = speaker_portrait_darkened[current_line] ? make_color_rgb(80, 80, 100) : c_white;
        
        draw_sprite_ext(speaker_portraits[current_line], 0,
                       portrait_x + portrait_size / 2,
                       portrait_y + portrait_size / 2,
                       scale, scale, 0, portrait_blend, 1);
    }
}

if (speaker_names[current_line] != "") {
    draw_set_color(col_name_plate_bg);
    draw_rectangle(portrait_x, name_plate_y, 
                  portrait_x + portrait_size, name_plate_y + name_plate_height, false);
    
    draw_set_color(col_dialog_border);
    draw_rectangle(portrait_x, name_plate_y, 
                  portrait_x + portrait_size, name_plate_y + name_plate_height, true);
    
    draw_set_color(col_name);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(portrait_x + portrait_size / 2, 
                         name_plate_y + name_plate_height / 2,
                         speaker_names[current_line], 1, 1, 0);
}

draw_set_color(col_text);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text_ext(dialog_text_x, dialog_text_y, 
             dialog_lines[current_line], 24, dialog_text_width);

if (waiting_for_click) {
    var prompt_text = "Click or press SPACE to continue...";
    var prompt_x = gui_width - 40;
    var prompt_y = gui_height - 30;
    
    var blink_alpha = 0.5 + sin(current_time / 300) * 0.5;
    draw_set_alpha(blink_alpha);
    draw_set_halign(fa_right);
    draw_set_valign(fa_bottom);
    draw_text(prompt_x, prompt_y, prompt_text);
    draw_set_alpha(1);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
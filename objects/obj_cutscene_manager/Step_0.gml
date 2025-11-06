if (show_lightning) {
    lightning_timer++;
    
    if (lightning_timer <= 10) {
        lightning_alpha = lightning_timer / 10;
    } else if (lightning_timer >= lightning_duration - 10) {
        lightning_alpha = (lightning_duration - lightning_timer) / 10;
    } else {
        lightning_alpha = 1;
    }
    
    if (lightning_timer >= lightning_duration) {
        show_lightning = false;
        lightning_alpha = 0;
    }
}

// Pause run timer during cutscene
if (instance_exists(obj_run_timer)) {
    obj_run_timer.is_active = false;
}

if (waiting_for_click) {
    if (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_space)) {
        advance_dialog();
        mouse_clear(mb_left);
        keyboard_clear(vk_space);
    }
}

if (keyboard_check_pressed(vk_escape)) {
    keyboard_clear(vk_escape);
}

if (instance_exists(obj_player)) {
    var p = obj_player;
    player_snapshot = {
        sprite: p.sprite_index,
        image_index: p.image_index,
        image_xscale: p.image_xscale,
        image_yscale: p.image_yscale,
        image_angle: p.image_angle,
        image_blend: p.image_blend,
        image_alpha: p.image_alpha,
        x: p.x,
        y: p.y
    };

    if (array_length(p.inv) >= 3) {
        player_inventory_snapshot = [p.inv[0], p.inv[1], p.inv[2]];
    }

    if (array_length(p.inv) > p.sel_slot) {
        var active_gourd = p.inv[p.sel_slot];
        if (is_struct(active_gourd) && variable_struct_exists(active_gourd, "color")) {
            player_active_gourd_color = active_gourd.color;
        }
    }
}
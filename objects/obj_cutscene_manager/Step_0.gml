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
gui_width = display_get_gui_width();
gui_height = display_get_gui_height();

dialog_box_height = 180;
dialog_box_y = gui_height - dialog_box_height;

portrait_size = 140;
portrait_x = 40;
portrait_y = dialog_box_y + 20;

name_plate_height = 35;
name_plate_y = portrait_y - name_plate_height - 5;

dialog_text_x = portrait_x + portrait_size + 40;
dialog_text_y = dialog_box_y + 40;
dialog_text_width = gui_width - dialog_text_x - 40;

col_dialog_bg = make_color_rgb(20, 20, 30);
col_dialog_border = make_color_rgb(150, 120, 90);
col_name_plate_bg = make_color_rgb(40, 30, 25);
col_text = c_white;
col_name = make_color_rgb(255, 215, 150);

cutscene_type = "miniboss_defeat";
current_line = 0;
dialog_lines = [];
speaker_names = [];
speaker_portraits = [];
speaker_portrait_darkened = [];

show_lightning = false;
lightning_timer = 0;
lightning_duration = 90;
lightning_alpha = 0;

cutscene_complete = false;
waiting_for_click = true;
has_elixir = false;

game_was_paused = false;
if (instance_exists(obj_pause_menu)) {
    game_was_paused = obj_pause_menu.is_paused;
}

instance_deactivate_all(true);
instance_activate_object(obj_cutscene_manager);
if (instance_exists(obj_player)) {
    instance_activate_object(obj_player);
}
if (instance_exists(obj_camera)) {
    instance_activate_object(obj_camera);
}

setup_miniboss_defeat_cutscene(self);

advance_dialog = function() {
    if (current_line < array_length(dialog_lines) - 1) {
        current_line++;
        waiting_for_click = true;
        
        if (current_line == 2) {
            check_player_has_elixir(self);
        }
    } else {
        complete_cutscene(self);
    }
}
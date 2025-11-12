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

// icon sprite to draw near the player during cutscene
player_icon_sprite = spr_gourd;

player_instance = instance_exists(obj_player) ? obj_player : noone;
player_snapshot = undefined;
player_inventory_snapshot = [];
player_active_gourd_color = c_white;

if (player_instance != noone) {
    player_snapshot = {
        sprite: player_instance.sprite_index,
        image_index: player_instance.image_index,
        image_xscale: player_instance.image_xscale,
        image_yscale: player_instance.image_yscale,
        image_angle: player_instance.image_angle,
        image_blend: player_instance.image_blend,
        image_alpha: player_instance.image_alpha,
        x: player_instance.x,
        y: player_instance.y
    };

    if (array_length(player_instance.inv) >= 3) {
        player_inventory_snapshot = [player_instance.inv[0], player_instance.inv[1], player_instance.inv[2]];
    }

    if (array_length(player_instance.inv) > player_instance.sel_slot) {
        var active_gourd = player_instance.inv[player_instance.sel_slot];
        if (is_struct(active_gourd) && variable_struct_exists(active_gourd, "color")) {
            player_active_gourd_color = active_gourd.color;
        }
    }
}

cutscene_type = "miniboss_defeat";
current_line = 0;
dialog_lines = [];
speaker_names = [];
speaker_portraits = [];
speaker_portrait_darkened = [];

// populate immediately to avoid empty access in first Draw
setup_miniboss_defeat_cutscene(self);
check_player_has_elixir(self);
// ensure current_line valid after population
current_line = clamp(current_line, 0, max(0, array_length(dialog_lines) - 1));

// Tune so whole anim lasts about desired_seconds
var desired_seconds = 2.0;
var frames = sprite_exists(player_cutscene_sprite) ? sprite_get_number(player_cutscene_sprite) : 1;
player_cutscene_speed = frames > 0 ? (frames / (desired_seconds * game_get_speed(gamespeed_fps))) : 0.1;
// manual override per sprite
if (player_cutscene_sprite == spr_character_lightning_death)  player_cutscene_speed = 0.10;
if (player_cutscene_sprite == spr_character_lightning_survive) player_cutscene_speed = 0.12;

show_lightning = false;
lightning_timer = 0;
lightning_duration = 90;
lightning_alpha = 0;

cutscene_complete = false;
waiting_for_click = true;
has_elixir = false;

global.cutscene_active = true;

game_was_paused = false;
if (instance_exists(obj_pause_menu)) {
    game_was_paused = obj_pause_menu.is_paused;
}

original_camera_follow = noone;
original_camera_preferred_ratio = 0.2;

if (instance_exists(obj_camera)) {
    original_camera_follow = obj_camera.follow;
    original_camera_preferred_ratio = obj_camera.preferred_ratio;
    
    if (instance_exists(obj_player)) {
        obj_camera.follow = obj_player;
        obj_camera.preferred_ratio = 0.3;
    }
}

// List of objects that must remain active
var keep_active = [
    obj_cutscene_manager,
    obj_camera,
    obj_aim_arrow,
    obj_sfx_manager,
    obj_run_timer
];

// Deactivate everything except persistent instances
instance_deactivate_all(true);
for (var i = 0; i < array_length(keep_active); i++) {
    if (instance_exists(keep_active[i])) {
        instance_activate_object(keep_active[i]);
    }
}

// Deactivate HUD / boss overlays to prevent overlap (safe lookups)
var _obj_level_hud = asset_get_index("obj_level_hud");
if (_obj_level_hud != -1 && instance_exists(_obj_level_hud)) {
    instance_deactivate_object(_obj_level_hud);
}

var _obj_boss_hud = asset_get_index("obj_boss_hud");
if (_obj_boss_hud != -1 && instance_exists(_obj_boss_hud)) {
    instance_deactivate_object(_obj_boss_hud);
}

// Reactivate tile layers
var tilemap = layer_tilemap_get_id("Tile_Collision");
if (tilemap != -1) {
    instance_activate_layer(layer_get_id("Tile_Collision"));
}

var tiles_layer = layer_get_id("Tiles");
if (tiles_layer != -1) {
    instance_activate_layer(tiles_layer);
}

var background_layer = layer_get_id("Background");
if (background_layer != -1) {
    instance_activate_layer(background_layer);
}

advance_dialog = function() {
    if (current_line < array_length(dialog_lines) - 1) {
        current_line++;
        current_line = clamp(current_line, 0, max(0, array_length(dialog_lines) - 1));
        waiting_for_click = true;

        // Trigger elixir check when reaching line 2
        if (current_line == 2) {
            check_player_has_elixir(self);
        }
    } else {
        complete_cutscene(self);
    }
};

// Deactivate player after first snapshot (retain full info)
if (instance_exists(obj_player)) {
    instance_deactivate_object(obj_player);
    saved_player_visible = obj_player.visible;
    obj_player.visible = false;
} else {
    saved_player_visible = true;
}

player_cutscene_sprite_index = 0;
play_player_anim = false;
player_cutscene_speed = 0.12;

// Hide the player while cutscene draws its own animation
saved_player_visible = true;
if (instance_exists(obj_player)) {
    saved_player_visible = obj_player.visible;
    obj_player.visible = false;
}
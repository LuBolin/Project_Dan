/// Victory Controller - Step

state_timer++;

switch (state) {
    case VICTORY_STATE.KILL_ENEMIES:
        // Kill all remaining enemies (except the boss who's already dead)
        with (obj_enemy_abstract) {
            if (object_index != obj_final_boss) {
                instance_destroy();
            }
        }

        // Wait a brief moment before starting ascension
        if (state_timer >= 30) { // 0.5 seconds
            state = VICTORY_STATE.PLAYER_ASCEND;
            state_timer = 0;

            // Set ascend animation
            if (instance_exists(obj_player)) {
                player = obj_player;

                // Store original sprite and blend color
                player_original_sprite = player.sprite_index;
                player_original_blend = player.image_blend;

                // Set ascend sprite with golden tint
                player.sprite_index = spr_character_ascend;
                player.image_index = 0;
                player.image_speed = 0.08; // Play at very slow speed for dramatic effect
                player.image_blend = make_color_rgb(255, 215, 100); // Golden tint
            }

            // Store original camera settings
            if (instance_exists(obj_camera)) {
                camera_original_preferred_ratio = obj_camera.preferred_ratio;
                camera_original_smooth = obj_camera.smooth;
            }
        }
        break;

    case VICTORY_STATE.PLAYER_ASCEND:
        // Smoothly zoom camera in on player
        if (instance_exists(obj_camera)) {
            // Gradually lerp towards the target zoom
            var zoom_speed = 0.02; // Smooth zoom transition speed
            obj_camera.preferred_ratio = lerp(obj_camera.preferred_ratio, camera_zoom_target, zoom_speed);

            // Make camera follow player more tightly during ascension
            obj_camera.smooth = 0.25; // Increase smoothness for tighter follow
        }

        // Keep player in place during animation
        if (instance_exists(obj_player)) {
            // Store player's position to prevent movement
            if (!variable_instance_exists(self, "player_locked_x")) {
                player_locked_x = player.x;
                player_locked_y = player.y;
            }

            // Force player to stay in position
            player.x = player_locked_x;
            player.y = player_locked_y;

            // Check if animation has reached the last frame
            if (player.image_index >= sprite_get_number(spr_character_ascend) - 1) {
                ascend_animation_complete = true;
            }
        }

        // Wait for animation to complete + extra time
        if (ascend_animation_complete && state_timer >= 60) { // 1 second after animation
            state = VICTORY_STATE.NARRATION;
            state_timer = 0;
        }
        break;

    case VICTORY_STATE.NARRATION:
        // Show narration for a bit, then allow input
        if (state_timer >= 60) { // 1 second
            state = VICTORY_STATE.WAITING_INPUT;
            state_timer = 0;
        }
        break;

    case VICTORY_STATE.WAITING_INPUT:
        // Check for button hover and click
        var mx = device_mouse_x_to_gui(0);
        var my = device_mouse_y_to_gui(0);

        button_hover = point_in_rectangle(mx, my, button_x, button_y,
            button_x + button_width, button_y + button_height);

        // Check for click or any key press
        if ((button_hover && mouse_check_button_pressed(mb_left)) ||
            keyboard_check_pressed(vk_anykey) ||
            keyboard_check_pressed(vk_space) ||
            keyboard_check_pressed(vk_enter)) {

            // Reset game state for potential new game
            global.level_progress = 1;

            // Reset run timer
            if (instance_exists(obj_run_timer)) {
                obj_run_timer.run_time_seconds = 0;
                obj_run_timer.is_active = false;
            }
            global.run_time_seconds_saved = 0;

            // Clear any carried over elements
            if (variable_global_exists("carried_over_element")) {
                global.carried_over_element = undefined;
            }

            // Reset camera settings before leaving
            if (instance_exists(obj_camera)) {
                obj_camera.preferred_ratio = camera_original_preferred_ratio;
                obj_camera.smooth = camera_original_smooth;
            }

            // Destroy player to prevent it from carrying over to main menu
            if (instance_exists(obj_player)) {
                obj_player.persistent = false;
                instance_destroy(obj_player);
            }

            // Clear mouse button state
            io_clear();

            // Go to main menu
            room_goto(MainMenu);
        }
        break;
}

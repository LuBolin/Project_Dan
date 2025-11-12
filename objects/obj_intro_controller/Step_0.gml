/// Intro Controller - Step

// Skip input
var any_key = keyboard_check_pressed(vk_anykey) || keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter);
var any_click = mouse_check_button_pressed(mb_left) || mouse_check_button_pressed(mb_right) || mouse_check_button_pressed(mb_middle);

if (any_key || any_click) {
    // Jump straight to fade out
    state = INTRO_STATE.FADE_OUT;
    image_speed = 0;
}

// Advance logic
switch (state) {
    case INTRO_STATE.SHOW_TEXT:
        // Keep idle looping
        current_sprite = spr_idle;
        image_speed = idle_speed;

        // Typewriter effect
        var total_len = string_length(narration_text);
        if (visible_chars < total_len) {
            visible_chars_fp += type_chars_per_step;
            visible_chars = clamp(floor(visible_chars_fp), 0, total_len);
        } else {
            // Finished typing; hold for a bit then start anim
            post_text_hold_timer += 1;
            if (post_text_hold_timer >= post_text_hold_seconds * game_get_speed(gamespeed_fps)) {
                // Hide narration, start anim
                state = INTRO_STATE.PLAY_ANIM;
                current_sprite = spr_anim;
                image_index = 0;
                image_speed = 0.25; // anim speed
            }
        }
        break;

    case INTRO_STATE.PLAY_ANIM:
        if (sprite_exists(current_sprite)) {
            var frames = max(1, sprite_get_number(current_sprite));
            if (image_index >= frames - 1) {
                image_index = frames - 1;
                image_speed = 0;
                state = INTRO_STATE.FADE_OUT;
            }
        } else {
            // No sprite? just fade
            state = INTRO_STATE.FADE_OUT;
        }
        break;

    case INTRO_STATE.FADE_OUT:
        fade_alpha += (1.0 / max(1, fade_seconds * game_get_speed(gamespeed_fps)));
        if (fade_alpha >= 1) {
            fade_alpha = 1;
            state = INTRO_STATE.DONE;
        }
        break;

    case INTRO_STATE.DONE:
        if (will_mark_intro_shown) {
            global.intro_shown = true;
        }
        io_clear();
        room_goto(MainMenu);
        break;
}

// Blink prompt timer (used in Draw)
if (!variable_instance_exists(self, "blink_t")) blink_t = 0;
blink_t += 1;
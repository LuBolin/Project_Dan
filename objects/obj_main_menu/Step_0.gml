/// Main Menu Controller - Step Event

// Check if we're still showing the splash (Press any key to continue)
if (!show_buttons || transitioning) {
    // Fade in title
    if (title_alpha < 1) {
        title_alpha += title_fade_speed;
        title_alpha = min(title_alpha, 1);
    }

    // Fade in/out effect for "Press any key" text (only for first launch, not auto-transition)
    if (!auto_transition && !transitioning && title_alpha > 0.5) {
        // First fade in from 0 to 1
        if (prompt_alpha < 1 && prompt_fade_direction == 1) {
            prompt_alpha += prompt_fade_speed;
            if (prompt_alpha >= 1) {
                prompt_alpha = 1;
                prompt_fade_direction = -1; // Start fading out after reaching 1
            }
        }
        // Then fade in/out between 0.3 and 1
        else {
            prompt_alpha += prompt_fade_speed * prompt_fade_direction;

            // Reverse direction at boundaries
            if (prompt_alpha >= 1) {
                prompt_alpha = 1;
                prompt_fade_direction = -1;
            } else if (prompt_alpha <= 0.3) {
                prompt_alpha = 0.3;
                prompt_fade_direction = 1;
            }
        }
    }

    // Auto-transition mode: Start transition after delay when title is visible
    if (auto_transition && !transitioning && title_alpha >= 1) {
        auto_transition_delay--;
        if (auto_transition_delay <= 0) {
            transitioning = true;
        }
    }

    // Check for ANY input to start transition (manual mode only)
    if (!auto_transition && !transitioning) {
        var any_key_pressed = false;
        var mouse_clicked = false;
        
        // Check for any keyboard input
        if (keyboard_check_pressed(vk_anykey)) {
            any_key_pressed = true;
        }
        
        // Check for mouse clicks
        if (mouse_check_button_pressed(mb_left) || mouse_check_button_pressed(mb_right) || mouse_check_button_pressed(mb_middle)) {
            mouse_clicked = true;
        }
        
        // Start transition if any input detected
        if (any_key_pressed || mouse_clicked) {
            transitioning = true;
            // Clear the input to prevent it from affecting menu buttons
            keyboard_clear(vk_anykey);
            mouse_clear(mb_left);
            mouse_clear(mb_right);
            mouse_clear(mb_middle);
        }
    }

    // Handle transition animation
    if (transitioning) {
        // Fade out prompt quickly (if it was visible)
        if (prompt_alpha > 0) {
            prompt_alpha -= 0.05;
            prompt_alpha = max(prompt_alpha, 0);
        }

        // Move title upwards smoothly
        title_y_current = lerp(title_y_current, title_y_target, 0.08);

        // Fade in buttons
        buttons_alpha += 0.02;
        buttons_alpha = min(buttons_alpha, 1);

        // Once animation is complete, show buttons fully
        if (buttons_alpha >= 1 && abs(title_y_current - title_y_target) < 1) {
            show_buttons = true;
            transitioning = false;
        }
    }

    // Exit early - don't process button logic during splash/transition
    if (!show_buttons) {
        return;
    }
}

// Get mouse position in GUI coordinates
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Check for button hover
hovered_button = -1;
for (var i = 0; i < array_length(buttons); i++) {
    var btn = buttons[i];
    var btn_w = btn.width;
    var btn_h = btn.height;
    var btn_x = center_x + btn.x_offset - btn_w / 2;
    var btn_y = center_y + btn.y_offset - btn_h / 2;

    if (point_in_rectangle(mx, my, btn_x, btn_y, btn_x + btn_w, btn_y + btn_h)) {
        hovered_button = i;

        // Check for click
        if (mouse_check_button_pressed(mb_left)) {
            btn.action();
            mouse_clear(mb_left);
        }
        break;
    }
}

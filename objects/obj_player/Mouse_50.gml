// Full-auto shooting, if want Semi-auto use left pressed
self.equipped_element.use(id);

// Trigger attack animation
if (!is_attacking) {
    is_attacking = true;
    attack_frame = 0;

    // Update facing direction based on mouse position
    var mouse_dir_x = mouse_x - x;
    var mouse_dir_y = mouse_y - y;

    if (abs(mouse_dir_y) > abs(mouse_dir_x)) {
        // Vertical direction is stronger
        facing_direction = (mouse_dir_y < 0) ? "up" : "down";
    } else {
        // Horizontal direction
        facing_direction = (mouse_dir_x < 0) ? "left" : "right";
    }
}
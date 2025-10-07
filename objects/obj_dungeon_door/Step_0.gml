/// Dungeon Door - Step

// Handle entry door fade-out
if (door_type == "entry" && should_fade) {
    fade_timer++;

    // Fade out over time
    image_alpha = 1 - (fade_timer / fade_duration);

    // Destroy door when fully faded
    if (fade_timer >= fade_duration) {
        instance_destroy();
    }
}

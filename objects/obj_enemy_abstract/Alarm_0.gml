is_player_detected = false
state = "roam"

// Absolutely Basic Roam Behaviour
target_x = random_range(xstart - 100, xstart + 100)
target_y = random_range(ystart - 100, ystart + 100)

alarm[0] = game_get_speed(gamespeed_fps)
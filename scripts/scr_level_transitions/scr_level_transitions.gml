/// Level Transition Functions
/// Use these to transition between rooms with difficulty levels

function goto_level(target_room, difficulty_level) {
    /// @desc Go to a level room with a specific difficulty (1-5)
    /// @param target_room The room to go to
    /// @param difficulty_level The difficulty level (1-5)

    // Set the global difficulty level
    global.current_level_difficulty = clamp(difficulty_level, 1, 5);

    // Save previous room for return
    global.previous_room = room;

    // Go to the room
    room_goto(target_room);

    show_debug_message("Transitioning to " + room_get_name(target_room) + " at difficulty " + string(global.current_level_difficulty));
}

function get_current_difficulty() {
    /// @desc Get the current level difficulty
    /// @return The current difficulty level (1-5)

    if (!variable_global_exists("current_level_difficulty")) {
        global.current_level_difficulty = 1;
    }

    return global.current_level_difficulty;
}

function increase_difficulty() {
    /// @desc Increase difficulty by 1 (max 5)
    /// @return The new difficulty level

    if (!variable_global_exists("current_level_difficulty")) {
        global.current_level_difficulty = 1;
    }

    global.current_level_difficulty = min(global.current_level_difficulty + 1, 5);

    return global.current_level_difficulty;
}

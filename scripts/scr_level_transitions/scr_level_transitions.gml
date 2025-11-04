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
    /// @desc Get thcurr_level_e current level difficulty
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

function get_random_level() {
    /// @desc Returns a random level room (Level1, Level2, or Level3)
    /// @return A random Level room

    //var levels = [Level1, Level2, Level3];
    //var random_index = irandom(array_length(levels) - 1);
    
    // Levels are shuffled
    var level = global.level_order[(global.level_progress - 1) % array_length(global.level_order)];
    return level;
}

function get_random_miniboss_level() {
    /// @desc Returns a random miniboss room (MiniBoss1, MiniBoss2, or MiniBoss3)
    /// @return A random MiniBoss room

    // TODO change this back when we implement a third boss
    // var levels = [MiniBoss_Tree, MiniBoss_Boar, MiniBoss3];
    var levels = [MiniBoss_Tree, MiniBoss_Boar];
    var random_index = irandom(array_length(levels) - 1);
    return levels[random_index];
}

function advance_level_progress() {
    /// @desc Advances to the next level after exiting AlchemyRoom
    /// Increases level_progress and picks next level or returns to menu

    // Initialize level progress if it doesn't exist
    if (!variable_global_exists("level_progress")) {
        global.level_progress = 1;
    }
    
    if (global.level_progress == 1) {
        // Ensures that we do not face repeat levels back-to-back
        global.level_order = array_shuffle([Level1, Level2, Level3]);
    }

    // Increment level progress
    global.level_progress++;

    // Check if we've completed 5 levels
    if (global.level_progress > 5) {
        // Return to main menu
        show_debug_message("Completed 5 levels! Returning to main menu.");
        room_goto(MainMenu);
    } else {
        // Choose the appropriate room based on level
        var next_level;
        if (global.level_progress == 5) {
            // Level 5 uses miniboss rooms
            next_level = get_random_miniboss_level();
            show_debug_message("Advancing to MINIBOSS level " + string(global.level_progress));
        } else {
            // Levels 1-4 use regular level rooms
            next_level = get_random_level();
        }

        var difficulty = global.level_progress;
        goto_level(next_level, difficulty);
        show_debug_message("Advancing to level " + string(global.level_progress) + " (difficulty " + string(difficulty) + ")");
    }
}

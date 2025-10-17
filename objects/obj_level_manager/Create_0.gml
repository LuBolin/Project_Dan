// Track all enemies and kills
total_enemies = 0;
current_kills = 0;
required_kills = 0;
kill_percentage = 0.1; // 10% requirement

// Level difficulty (1-5) - can be set by entering room
if (!variable_global_exists("current_level_difficulty")) {
    global.current_level_difficulty = 1; // Default to level 1
}

// Count enemies at start
enemy_count_complete = false;

// Define spawn function
function spawn_enemies_from_points() {
    /// @desc Spawns enemies at spawn points based on current difficulty

    var difficulty = global.current_level_difficulty;

    // Get all spawn points in the room
    var spawn_points = [];
    with (obj_enemy_spawn_point) {
        array_push(spawn_points, id);
    }

    // If no spawn points, exit
    if (array_length(spawn_points) == 0) {
        show_debug_message("Warning: No spawn points found in room!");
        return;
    }

    // Get level configuration
    var level_config = get_level_config(difficulty);
    var stat_multipliers = get_enemy_stat_multiplier(difficulty);

    // Calculate how many spawn points to use
    var total_spawn_points = array_length(spawn_points);
    var enemy_count = ceil(total_spawn_points * level_config.spawn_percentage);

    // Build weighted enemy list based on difficulty ratios
    var enemy_list = [];
    var allowed_enemies = level_config.allowed_enemies;
    var ratio = level_config.difficulty_ratio;

    // Categorize allowed enemies by difficulty
    var easy_enemies = [];
    var medium_enemies = [];
    var hard_enemies = [];

    for (var j = 0; j < array_length(allowed_enemies); j++) {
        var enemy = allowed_enemies[j];
        var enemy_diff = get_enemy_difficulty(enemy);

        if (enemy_diff == ENEMY_DIFFICULTY.EASY) {
            array_push(easy_enemies, enemy);
        } else if (enemy_diff == ENEMY_DIFFICULTY.MEDIUM) {
            array_push(medium_enemies, enemy);
        } else if (enemy_diff == ENEMY_DIFFICULTY.HARD) {
            array_push(hard_enemies, enemy);
        }
    }

    // Build distribution based on ratios
    var total_ratio = ratio.easy + ratio.medium + ratio.hard;
    var easy_count = round((enemy_count * ratio.easy) / total_ratio);
    var medium_count = round((enemy_count * ratio.medium) / total_ratio);
    var hard_count = enemy_count - easy_count - medium_count; // Remainder goes to hard

    // Add enemies to list based on distribution
    for (var j = 0; j < easy_count; j++) {
        if (array_length(easy_enemies) > 0) {
            array_push(enemy_list, easy_enemies[irandom(array_length(easy_enemies) - 1)]);
        }
    }
    for (var j = 0; j < medium_count; j++) {
        if (array_length(medium_enemies) > 0) {
            array_push(enemy_list, medium_enemies[irandom(array_length(medium_enemies) - 1)]);
        }
    }
    for (var j = 0; j < hard_count; j++) {
        if (array_length(hard_enemies) > 0) {
            array_push(enemy_list, hard_enemies[irandom(array_length(hard_enemies) - 1)]);
        }
    }

    // Shuffle both lists for randomness
    spawn_points = array_shuffle(spawn_points);
    enemy_list = array_shuffle(enemy_list);

    // Spawn enemies
    var spawned = 0;
    var actual_count = min(array_length(enemy_list), enemy_count);
    for (var i = 0; i < actual_count; i++) {
        var spawn_point = spawn_points[i];

        // Get enemy from pre-built list
        var enemy_type = enemy_list[i];

        // Spawn enemy at spawn point
        var enemy = instance_create_depth(spawn_point.x, spawn_point.y, 0, enemy_type);

        // Apply difficulty multipliers and scale
        if (instance_exists(enemy)) {
            enemy.image_xscale = 0.25;  // 256 * 0.25 = 64 pixels
            enemy.image_yscale = 0.25;
            enemy.max_hp *= stat_multipliers.hp_multiplier;
            enemy.hp = enemy.max_hp;
            enemy.base_damage *= stat_multipliers.damage_multiplier;
            enemy.move_speed_ups *= stat_multipliers.speed_multiplier;
            spawned++;
        }

        // Mark spawn point as used
        spawn_point.is_used = true;
    }

    show_debug_message("Spawned " + string(spawned) + " enemies at difficulty level " + string(difficulty));
}

// Call the spawn function now that it's defined
spawn_enemies_from_points();

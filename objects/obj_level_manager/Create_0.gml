// Track all enemies and kills
total_enemies = 0;
current_kills = 0;
required_kills = 0;
kill_percentage = 0.6; // 10% requirement
fox_spawn_prob = 0.4; 
pathfinding_grid = mp_grid_create(0, 0, room_width/32, room_height/32, 32, 32);

mp_grid_add_instances(pathfinding_grid, obj_pathfinding_coll, true)
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
    
    
    // =============== FOX SPAWNING ====================
    var fox_spawn_points = []
    
    with (obj_fox_spawn) {
        show_debug_message("I'm here!");
        array_push(fox_spawn_points, id);
    }
    
    for (var i = 0; i < array_length(fox_spawn_points); i += 1) {
        var prob_roll = random(100) / 100;
        if (prob_roll < fox_spawn_prob) {
                    // Spawn enemy at spawn point
            var spawn = fox_spawn_points[i];
            var fox = instance_create_depth(spawn.x, spawn.y, 0, obj_fox);

            // Apply difficulty multipliers
            if (instance_exists(fox)) {
                fox.max_hp *= stat_multipliers.hp_multiplier;
                fox.hp = fox.max_hp;
                fox.move_speed_ups *= stat_multipliers.speed_multiplier;
            }
            show_debug_message("Fox Spawned!")
            break;
        }
    }
        
    var medium_count = round((enemy_count * ratio.medium) / total_ratio) //- (is_fox_spawned ? 1 : 0);
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

        // Apply difficulty multipliers
        if (instance_exists(enemy)) {
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


function collect_chi() {
    current_kills += 1;
    
    if (instance_exists(obj_exit_dungeon_door)) {
        obj_exit_dungeon_door.update_exit_kills(max(0, required_kills - current_kills));
    }
}

// Call the spawn function now that it's defined
spawn_enemies_from_points();

// Trigger Cutscene
function trigger_miniboss_defeat_cutscene() {
    if (!instance_exists(obj_cutscene_manager)) {
        instance_create_depth(0, 0, -10000, obj_cutscene_manager);
    }
}

var _my_fx_struct = fx_create("_filter_tintfilter");

var possible_colourations = [[0.96, 0.96, 0.86, 0.5], 2, [1, 1, 1, 1]]


if (_my_fx_struct != -1)
{
    fx_set_parameter(_my_fx_struct, "g_TintCol", possible_colourations[(global.current_level_difficulty-1) % array_length(possible_colourations)]);
    layer_set_fx("Tile_Collision", _my_fx_struct);
}


/// Enemy Pools Configuration
/// Defines which enemies can spawn at each difficulty level (1-5)

// Enemy difficulty tags
enum ENEMY_DIFFICULTY {
    EASY,
    MEDIUM,
    HARD
}

// Map enemies to their difficulty
global.enemy_difficulty_map = {
    zombie: ENEMY_DIFFICULTY.EASY,
    boar: ENEMY_DIFFICULTY.MEDIUM,
    ghost: ENEMY_DIFFICULTY.HARD
}

function get_level_config(level_difficulty) {
    /// @desc Returns configuration for a difficulty level
    /// @param level_difficulty The difficulty level (1-5)
    /// @return Struct with spawn_percentage, allowed_enemies, and difficulty_ratio

    level_difficulty = clamp(level_difficulty, 1, 5);

    switch(level_difficulty) {
        case 1:
            return {
                spawn_percentage: 0.6,  // 60% of spawn points
                allowed_enemies: [obj_zombie, obj_boar],
                difficulty_ratio: {easy: 3, medium: 2, hard: 0}  // 3:2:0
            };

        case 2:
            return {
                spawn_percentage: 0.7,  // 70% of spawn points
                allowed_enemies: [obj_zombie, obj_boar],
                difficulty_ratio: {easy: 2, medium: 3, hard: 0}  // 2:3:0
            };

        case 3:
            return {
                spawn_percentage: 0.8,  // 80% of spawn points
                allowed_enemies: [obj_boar, obj_ghost],
                difficulty_ratio: {easy: 0, medium: 3, hard: 2}  // 0:3:2
            };

        case 4:
            return {
                spawn_percentage: 0.9,  // 90% of spawn points
                allowed_enemies: [obj_boar, obj_ghost],
                difficulty_ratio: {easy: 0, medium: 2, hard: 3}  // 0:2:3
            };

        case 5:
            return {
                spawn_percentage: 1.0,  // 100% of spawn points
                allowed_enemies: [obj_boar, obj_ghost],
                difficulty_ratio: {easy: 0, medium: 1, hard: 4}  // 0:1:4
            };

        default:
            return {
                spawn_percentage: 0.6,
                allowed_enemies: [obj_zombie, obj_boar],
                difficulty_ratio: {easy: 3, medium: 2, hard: 0}
            };
    }
}

function get_enemy_difficulty(enemy_object) {
    /// @desc Returns the difficulty level of an enemy
    /// @param enemy_object The enemy object to check

    if (enemy_object == obj_zombie) return ENEMY_DIFFICULTY.EASY;
    if (enemy_object == obj_boar) return ENEMY_DIFFICULTY.MEDIUM;
    if (enemy_object == obj_ghost) return ENEMY_DIFFICULTY.HARD;

    return ENEMY_DIFFICULTY.EASY; // Default
}


function get_enemy_stat_multiplier(level_difficulty) {
    /// @desc Returns stat multipliers for enemies based on difficulty
    /// @param level_difficulty The difficulty level (1-5)

    level_difficulty = clamp(level_difficulty, 1, 5);

    // Return struct with HP and damage multipliers
    return {
        hp_multiplier: 1 + (level_difficulty - 1) * 0.3,      // 1.0x to 2.2x HP
        damage_multiplier: 1 + (level_difficulty - 1) * 0.2,   // 1.0x to 1.8x damage
        speed_multiplier: 1 + (level_difficulty - 1) * 0.1     // 1.0x to 1.4x speed
    };
}

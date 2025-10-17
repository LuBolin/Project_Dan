# Level Difficulty System

## Overview
This system allows you to create multiple map rooms and have enemies spawn dynamically based on a difficulty level (1-5).

## How It Works

### 1. Creating a New Level Room
1. Duplicate `TemplateLevel` or `Level0` to create a new room
2. Design your map with collision tiles
3. Place `obj_enemy_spawn_point` objects where you want enemies to potentially spawn
   - The spawn points will appear as red circles in the editor
   - You should place more spawn points than the maximum number of enemies you want
   - The system will randomly select spawn points to use

### 2. Enemy Spawn Points (`obj_enemy_spawn_point`)
- Place these objects in your room to mark spawn locations
- The system will randomly select from available spawn points
- More spawn points = more variety in enemy positions each playthrough
- Spawn points are invisible during gameplay

### 3. Difficulty Levels (1-5)

Each difficulty level determines:
- **Which enemies spawn** (from easier to harder enemy types)
- **How many enemies spawn** (3 to 12 enemies)
- **Enemy stats multipliers** (HP, damage, and speed increase with difficulty)

#### Enemy Pools by Difficulty:
- **Level 1**: Only zombies (3 enemies)
- **Level 2**: Zombies and boars (5 enemies)
- **Level 3**: Mix of zombies, boars, and ghosts (7 enemies)
- **Level 4**: Fewer zombies, more challenging enemies (9 enemies)
- **Level 5**: Hardest mix - mostly boars and ghosts (12 enemies)

#### Stat Multipliers:
- **HP**: 1.0x → 2.2x (increases by 0.3x per level)
- **Damage**: 1.0x → 1.8x (increases by 0.2x per level)
- **Speed**: 1.0x → 1.4x (increases by 0.1x per level)

### 4. Transitioning to Levels

Use the `goto_level()` function to enter a level with a specific difficulty:

```gml
// Go to TemplateLevel at difficulty 3
goto_level(TemplateLevel, 3);

// Go to Level0 at difficulty 1
goto_level(Level0, 1);
```

### 5. Level Progression

You can increase the difficulty between levels:

```gml
// Increase difficulty by 1 (caps at 5)
var new_difficulty = increase_difficulty();
goto_level(next_room, new_difficulty);
```

Or manually set it:

```gml
// Go to next room with specific difficulty
goto_level(Level1, 4);
```

### 6. Getting Current Difficulty

```gml
var current_diff = get_current_difficulty();
```

## Files Created

### Objects:
- **obj_enemy_spawn_point**: Marks enemy spawn locations in rooms

### Scripts:
- **scr_enemy_pools**: Defines enemy types and counts for each difficulty
- **scr_level_transitions**: Functions for transitioning between levels with difficulty

### Modified Files:
- **obj_level_manager/Create_0.gml**: Now spawns enemies from spawn points based on difficulty
- **obj_level_hud/Draw_64.gml**: Displays current difficulty level on HUD
- **obj_main_menu/Create_0.gml**: Uses new transition system to start at difficulty 1

## Customizing Enemy Pools

Edit `scripts/scr_enemy_pools/scr_enemy_pools.gml`:

### Change which enemies spawn:
```gml
case 3:
    // Level 3: Your custom mix
    return [obj_zombie, obj_boar, obj_ghost, obj_custom_enemy];
```

### Change enemy count:
```gml
case 3: return 10; // Spawn 10 enemies at level 3
```

### Adjust stat multipliers:
```gml
return {
    hp_multiplier: 1 + (level_difficulty - 1) * 0.5,      // Make HP scale faster
    damage_multiplier: 1 + (level_difficulty - 1) * 0.3,  // Make damage scale faster
    speed_multiplier: 1 + (level_difficulty - 1) * 0.15   // Make speed scale faster
};
```

## Example Workflow

1. **Design multiple rooms** (Level0, Level1, Level2, etc.)
2. **Place spawn points** in each room
3. **Set up progression** in your exit door or level complete logic:

```gml
// When player completes level
if (level_complete) {
    var next_diff = increase_difficulty();
    goto_level(next_level_room, next_diff);
}
```

4. **Test different difficulties** by changing the starting difficulty in main menu

## Tips

- Place spawn points away from the player's starting position
- Use more spawn points than needed for variety
- Test each difficulty level to ensure proper balance
- The system automatically prevents spawning more enemies than spawn points available

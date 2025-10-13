var _list = ds_list_create();
var _current_enemy;
var _sight_line;

// Gets all enemies within a circle radius of the player
var _num_enemies = collision_circle_list(x, y, detection_radius, obj_enemy_abstract, false, true, _list, false);
if (_num_enemies > 0) {
    for (var i = 0; i < _num_enemies; i += 1) {
        _current_enemy = _list[| i];
        
        // Check if there is line-of-sight between player and enemy
        _sight_line = collision_line(x, y, _current_enemy.x, _current_enemy.y, colliders, false, false)

        if (_sight_line == noone) {

            _current_enemy.player_last_known_x = x;
            _current_enemy.player_last_known_y = y;
            _current_enemy.curr_state.player_interact()
            // Assuming the enemy is still combating the player
            // The current player's last known position should be updated before the alarm resets
            
            _current_enemy.alarm[0] = 15;
        }
    }
}
ds_list_destroy(_list)
alarm[0] = 10
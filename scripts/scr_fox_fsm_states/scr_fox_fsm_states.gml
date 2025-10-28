/// @description FSM States
/// States to be used in Enemy's FSM

function FoxChaseState(_entity, _duration = 3500, _is_timed = true) : State(_entity, _duration, _is_timed) constructor {
    id = STATES.CHASE;
    has_second_chance = true;
    
    on_step = function() {
        with (entity) { 
            var flee_dir = point_direction(obj_player.x, obj_player.y, x, y);
            var _hor = lengthdir_x(1, flee_dir);
            var _vert = lengthdir_y(1, flee_dir);
            
            // Add wall repulsion
            var wall_check_dist = 10;
            for (var a = 0; a < 360; a += 45) {
                var check_x = x + lengthdir_x(wall_check_dist, a);
                var check_y = y + lengthdir_y(wall_check_dist, a);
                if (place_meeting(check_x, check_y, colliders)) {
                    _hor -= lengthdir_x(0.5, a); // Push away from nearby wall
                    _vert -= lengthdir_y(0.5, a);
                }
            } 
            
            move(self, _hor, _vert);
            
            var dist = distance_to_object(obj_player)
            if (dist <= global.UNIT_LENGTH * 2 and other.has_second_chance) {
                other.has_second_chance = false;
                other.remaining_time = max(other.duration * (3/4), other.remaining_time)
            }
            
            image_alpha = other.remaining_time / other.duration;
            
            if (image_alpha < 0.01) {
                instance_destroy(self);
            }
        }
    }
    

}

function move(entity, _hor, _vert) {
    
    with entity {
        var magnitude = sqrt(_hor * _hor + _vert * _vert)
        
        if (magnitude != 0) {
            // Convert units per second to pixels per frame
            // units/sec * pixels/unit / frames/sec = pixels/frame
            var move_speed_this_frame = (move_speed_ups * global.UNIT_LENGTH) / game_get_speed(gamespeed_fps);
        
            var _norm_hor = (_hor / magnitude) * move_speed_this_frame;
            var _norm_vert = (_vert / magnitude) * move_speed_this_frame;
    
            if (place_meeting(x + _norm_hor, y, colliders)) {
        
                // Allows the players to smoothly slide past corners
                if (!place_meeting(x + _norm_hor, y + move_speed_this_frame, colliders)) {
                    y += move_speed_this_frame
                } else if (!place_meeting(x + _norm_hor, y - move_speed_this_frame, colliders)) {
                    y -= move_speed_this_frame
                } else {
                    _norm_hor = 0;   
                }
                
            }
            
            x += _norm_hor;
            
            if (place_meeting(x, y + _norm_vert, colliders)) {
                
                // Allows the players to smoothly slide past corners
                if (!place_meeting(x + move_speed_this_frame, y + _norm_vert , colliders)) {
                    x += move_speed_this_frame
                } else if (!place_meeting(x - move_speed_this_frame, y + _norm_vert, colliders)) {
                    x -= move_speed_this_frame
                } else {
                    _norm_vert = 0;   
                }
            }
            
            y += _norm_vert;
        } 
    }
}


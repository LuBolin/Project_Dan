/// @description FSM States
/// States to be used in Enemy's FSM

function FoxChaseState(_entity, _duration = 60, _is_timed = true) : State(_entity, _duration, _is_timed) constructor {
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


var ang  = point_direction(player.x, player.y, mouse_x, mouse_y);
image_angle = ang;

var r    = player_radius_simple(player);
var gap  = 6; // arbitrary

x = player.x + lengthdir_x(r + gap, ang);
y = player.y + lengthdir_y(r + gap, ang);

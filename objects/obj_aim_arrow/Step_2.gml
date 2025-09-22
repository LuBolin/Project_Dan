var ang  = point_direction(player.x, player.y, mouse_x, mouse_y);
image_angle = ang;

var r    = player_radius_simple(player);
var gap  = 6; // arbitrary

x = player.x + lengthdir_x(r + gap, ang);
y = player.y + lengthdir_y(r + gap, ang);


function player_radius_simple(_p) {
    var pw = sprite_get_width(_p.sprite_index)  * abs(_p.image_xscale);
    var ph = sprite_get_height(_p.sprite_index) * abs(_p.image_yscale);
    return max(pw, ph) * 0.5;
}

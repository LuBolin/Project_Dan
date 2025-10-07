/// @function fire_projectile(_p)
/// @param {Id.Instance} _p The player instance
/// @param {Asset.GMObject} _projectile The type of projectile fired
function shoot_projectile(_p, _projectile) {
    var ang  = point_direction(_p.x, _p.y, mouse_x, mouse_y);
    var r    = player_radius_simple(_p);
    var gap  = 6;

    var sx = _p.x + lengthdir_x(r + gap, ang);
    var sy = _p.y + lengthdir_y(r + gap, ang);

    var b = instance_create_layer(sx, sy, layer, _projectile);
    b.direction   = ang;
    b.image_angle = ang;
    b.creator     = id;
}

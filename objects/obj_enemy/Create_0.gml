target_x = x
target_y = y
chase = false

alarm[0] = 60

colliders = [layer_tilemap_get_id("Tile_Collision"), obj_enemy]

toString = function()
{
    return string("EnemyName={0}, HP={1}, DMG={2} , SPD={3}", object_get_name(object_index), health, damage, mov_speed);
}
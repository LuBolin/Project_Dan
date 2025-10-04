//*Damage Effects*//
// Refer to damage_entity script
// Knockback when hit by an attack
knockback_x  = 0;
knockback_y  = 0;



//*Enemy Chase-related Behaviour*//
// Target X and Y  
target_x     = x;
target_y     = y;

chase        = false;
pause        = false;

alarm[0]     = 1;

colliders    = [layer_tilemap_get_id("Tile_Collision"), obj_enemy_abstract]

toString = function()
{
    return string("EnemyName={0}, HP={1}, DMG={2} , SPD={3}", object_get_name(object_index), health, damage, mov_speed);
}
colliders = [layer_tilemap_get_id("Tile_Collision"), obj_enemy_abstract, obj_clay_wall];

curr_state = states_array[STATES.ATTACK];
curr_state.enter();
pause = false;
function init_player_revives(player){
    // List of objects that must remain active
    var keep_active = [
        obj_camera,
        obj_sfx_manager,
        obj_level_hud,
        obj_run_timer,
    ];
    
    // Deactivate everything except persistent instances
    instance_deactivate_all(true);
    for (var i = 0; i < array_length(keep_active); i++) { 
        instance_activate_object(keep_active[i]);
    }
    
    player.revive_timer = 20
}
    
    //var frames = spr_character_lightning_survive;
    //player.sprite
    //player.player_cutscene_speed = frames > 0 ? (frames / (desired_seconds * room_speed)) : 0.1;

function player_revive_anim(player) {
    // Step
        
    if (player.revive_timer <= 0) {
        // Resume game
        instance_activate_all();
    }
    
    player.revive_timer -= 1;

    
    //// Animate cutscene sprite (non-looping)
    //if (sprite_exists(player_cutscene_sprite)) {
        //var total_frames = sprite_get_number(player_cutscene_sprite);
        //if (player_cutscene_sprite_index < total_frames - 1) {
            //player_cutscene_sprite_index += player.player_cutscene_speed;
            //if (player_cutscene_sprite_index >= total_frames - 1) {
                //player_cutscene_sprite_index = total_frames - 1; // hold on last frame
            //}
        //}
    //}
    

}
function init_player_revives(player){
    // List of objects that must remain active

    with (obj_enemy_abstract) {
        pause = true;
    }
    
    player.revive_timer = 20
    is_pause_for_revive = true;
}
    
    //var frames = spr_character_lightning_survive;
    //player.sprite
    //player.player_cutscene_speed = frames > 0 ? (frames / (desired_seconds * game_get_speed(gamespeed_fps))) : 0.1;

function player_revive_anim(player) {
    // Step
        
    if (player.revive_timer <= 0) {
        // Resume game
        player.hp = player.max_hp;
        is_pause_for_revive = false;
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
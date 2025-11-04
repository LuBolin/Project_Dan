function setup_miniboss_defeat_cutscene(cutscene_manager) {
    var defeated_miniboss_sprite = spr_miniboss_boar;
    
    if (instance_exists(obj_miniboss_tree)) {
        defeated_miniboss_sprite = obj_miniboss_tree.sprite_index;
    } else if (instance_exists(obj_miniboss_boar)) {
        defeated_miniboss_sprite = obj_miniboss_boar.sprite_index;
    }
    
    cutscene_manager.dialog_lines = [
        "How dare you try escape the cycle of reincarnation...",
        "You will not escape retribution!",
        "You have been inflicted with the curse of death.",
        ""
    ];
    
    cutscene_manager.speaker_names = [
        "Cursed Guardian",
        "Cursed Guardian",
        "",
        ""
    ];
    
    cutscene_manager.speaker_portraits = [
        defeated_miniboss_sprite,
        defeated_miniboss_sprite,
        noone,
        noone
    ];
    
    cutscene_manager.speaker_portrait_darkened = [
        false,
        false,
        false,
        false
    ];
}

function check_player_has_elixir(cutscene_manager) {
    var has_elixir = false;
    
    if (instance_exists(obj_player)) {
        for (var i = 0; i < array_length(obj_player.inv); i++) {
            if (obj_player.inv[i].name == "Elixir") {
                has_elixir = true;
                break;
            }
        }
    }
    
    cutscene_manager.show_lightning = true;
    cutscene_manager.lightning_timer = 0;
    
    if (!has_elixir) {
        cutscene_manager.dialog_lines[3] = "You currently do not have the means to survive this curse.\nYou have returned to the cycle of reincarnation.";
        cutscene_manager.speaker_names[3] = "";
        cutscene_manager.speaker_portraits[3] = noone;
        cutscene_manager.speaker_portrait_darkened[3] = false;
        cutscene_manager.has_elixir = false;
    } else {
        var final_boss_sprite = spr_final_boss;
        
        array_resize(cutscene_manager.dialog_lines, 8);
        array_resize(cutscene_manager.speaker_names, 8);
        array_resize(cutscene_manager.speaker_portraits, 8);
        array_resize(cutscene_manager.speaker_portrait_darkened, 8);
        
        cutscene_manager.dialog_lines[3] = "The Elixir fills you with the essence of life.\nYou survive the curse of death!";
        cutscene_manager.speaker_names[3] = "";
        cutscene_manager.speaker_portraits[3] = noone;
        cutscene_manager.speaker_portrait_darkened[3] = false;
        
        cutscene_manager.dialog_lines[4] = "A higher being notices your presence.";
        cutscene_manager.speaker_names[4] = "";
        cutscene_manager.speaker_portraits[4] = noone;
        cutscene_manager.speaker_portrait_darkened[4] = false;
        
        cutscene_manager.dialog_lines[5] = "...";
        cutscene_manager.speaker_names[5] = "Unknown God";
        cutscene_manager.speaker_portraits[5] = final_boss_sprite;
        cutscene_manager.speaker_portrait_darkened[5] = true;
        
        cutscene_manager.dialog_lines[6] = "The road to immortality will not be free.";
        cutscene_manager.speaker_names[6] = "Unknown God";
        cutscene_manager.speaker_portraits[6] = final_boss_sprite;
        cutscene_manager.speaker_portrait_darkened[6] = true;
        
        cutscene_manager.dialog_lines[7] = "Be prepared to face divine punishment!";
        cutscene_manager.speaker_names[7] = "Unknown God";
        cutscene_manager.speaker_portraits[7] = final_boss_sprite;
        cutscene_manager.speaker_portrait_darkened[7] = true;
        
        cutscene_manager.has_elixir = true;
    }
}

function complete_cutscene(cutscene_manager) {
    cutscene_manager.cutscene_complete = true;
    
    if (!cutscene_manager.has_elixir) {
        if (instance_exists(obj_player)) {
            global.player_death_inventory = [obj_player.inv[0], obj_player.inv[1], obj_player.inv[2]];
            obj_player.persistent = false;
            instance_destroy(obj_player);
        }
        
        if (!instance_exists(obj_death_screen)) {
            instance_create_depth(0, 0, -9999, obj_death_screen);
        }
    } else {
        goto_level(Level_FinalBoss, 5);
    }
    
    instance_activate_all();
    instance_destroy(cutscene_manager);
}

function trigger_miniboss_defeat_cutscene() {
    if (!instance_exists(obj_cutscene_manager)) {
        instance_create_depth(0, 0, -10000, obj_cutscene_manager);
    }
}
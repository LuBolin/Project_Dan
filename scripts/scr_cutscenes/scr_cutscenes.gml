function setup_miniboss_defeat_cutscene(cutscene_manager) {
    var defeated_miniboss_sprite = noone;
    
    if (variable_global_exists("defeated_miniboss_sprite")) {
        defeated_miniboss_sprite = global.defeated_miniboss_sprite;
        global.defeated_miniboss_sprite = noone;
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
    var inventory = [];

    if (instance_exists(obj_player)) {
        inventory = [obj_player.inv[0], obj_player.inv[1], obj_player.inv[2]];
    } else if (array_length(cutscene_manager.player_inventory_snapshot) >= 3) {
        inventory = cutscene_manager.player_inventory_snapshot;
    }

    if (array_length(inventory) >= 3) {
        for (var i = 0; i < array_length(inventory); i++) {
            var entry = inventory[i];
            if (is_struct(entry) && entry.name == "Elixir") {
                has_elixir = true;
                break;
            }
        }
        cutscene_manager.player_inventory_snapshot = inventory;
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
        var final_boss_sprite = spr_boss_new;
        
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
        var inventory = [];

        if (instance_exists(obj_player)) {
            inventory = [obj_player.inv[0], obj_player.inv[1], obj_player.inv[2]];
        } else if (array_length(cutscene_manager.player_inventory_snapshot) >= 3) {
            inventory = cutscene_manager.player_inventory_snapshot;
        }

        if (array_length(inventory) >= 3) {
            global.player_death_inventory = inventory;
        }

        if (instance_exists(obj_player)) {
            obj_player.persistent = false;
            instance_destroy(obj_player);
        }

        global.cutscene_complete_flag = true;

        with (cutscene_manager) {
            global.cutscene_active = false;
            instance_destroy();
        }

        if (!instance_exists(obj_death_screen)) {
            var death_screen = instance_create_depth(0, 0, -9999, obj_death_screen);
            death_screen.persistent = true;
        }
    } else {
        // Replace Elixir with Lightning before moving to final boss
        var names = [];
        var sel_idx = 0;

        if (instance_exists(obj_player)) {
            var p = obj_player;
            for (var i = 0; i < array_length(p.inv); i++) {
                var g = p.inv[i];
                if (is_struct(g) && variable_struct_exists(g, "name") && g.name == "Elixir") {
                    p.inv[i] = gourd_create(GourdLightning);
                    if (p.sel_slot == i) {
                        p.equipped_element = p.inv[i];
                    }
                }
                array_push(names, is_struct(p.inv[i]) ? p.inv[i].name : "");
            }
            sel_idx = clamp(p.sel_slot, 0, array_length(p.inv) - 1);
        } else if (array_length(cutscene_manager.player_inventory_snapshot) >= 3) {
            for (var i = 0; i < array_length(cutscene_manager.player_inventory_snapshot); i++) {
                var g2 = cutscene_manager.player_inventory_snapshot[i];
                if (is_struct(g2) && variable_struct_exists(g2, "name") && g2.name == "Elixir") {
                    cutscene_manager.player_inventory_snapshot[i] = gourd_create(GourdLightning);
                }
                array_push(names, is_struct(cutscene_manager.player_inventory_snapshot[i]) ? cutscene_manager.player_inventory_snapshot[i].name : "");
            }
            sel_idx = 0;
        }

        // Persist for next room’s player Create
        global.next_room_inv_names = names;
        global.next_room_sel_slot = sel_idx;

        with (cutscene_manager) {
            global.cutscene_active = false;
            instance_destroy();
        }

        goto_level(Level_FinalBoss, 5);
    }
}

function trigger_miniboss_defeat_cutscene() {
    if (!variable_global_exists("cutscene_active")) {
        global.cutscene_active = false;
    }

    if (global.cutscene_active) {
        return;
    }

    global.cutscene_active = true;

    if (!instance_exists(obj_cutscene_manager)) {
        instance_create_depth(0, 0, -10000, obj_cutscene_manager);
    }
}
/// @function spawn_and_set_projectile(_entity, projectile, target_x, target_y, [projectile_object])
/// @param {Id.Instance} _entity The entity the projectile was fired from
/// @param {Struct} projectile The type of projectile fired
/// @param {Real} target_x Target x position
/// @param {Real} target_y Target y position
/// @param {Asset.GMObject} [projectile_object] Optional: obj_projectile (default) or obj_enemy_projectile
function spawn_and_set_projectile(_entity, projectile, target_x, target_y, projectile_object = obj_projectile) {
    var ang  = point_direction(_entity.x, _entity.y, target_x, target_y);
    
    return spawn_and_set_projectile_angled(_entity, projectile, ang, projectile_object);
}


/// @function spawn_and_set_projectile(_entity, projectile, target_x, target_y, [projectile_object])
/// @param {Id.Instance} _entity The entity the projectile was fired from
/// @param {Struct} projectile The type of projectile fired
/// @param {Real} angle The angle to fire at
/// @param {Asset.GMObject} [projectile_object] Optional: obj_projectile (default) or obj_enemy_projectile
function spawn_and_set_projectile_angled(_entity, projectile, angle, projectile_object = obj_projectile) {
    var r    = player_radius_simple(_entity);
    var gap  = 5;

    var sx = _entity.x + lengthdir_x(r + gap, angle);
    var sy = _entity.y + lengthdir_y(r + gap, angle);

    // Use the specified projectile object (defaults to obj_projectile)
    var inst = instance_create_layer(sx, sy, "Instances", projectile_object);

    if (inst != noone) {
        if (is_struct(projectile)) {
            // Store the projectile struct for behavior callbacks
            inst.proj_data = projectile;

            // Copy properties from projectile struct to instance
            if (!is_undefined(projectile.damage))     inst.damage     = projectile.damage;
            if (!is_undefined(projectile.speed)) {
                // Convert speed from units per second to pixels per frame
                // units/sec * pixels/unit / frames/sec = pixels/frame
                inst.speed = (projectile.speed * global.UNIT_LENGTH) / game_get_speed(gamespeed_fps);
            }
            if (!is_undefined(projectile.life_steps)) inst.life_steps = projectile.life_steps;
            if (!is_undefined(projectile.sprite_index)) inst.sprite_index = projectile.sprite_index;
            if (!is_undefined(projectile.kb_speed)) inst.kb_speed  = projectile.kb_speed;
            if (!is_undefined(projectile.kb_distance)) inst.kb_distance  = projectile.kb_distance;
            if (!is_undefined(projectile.scale)) {
                inst.image_xscale = projectile.scale;
                inst.image_yscale = projectile.scale;
            }

            // SAFER: copy damage target flags with defaults by projectile side
            var default_damage_player  = (projectile_object == obj_enemy_projectile);
            var default_damage_enemies = (projectile_object != obj_enemy_projectile);

            if (is_struct(projectile) && variable_struct_exists(projectile, "damage_player")) {
                inst.damage_player = projectile.damage_player;
            } else {
                inst.damage_player = default_damage_player;
            }

            if (is_struct(projectile) && variable_struct_exists(projectile, "damage_enemies")) {
                inst.damage_enemies = projectile.damage_enemies;
            } else {
                inst.damage_enemies = default_damage_enemies;
            }

            // SFX (guard against missing SFX manager)
            if (is_struct(projectile) && !is_undefined(projectile.sfx_fire)) {
                if (instance_exists(obj_sfx_manager)) with (obj_sfx_manager) play_sound(projectile.sfx_fire, false);
                else audio_play_sound(projectile.sfx_fire, 0, false);
            }

            if (!is_undefined(projectile.sfx_fire)) obj_sfx_manager.play_sound(projectile.sfx_fire, false);
        }
        
        inst.creator = _entity;
        inst.direction = angle;
        inst.image_angle = angle;

        // Call on_launch callback if it exists
        if (is_struct(projectile) && variable_struct_exists(projectile, "on_launch")) {
            projectile.on_launch(inst);
        }
    }
    
    return inst;
}

/// @function get_bullet_spawn(_entity, angle)
/// @param {Id.Instance} _entity The entity the projectile was fired from
/// @param {Real} angle The angle to fire at
function get_bullet_spawn(_entity, angle) {
    var sx = _entity.x + lengthdir_x(r + gap, angle);
    var sy = _entity.y + lengthdir_y(r + gap, angle);
}
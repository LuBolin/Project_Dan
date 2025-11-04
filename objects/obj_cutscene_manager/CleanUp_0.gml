if (instance_exists(obj_camera)) {
    if (original_camera_follow != noone && instance_exists(original_camera_follow)) {
        obj_camera.follow = original_camera_follow;
    }
    obj_camera.preferred_ratio = original_camera_preferred_ratio;
}

if (variable_global_exists("cutscene_active")) {
    global.cutscene_active = false;
}
if (instance_exists(obj_level_manager)) {
    obj_level_manager.collect_chi();
    sfx_play(snd_chi_collect, false)
}
instance_destroy(self);
/// Steam Cloud - Clean Up Event

// Destroy the hit cooldown map
if (ds_exists(hit_cooldown_map, ds_type_map)) {
    ds_map_destroy(hit_cooldown_map);
}
fox_spawn_prob = 0.1;
var prob_roll = random(100) / 100;
if (prob_roll < fox_spawn_prob) {
            // Spawn enemy at spawn point
    var fox = instance_create_depth(x, y, 0, obj_fox);
    show_debug_message("Fox Spawned!")

}
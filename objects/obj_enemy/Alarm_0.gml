if (instance_exists(obj_player) && distance_to_object(obj_player) < distance_to_chase)
{
    // Chase Behaviour
    chase = true
} else {
    // Roam Behaviour
    chase = false
    target_x = random_range(xstart - 100, xstart + 100)
    target_y = random_range(ystart - 100, ystart + 100)
}

alarm[0] = 60
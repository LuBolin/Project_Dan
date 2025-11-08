if (is_telegraphing) {
    telegraph_attack_blink_cd -= delta_time / 1000000;
    if (telegraph_attack_blink_cd <= 0) {
        do_telegraph_show = !do_telegraph_show;
        telegraph_attack_blink_cd = telegraph_attack_blink_freq;
        telegraph_attack_blink_num += 1;
    }
    
    
    // Check if enough blinks have occurred OR total time has elapsed
    if (telegraph_attack_blink_num >= telegraph_total_blinks) {
        // Create lava pool that damages the player
        func_execute_attack();
        instance_destroy();
    }     
}

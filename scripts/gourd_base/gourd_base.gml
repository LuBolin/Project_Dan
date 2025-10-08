function GourdBase() constructor {
    name = "";
	color = c_black;
    
	cooldown = 0;
	cooldown_timer = 0;
	
	projectile = noone;

    can_use = function () {
        return (cooldown_timer <= 0);
    }

    trigger_cd = function () {
        cooldown_timer = cooldown * game_get_speed(gamespeed_fps);
    }

    step = function () {
        if (cooldown_timer > 0) cooldown_timer -= 1;
    }

    use = function(_p) {
        if (can_use()) {
			show_debug_message("GourdBase.use() called - no projectile assigned");
            trigger_cd();
        }
    };
}

function gourd_create(_constructor) {
    return new _constructor();
}

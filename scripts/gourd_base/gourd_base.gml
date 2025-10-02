function GourdBase() constructor {
    name = "";
	color = c_black;
    
	cooldown = 0;
	cooldown_timer = 0;

    can_use = function () {
        return (cd_timer <= 0);
    }

    trigger_cd = function () {
        cd_timer = cooldown;
    }

    step = function () {
        if (cd_timer > 0) cd_timer -= 1;
    }

    // Virtual method — override in children
    use = function (player) {
        show_debug_message("Using " + name);
    }
}

function gourd_create(_constructor) {
    return new _constructor();
}
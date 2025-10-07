function GourdBase() constructor {
    name = "";
	color = c_black;

	cooldown = 0;
	cooldown_timer = 0;

    can_use = function () {
        return (cooldown_timer <= 0);
    }

    trigger_cd = function () {
        cooldown_timer = cooldown * game_get_speed(gamespeed_fps);
    }

    step = function () {
        if (cooldown_timer > 0) cooldown_timer -= 1;
    }

    use = function (player) {
    }
}

function gourd_create(_constructor) {
    return new _constructor();
}
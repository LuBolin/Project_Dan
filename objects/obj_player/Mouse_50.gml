// Full-auto shooting, if want Semi-auto use left pressed
if (shoot_cooldown <= 0) {
    shoot_projectile(id, obj_fire_projectile);
    shoot_cooldown = shoot_delay;
}

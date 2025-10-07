// Full-auto shooting, if want Semi-auto use left pressed
if (shoot_cooldown <= 0) {
    var selected_gourd = self.inv[self.sel_slot];

    if (selected_gourd.can_use()) {
        show_debug_message("Using gourd: " + selected_gourd.name);
        selected_gourd.use(id);
        selected_gourd.trigger_cd();
    }

    shoot_cooldown = shoot_delay;
}

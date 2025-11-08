// CONVERT TELEGRAPH TIMING TO SECONDS-BASED
telegraph_attack_blink_duration_seconds = 0.167; // 0.167 seconds between blinks
telegraph_attack_blink_freq = telegraph_attack_blink_duration_seconds;
telegraph_attack_blink_cd = 0;
telegraph_attack_blink_num = 0;

telegraph_total_blinks = 6; // Total number of blinks before attack (was 3, now 6 for longer warning)
telegraph_total_duration_seconds = 1.5; // Total telegraph duration: 3 seconds
telegraph_total_duration = telegraph_total_duration_seconds;
do_telegraph_show = false;


is_telegraphing = false;
func_execute_attack = undefined
c_telegraph = c_yellow;

function init_telegraph_attack(execute_attack, colour_telegraph = c_yellow, telegraph_total_blink = 6) {
    c_telegraph = colour_telegraph;
    func_execute_attack = execute_attack;
    is_telegraphing = true;
    self.telegraph_total_blink = telegraph_total_blink
}
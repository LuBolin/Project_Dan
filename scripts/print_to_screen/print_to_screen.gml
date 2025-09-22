/// @function print_to_screen()
function print_to_screen() {
    var output_string = "";
    for (var i = 0; i < argument_count; i++) {
        output_string += string(argument[i]) + " ";
    }
	draw_text(32, 32, output_string);
}
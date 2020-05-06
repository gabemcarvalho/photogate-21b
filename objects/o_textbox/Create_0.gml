/// @description Initialize the textbox
/*

Message Format:

- Signify the end of a line with a curly bracket. [ } ]
- Each line must be at least two characters.
- Change the colour of a word by putting a special character before it.
	- Red:		[ ^ ]
	- Blue:		[ & ]
	- Default:	[ ~ ]
- These colours and characters can be easily changed.
- More colours can be added.
- There is the potential to add more text effects in the future.

*/

// State
// 0 = startup
// 1 = scrolling text
// 2 = line change
state = 0;

// Box and drawing variables
line_height = 8;
space_width = 4;

box_width = VIEW_WIDTH-4//12; // Initial width
box_wmax = VIEW_WIDTH-4; // Final width
box_x1 = 2//(VIEW_WIDTH/2)-6; // Initial x
box_xmax = 2; // Final x

box_height = 2; // Initial height
box_hmax = 18//((line_height+2)*3); // Final height
box_y1 = VIEW_HEIGHT-floor(box_hmax/2)-box_height/2; // Initial y
box_ymax = VIEW_HEIGHT-box_hmax-2; // Final y

grow_speed = 3;
growing = 1;

/// Text variables
// The textbox message
message = global.message;

// Keep track of current message
current = 0;

// Get the current message to display
get_new_message();

// Default x and y text positions
text_x_default = 6;
text_y_default = VIEW_HEIGHT-box_hmax+2-10;
text_x_last = text_x_default;
text_y_last = text_y_default+line_height;

// Colours
col_default = c_white;
col_red = global.cl_red;
col_blue = global.cl_blue;

// Arrays for characters, x positions, y positions, and colour
text_char[0] = " ";
text_char[1] = 0;
text_x[0] = text_x_last;
text_y[0] = text_y_last;
text_colour[0] = col_default;

// The current colour of the text
colour = col_default;

// Position and technical variables
counter = 0;
counter_default_default = 3;//3
counter_default = counter_default_default;
grammar_delay = 6;
place = 1;
wait = 1;
done = false;
closeable = false;
close_counter_max = 16;
close_counter = close_counter_max/2-1;
close_delay = room_speed/6;
scroll_speed = 1;//4

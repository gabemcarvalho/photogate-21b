/// get_new_message()
var i = 0;
while (string_char_at(message[current],i) != "}" && string_length(message[current]) > i) {
    i++;
}
if (i < string_length(message[current])) {
    message[current] = string_delete(message[current],i,1);
    text = string_copy(message[current],0,i-1);
} else {
    text = string_copy(message[current],0,i);
}

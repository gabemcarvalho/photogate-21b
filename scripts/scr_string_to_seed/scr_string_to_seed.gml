///@description scr_string_to_seed(string)
///@param string
var s = string( argument0 );
var n = "";
for (var i = 1; i <= string_length(s); i++) {
	var c = string_char_at(s, i);
	switch c {
		case "1": n += "1";		break;
		case "2": n += "1";		break;
		case "3": n += "1";		break;
		case "4": n += "1";		break;
		case "5": n += "1";		break;
		case "6": n += "1";		break;
		case "7": n += "1";		break;
		case "8": n += "1";		break;
		case "9": n += "1";		break;
		case " ": n += "0";		break;
		case "-": n += "0";		break;
		case "a": n += "1";		break;
		case "b": n += "2";		break;
		case "c": n += "3";		break;
		case "d": n += "4";		break;
		case "e": n += "5";		break;
		case "f": n += "6";		break;
		case "g": n += "7";		break;
		case "h": n += "8";		break;
		case "i": n += "9";		break;
		case "j": n += "0";		break;
		case "k": n += "1";		break;
		case "l": n += "2";		break;
		case "m": n += "3";		break;
		case "n": n += "4";		break;
		case "o": n += "5";		break;
		case "p": n += "6";		break;
		case "q": n += "7";		break;
		case "r": n += "8";		break;
		case "s": n += "9";		break;
		case "t": n += "0";		break;
		case "u": n += "1";		break;
		case "v": n += "2";		break;
		case "w": n += "3";		break;
		case "x": n += "4";		break;
		case "y": n += "5";		break;
		case "z": n += "6";		break;
		default:  n += "0";		break;
	}
	if i == 9 break;
}
if n == "" return irandom(100);
return real(n);
/// approach(variable, amount, limit)
/// @param variable
/// @param amount
/// @param limit
var vari = argument0;
var amt = argument1;
var lim = argument2;

if vari == lim return lim;

if lim > vari {
    return min(lim,vari+amt);
} else if lim < vari {
    return max(lim,vari-amt);
}

//
// This help file was automatically generated from lowdisc_dec2bin.sci using help_from_sci().
// PLEASE DO NOT EDIT
//
mode(1)
//
// Demo of lowdisc_dec2bin.sci
//

// example 1
x=86
str=dec2bin(x)
halt()   // Press return to continue
 
// example 2
// the binary representation of 86 is: '1010110'
// its length is 7(less than n), so we add to str, 8 times the character '0'  (on the left)
x=86
n=15
str=dec2bin(x,n)
halt()   // Press return to continue
 
// example 3
x=[12 45 135]
z=dec2bin(x)
x=[12 45 135]'
z=dec2bin(x)
halt()   // Press return to continue
 
// example 4 : returns integers, instead of string
x=[12 45 135]
z=dec2bin(x,[],2)
// See that the result does not depend on the orientation of x.
x=[12 45 135]'
z=dec2bin(x,[],2)
halt()   // Press return to continue
 
// example 4 : returns integers, instead of string and pad to 8 bits
x=[12 45 135]
z=dec2bin(x,8,2)
// See that the result does not depend on the orientation of x.
x=[12 45 135]'
z=dec2bin(x,8,2)
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_dec2bin.sce";
dname = get_absolute_file_path(filename);
editor ( fullfile(dname,filename) );

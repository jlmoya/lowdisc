//
// This help file was automatically generated from lowdisc_bitand.sci using help_from_sci().
// PLEASE DO NOT EDIT
//
mode(1)
//
// Demo of lowdisc_bitand.sci
//

// example 1 :
// '1010110' : is the binary representation of 86
// '1011011' : is the binary representation of 91
// '1010010' : is the binary representation for the AND of binary representation 86 and 91
// so the decimal number corresponding to the AND  applied to binary forms 86 and 91 is : 82
x=86;
lowdisc_dec2bin(x)
y=91;
lowdisc_dec2bin(y)
z=lowdisc_bitand(x,y)
lowdisc_dec2bin(z)
// example 2 : the function is vectorized
x=[12,45];
y=[25,49];
z=lowdisc_bitand(x,y)
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_bitand.sce";
dname = get_absolute_file_path(filename);
editor ( fullfile(dname,filename) );

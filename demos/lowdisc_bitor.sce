mode(1)
//
// Demo of lowdisc_bitor.sci
//

// example 1 :
// '110000' : is the binary representation of 48
// '100101' : is the binary representation of 37
// '110101' : is the binary representation for the OR applied to the binary forms 48 and 37
// so the decimal number corresponding to the OR  applied to binary forms 48 and 37 is : 53
x=48;
lowdisc_dec2bin(x)
y=37;
lowdisc_dec2bin(y)
z=bitor(x,y)
lowdisc_dec2bin(z)
// example 2 : the function is vectorized
x=[12,45];
y=[25,49];
z=bitor(x,y)
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_bitor.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );

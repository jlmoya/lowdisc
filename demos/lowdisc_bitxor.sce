mode(1)
//
// Demo of lowdisc_bitxor.sci
//

halt()   // Press return to continue
 
// Compute xor for several pairs of integers.
// In base-2, 86 = [1 0 1 0 1 1 0]'
lowdisc_bary ( 86 , 2 )
// In base-2, 19 = [1 0 0 1 1]'
lowdisc_bary ( 1 0 0 1 1 , 2 )
// The xor of [1 0 1 0 1 1 0]' and [1 0 0 1 1]' is [1 0 0 0 1 0 1]'
// The decimal value of [1 0 0 0 1 0 1]' is 69.
y = lowdisc_bitxor ( 86 , 19 )
halt()   // Press return to continue
 
// Compute xor for several pairs of integers.
mprintf("%5s %5s %15s %15s %15s %5s\n","x1","x2","x1 - Binary", "x2 - Binary", "xor - Binary" , "xor - Decimal");
mprintf("-------------------------------------\n");
x12 = [
86     19
90     31
32     48
4     22
41     36
55     71
77     77
37     57
100      8
99     76
];
for i = 1 : 10
y = lowdisc_bitxor ( x12(i,1) , x12(i,2) );
d1 = lowdisc_bary ( x12(i,1) , 2 );
d2 = lowdisc_bary ( x12(i,2) , 2 );
d3 = lowdisc_bary ( y , 2 );
mprintf("%5d %5d %15s %15s %15s %5d\n",x12(i,1),x12(i,2),strcat(string(d1)," "),strcat(string(d2)," "),strcat(string(d3)," "),y);
end
halt()   // Press return to continue
 
// This function is vectorized.
y = lowdisc_bitxor ( x12(:,1) , x12(:,2) )
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_bitxor.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );

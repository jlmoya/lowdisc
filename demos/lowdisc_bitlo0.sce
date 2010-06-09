mode(1)
//
// Demo of lowdisc_bitlo0.sci
//

// n = 11 is equal to "1 0 1 1" in binary
d = lowdisc_bary ( 11 , 2 )'
// Hence, the low 0 bit is 3
// i.e., from the right, the first zero is at index 3.
bit = lowdisc_bitlo0 ( 11 )
halt()   // Press return to continue
 
// Compute the low 0 bit for several integers
mprintf("%5s %25s %5s\n","N","Binary","bit");
mprintf("-------------------------------------\n");
nmat =  [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 1023 1024 1025];
for n = nmat
bit = lowdisc_bitlo0 ( n );
d = lowdisc_bary ( n , 2 );
mprintf("%5d %25s %5d\n",n,strcat(string(d)," "),bit);
end
halt()   // Press return to continue
 
Author:
2005 - John Burkardt
2009 - Digiteo - Michael Baudin (Scilab version)
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_bitlo0.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );

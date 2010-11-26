//
// This help file was automatically generated from lowdisc_bithi1.sci using help_from_sci().
// PLEASE DO NOT EDIT
//
mode(1)
//
// Demo of lowdisc_bithi1.sci
//

// n = 22 writes [1 0 1 1 0]' in base 2
lowdisc_bary(22)'
// Hence, the high 1 bit is 5,
// i.e. the highest 1 bit is at index 5.
lowdisc_bithi1 ( 22 )
halt()   // Press return to continue
 
// Compute the high 1 bit for several integers
mprintf("%5s %25s %5s\n","N","Binary","bit");
mprintf("-------------------------------------\n");
nmat =  [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 1023 1024 1025];
for n = nmat
bit = lowdisc_bithi1 ( n );
d = lowdisc_bary ( n , 2 );
mprintf("%5d %25s %5d\n",n,strcat(string(d)," "),bit);
end
halt()   // Press return to continue
 
Author:
halt()   // Press return to continue
 
2008-2009 - INRIA - Michael Baudin (Scilab version)
2010 - Digiteo - Michael Baudin
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_bithi1.sce";
dname = get_absolute_file_path(filename);
editor ( fullfile(dname,filename) );

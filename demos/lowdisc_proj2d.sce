mode(1)
//
// Demo of lowdisc_proj2d.sci
//

callf = 1.e2;
n = 6;
ldseq = "haltonf";
strict = %t;
[ evalf , u ] = intprb_ldgen ( callf , n , ldseq , strict );
plot2Dproj ( u , 1 : n )
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_proj2d.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );

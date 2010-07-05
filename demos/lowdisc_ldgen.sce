mode(1)
//
// Demo of lowdisc_ldgen.sci
//

// Generate more than 100 points from a Halton sequence in dimension 4
callf = 100
n = 4
ldseq = "halton"
[ evalf , u ] = ldgen ( callf , n , ldseq )
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_ldgen.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );

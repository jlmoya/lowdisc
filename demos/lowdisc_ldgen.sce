mode(1)
//
// Demo of lowdisc_ldgen.sci
//

// Generate more than 20 points from a fast Halton sequence in dimension 4
callf = 20
n = 4
ldseq = "haltonf"
[ evalf , u ] = lowdisc_ldgen ( callf , n , ldseq )
halt()   // Press return to continue
 
// Generate the suggested number of points from the fast Faure sequence.
[ evalf , u ] = lowdisc_ldgen ( 20 , 4 , "fauref" )
// Generate exactly 20 points (this is not recommended, it may increase the discrepancy).
[ evalf , u ] = lowdisc_ldgen ( 20 , 4 , "fauref" , %t )
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_ldgen.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );

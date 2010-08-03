mode(1)
//
// Demo of lowdisc_proj2d.sci
//

callf = 1.e2;
n = 6;
ldseq = "haltonf";
strict = %t;
[ evalf , u ] = lowdisc_ldgen ( callf , n , ldseq );
// See all possible projections.
lowdisc_proj2d ( u , 1:n )
// See all projections for dimensions 2,3,6.
scf();
lowdisc_proj2d ( u , [2,3,6] )
// See projection (3,6)
scf();
lowdisc_proj2d ( u , [3,6] )
// In this case, we could also use :
scf();
plot( u(:,3) , u(:,6) )
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_proj2d.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );

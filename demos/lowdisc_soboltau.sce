mode(1)
//
// Demo of lowdisc_soboltau.sci
//

halt()   // Press return to continue
 
// Returns 3
tau = lowdisc_soboltau ( 4 )
// Returns -1
tau = lowdisc_soboltau ( 14 )
// Generates an error
tau = lowdisc_soboltau ( 0 )
halt()   // Press return to continue
 
dim = 4;
lds = lowdisc_new("sobol");
lds = lowdisc_configure(lds,"-dimension",dim);
tau = lowdisc_soboltau ( dim );
assert_equal ( tau , 3 );
skip = 2^(tau + dim - 1);
lds = lowdisc_configure(lds,"-skip", skip);
lds = lowdisc_startup (lds);
[lds,computed]=lowdisc_next(lds,10);
lds = lowdisc_destroy(lds);
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_soboltau.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );

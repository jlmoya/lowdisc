mode(1)
//
// Demo of lowdisc_primes100.sci
//

prarray = lowdisc_primes100 ( );
size(prarray)
halt()   // Press return to continue
 
rng = lowdisc_new("faure");
prarray = lowdisc_primes100 ( );
rng = lowdisc_configure(rng,"-primeslist",prarray);
rng = lowdisc_configure(rng,"-dimension",50);
[rng,next] = lowdisc_next ( rng );
next
rng = lowdisc_destroy(rng);
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_primes100.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );

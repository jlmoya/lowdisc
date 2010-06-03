mode(1)
//
// Demo of lowdisc_primes1000.sci
//

prarray = lowdisc_primes1000 ( );
size(prarray)
halt()   // Press return to continue
 
rng = lowdisc_new("faure");
prarray = lowdisc_primes1000 ( );
rng = lowdisc_configure(rng,"-primeslist",prarray);
rng = lowdisc_configure(rng,"-dimension",150);
[rng,next] = lowdisc_next ( rng );
next
rng = lowdisc_destroy(rng);
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_primes1000.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );

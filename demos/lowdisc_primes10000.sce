mode(1)
//
// Demo of lowdisc_primes10000.sci
//

prarray = lowdisc_primes10000 ( );
size(prarray)
halt()   // Press return to continue
 
rng = lowdisc_new();
rng = lowdisc_configure(rng,"-method","faure");
prarray = lowdisc_primes10000 ( );
rng = lowdisc_configure(rng,"-primeslist",prarray);
rng = lowdisc_configure(rng,"-dimension",1500);
[rng,next] = lowdisc_next ( rng );
next
rng = lowdisc_destroy(rng);
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//

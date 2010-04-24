mode(1)
//
// Demo of lowdisc_cget.sci
//

rng = lowdisc_new();
rng = lowdisc_configure(rng,"-method","faure");
rng = lowdisc_configure(rng,"-dimension",3);
method = lowdisc_cget(rng,"-method")
nbdim = lowdisc_cget(rng,"-dimension")
i = lowdisc_cget(rng,"-sequenceindex")
verbose = lowdisc_cget(rng,"-verbose")
rng
rng = lowdisc_destroy(rng);
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//

mode(1)
//
// Demo of lowdisc_new.sci
//

rng = lowdisc_new();
rng = lowdisc_configure(rng,"-method","faure");
rng
rng = lowdisc_destroy(rng);
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//

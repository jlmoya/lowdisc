mode(1)
//
// Demo of lowdisc_startup.sci
//

rng = lowdisc_new();
rng = lowdisc_configure(rng,"-method","halton");
rng = lowdisc_startup (rng);
// Term #1
[rng,computed] = lowdisc_next (rng);
// Term #2
[rng,computed] = lowdisc_next (rng);
rng
rng = lowdisc_destroy(rng);
halt()   // Press return to continue
 
// See the -skip option in action
rng = lowdisc_new();
rng = lowdisc_configure(rng,"-method","halton");
rng = lowdisc_configure(rng,"-skip",12);
rng = lowdisc_startup (rng);
// Term #13
[rng,computed] = lowdisc_next (rng);
// Term #14
[rng,computed] = lowdisc_next (rng);
rng
rng = lowdisc_destroy(rng);
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//

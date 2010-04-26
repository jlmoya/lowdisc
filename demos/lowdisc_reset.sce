mode(1)
//
// Demo of lowdisc_reset.sci
//

rng = lowdisc_new();
rng = lowdisc_configure(rng,"-method","halton");
rng = lowdisc_startup (rng);
// Term #1
[rng,computed] = lowdisc_next (rng);
// Term #2
[rng,computed] = lowdisc_next (rng);
// Reset the sequence
this = lowdisc_reset (this);
// Term #1,
[rng,computed] = lowdisc_next (rng);
// Term #2
[rng,computed] = lowdisc_next (rng);
rng
rng = lowdisc_destroy(rng);
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//

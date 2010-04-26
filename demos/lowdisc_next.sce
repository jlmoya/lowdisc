mode(1)
//
// Demo of lowdisc_next.sci
//

rng = lowdisc_new();
rng = lowdisc_configure(rng,"-method","halton");
rng = lowdisc_startup (rng);
// Term #1
[rng,computed] = lowdisc_next (rng);
// Term #2
[rng,computed] = lowdisc_next (rng);
// Term #3, etc...
[rng,computed] = lowdisc_next (rng);
rng
rng = lowdisc_destroy(rng);
halt()   // Press return to continue
 
// See the imax parameter in action
rng = lowdisc_new();
rng = lowdisc_configure(rng,"-method","halton");
rng = lowdisc_startup (rng);
// Term #1 to 100
[rng,computed] = lowdisc_next (rng,100);
// Term #101 to 201
[rng,computed] = lowdisc_next (rng,100);
rng
rng = lowdisc_destroy(rng);
halt()   // Press return to continue
 
// See the -leap option in action
rng = lowdisc_new();
rng = lowdisc_configure(rng,"-method","halton");
rng = lowdisc_configure(rng,"-leap",10);
rng = lowdisc_startup (rng);
// Term #1
[rng,computed] = lowdisc_next (rng);
// Term #11
[rng,computed] = lowdisc_next (rng);
// Term #21
[rng,computed] = lowdisc_next (rng);
rng
rng = lowdisc_destroy(rng);
halt()   // Press return to continue
 
// See the -skip option in action.
rng = lowdisc_new();
rng = lowdisc_configure(rng,"-method","fauref");
rng = lowdisc_configure(rng,"-dimension",4);
// Skip qs^4 - 1 terms, as in TOMS implementation
qs = lowdisc_get ( rng , "-faurefprime" );
rng = lowdisc_configure(rng,"-skip", qs^4 - 2);
rng
rng = lowdisc_startup (rng);
[rng,computed]=lowdisc_next(rng);
// Terms #1 to #100
[rng,computed]=lowdisc_terms(rng,100);
for i = 1:100
mprintf ("%8d %14.6f %14.6f %14.6f %14.6f\n", i , computed(i,1) , computed(i,2) , computed(i,3) , computed(i,4) )
end
rng = lowdisc_destroy(rng);
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//

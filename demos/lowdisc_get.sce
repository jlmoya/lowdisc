mode(1)
//
// Demo of lowdisc_get.sci
//

halt()   // Press return to continue
 
rng = lowdisc_new("faure");
rng = lowdisc_configure(rng,"-dimension",4);
// Skip qs^4 - 1 terms, as in TOMS implementation
qs = lowdisc_get ( rng , "-faureprime" );
rng = lowdisc_configure(rng,"-skip", qs^4 - 2);
rng
rng = lowdisc_startup (rng);
// Terms #1 to #100
[rng,computed]=lowdisc_next(rng,100);
for i = 1:100
mprintf ("%8d %14.6f %14.6f %14.6f %14.6f\n", i , computed(i,1) , computed(i,2) , computed(i,3) , computed(i,4) )
end
rng = lowdisc_destroy(rng);
halt()   // Press return to continue
 
// See the -skip option in action in the Faure fast sequence.
rng = lowdisc_new("fauref");
rng = lowdisc_configure(rng,"-dimension",4);
// Skip qs^4 - 1 terms, as in TOMS implementation
qs = lowdisc_get ( rng , "-faurefprime" );
rng = lowdisc_configure(rng,"-skip", qs^4 - 2);
rng
rng = lowdisc_startup (rng);
[rng,computed]=lowdisc_next(rng);
// Terms #1 to #100
[rng,computed]=lowdisc_next(rng,100);
for i = 1:100
mprintf ("%8d %14.6f %14.6f %14.6f %14.6f\n", i , computed(i,1) , computed(i,2) , computed(i,3) , computed(i,4) )
end
rng = lowdisc_destroy(rng);
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_get.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );

mode(1)
//
// Demo of lowdisc_next.sci
//

lds = lowdisc_new("halton");
lds = lowdisc_startup (lds);
// Term #1
[lds,computed] = lowdisc_next (lds);
// Term #2
[lds,computed] = lowdisc_next (lds);
// Term #3, etc...
[lds,computed] = lowdisc_next (lds);
lds
lds = lowdisc_destroy(lds);
halt()   // Press return to continue
 
// See the imax parameter in action
lds = lowdisc_new("halton");
lds = lowdisc_startup (lds);
// Term #1 to 100
[lds,computed] = lowdisc_next (lds,100);
// Term #101 to 201
[lds,computed] = lowdisc_next (lds,100);
lds
lds = lowdisc_destroy(lds);
halt()   // Press return to continue
 
// See the -leap option in action
lds = lowdisc_new("halton");
lds = lowdisc_configure(lds,"-leap",10);
lds = lowdisc_startup (lds);
// Term #1
[lds,computed] = lowdisc_next (lds);
// Term #11
[lds,computed] = lowdisc_next (lds);
// Term #21
[lds,computed] = lowdisc_next (lds);
lds
lds = lowdisc_destroy(lds);
halt()   // Press return to continue
 
// See the -skip option in action.
lds = lowdisc_new("fauref");
lds = lowdisc_configure(lds,"-dimension",4);
// Skip qs^4 - 1 terms, as in TOMS implementation
qs = lowdisc_get ( lds , "-faurefprime" );
lds = lowdisc_configure(lds,"-skip", qs^4 - 2);
lds
lds = lowdisc_startup (lds);
[lds,computed]=lowdisc_next(lds);
// Terms #1 to #100
[lds,computed]=lowdisc_next(lds,100);
for i = 1:100
mprintf ("%8d %14.6f %14.6f %14.6f %14.6f\n", i , computed(i,1) , computed(i,2) , computed(i,3) , computed(i,4) )
end
lds = lowdisc_destroy(lds);
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_next.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );

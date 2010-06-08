mode(1)
//
// Demo of lowdisc_get.sci
//

halt()   // Press return to continue
 
// Faure sequence: get the base associated with current dimension.
// See the -skip option in action in the Faure fast sequence.
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
filename = "lowdisc_get.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );

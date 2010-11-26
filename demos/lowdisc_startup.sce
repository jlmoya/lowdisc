//
// This help file was automatically generated from lowdisc_startup.sci using help_from_sci().
// PLEASE DO NOT EDIT
//
mode(1)
//
// Demo of lowdisc_startup.sci
//

lds = lowdisc_new("halton");
lds = lowdisc_startup (lds);
// Term #1
[lds,computed] = lowdisc_next (lds);
// Term #2
[lds,computed] = lowdisc_next (lds);
lds
lds = lowdisc_destroy(lds);
halt()   // Press return to continue
 
// See the -skip option in action
lds = lowdisc_new("halton");
lds = lowdisc_configure(lds,"-skip",12);
lds = lowdisc_startup (lds);
// Term #13
[lds,computed] = lowdisc_next (lds);
// Term #14
[lds,computed] = lowdisc_next (lds);
lds
lds = lowdisc_destroy(lds);
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_startup.sce";
dname = get_absolute_file_path(filename);
editor ( fullfile(dname,filename) );

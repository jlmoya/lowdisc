//
// This help file was automatically generated from lowdisc_destroy.sci using help_from_sci().
// PLEASE DO NOT EDIT
//
mode(1)
//
// Demo of lowdisc_destroy.sci
//

lds = lowdisc_new("faure");
lds
lds = lowdisc_destroy(lds);
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_destroy.sce";
dname = get_absolute_file_path(filename);
editor ( fullfile(dname,filename) );

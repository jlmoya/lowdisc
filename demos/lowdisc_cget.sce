//
// This help file was automatically generated from lowdisc_cget.sci using help_from_sci().
// PLEASE DO NOT EDIT
//
mode(1)
//
// Demo of lowdisc_cget.sci
//

lds = lowdisc_new("faure");
lds = lowdisc_configure(lds,"-dimension",3);
method = lowdisc_cget(lds,"-method")
nbdim = lowdisc_cget(lds,"-dimension")
i = lowdisc_cget(lds,"-sequenceindex")
verbose = lowdisc_cget(lds,"-verbose")
lds
lds = lowdisc_destroy(lds);
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_cget.sce";
dname = get_absolute_file_path(filename);
editor ( fullfile(dname,filename) );

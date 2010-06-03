mode(1)
//
// Demo of lowdisc_destroy.sci
//

rng = lowdisc_new("faure");
rng
rng = lowdisc_destroy(rng);
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_destroy.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );

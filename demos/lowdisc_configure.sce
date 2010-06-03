mode(1)
//
// Demo of lowdisc_configure.sci
//

rng = lowdisc_new("faure");
rng = lowdisc_configure(rng,"-dimension",3);
method = lowdisc_cget(rng,"-method")
nbdim = lowdisc_cget(rng,"-dimension")
i = lowdisc_cget(rng,"-sequenceindex")
verbose = lowdisc_cget(rng,"-verbose")
rng
rng = lowdisc_destroy(rng);
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_configure.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );

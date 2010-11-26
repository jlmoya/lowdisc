//
// This help file was automatically generated from lowdisc_primes10000.sci using help_from_sci().
// PLEASE DO NOT EDIT
//
mode(1)
//
// Demo of lowdisc_primes10000.sci
//

prarray = lowdisc_primes10000 ( );
size(prarray)
halt()   // Press return to continue
 
lds = lowdisc_new("faure");
prarray = lowdisc_primes10000 ( );
lds = lowdisc_configure(lds,"-primeslist",prarray);
lds = lowdisc_configure(lds,"-dimension",1500);
[lds,next] = lowdisc_next ( lds );
next
lds = lowdisc_destroy(lds);
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_primes10000.sce";
dname = get_absolute_file_path(filename);
editor ( fullfile(dname,filename) );

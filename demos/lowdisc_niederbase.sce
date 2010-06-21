mode(1)
//
// Demo of lowdisc_niederbase.sci
//

halt()   // Press return to continue
 
// See the optimal base for various dimensions.
base = lowdisc_niederbase ( 1 )
base = lowdisc_niederbase ( 2 )
base = lowdisc_niederbase ( 3 )
base = lowdisc_niederbase ( 12 )
// For dim >= 12, the base is set to 2.
base = lowdisc_niederbase ( 13 )
halt()   // Press return to continue
 
// See the optimal base for various dimensions.
for dim = 1 : 15
base = lowdisc_niederbase ( dim );
mprintf("dim=%5d, base=%5d\n",dim,base)
end
halt()   // Press return to continue
 
// Use the optimal base in dimension 4.
dim = 4;
base = lowdisc_niederbase ( dim );
lds = lowdisc_new("niederreiterf");
lds = lowdisc_configure(lds,"-dimension",dim);
lds = lowdisc_configure(lds,"-base",base);
lds = lowdisc_startup (lds);
[lds,computed]=lowdisc_next(lds,10);
lds = lowdisc_destroy(lds);
disp(computed)
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_niederbase.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );

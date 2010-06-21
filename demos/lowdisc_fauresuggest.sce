mode(1)
//
// Demo of lowdisc_fauresuggest.sci
//

halt()   // Press return to continue
 
// See the minimum number of simulations for integration in dimension 4.
dim = 4;
base = 5;
// See "Algorithm 659", p97, Table II
[nsim,skip,leap] = lowdisc_fauresuggest ( dim , base );
[nsim,skip,leap] = lowdisc_fauresuggest ( dim , base , 10000 );
[nsim,skip,leap] = lowdisc_fauresuggest ( dim , base , 50000 );
[nsim,skip,leap] = lowdisc_fauresuggest ( dim , base , 100000 );
halt()   // Press return to continue
 
// Use the minimum number of simulations for integration in dimension 4.
// Use Faure
dim = 4;
nsimmin = 1000;
lds = lowdisc_new("faure");
lds = lowdisc_configure(lds,"-dimension",dim);
base = lowdisc_get(lds,"-faureprime");
[nsim,skip,leap] = lowdisc_fauresuggest ( dim , base , nsimmin );
lds = lowdisc_configure(lds,"-skip",skip);
lds = lowdisc_configure(lds,"-leap",leap);
lds = lowdisc_startup (lds);
[lds,experiments]=lowdisc_next(lds,nsim);
lds = lowdisc_destroy(lds);
halt()   // Press return to continue
 
// Use the minimum number of simulations for integration in dimension 4.
// Use Fast Faure
dim = 4;
nsimmin = 1000;
lds = lowdisc_new("fauref");
lds = lowdisc_configure(lds,"-dimension",dim);
base = lowdisc_get(lds,"-faurefprime");
[nsim,skip,leap] = lowdisc_fauresuggest ( dim , base , nsimmin );
lds = lowdisc_configure(lds,"-skip",skip);
lds = lowdisc_configure(lds,"-leap",leap);
lds = lowdisc_startup (lds);
[lds,experiments]=lowdisc_next(lds,nsim);
lds = lowdisc_destroy(lds);
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_fauresuggest.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );

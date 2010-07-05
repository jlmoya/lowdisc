mode(1)
//
// Demo of lowdisc_sobolsuggest.sci
//

halt()   // Press return to continue
 
// See the minimum number of simulations
// for integration in dimension 4.
[nsim,skip,leap] = lowdisc_sobolsuggest ( 4 )
// See the number of simulations larger than 1000
// for integration in dimension 4
[nsim,skip,leap] = lowdisc_sobolsuggest ( 4 , 1000 )
// See the number of simulations larger than 100
// for global optimization in dimension 4
[nsim,skip,leap] = lowdisc_sobolsuggest ( 4 , 100 , 2 )
// In dimension 14, the value of tau is not available
[nsim,skip,leap] = lowdisc_sobolsuggest ( 14 , [] , 1 )
// Caution : with global optimization purpose and
// default minimum number of simulations,
// this generates a very small number of simulations
[nsim,skip,leap] = lowdisc_sobolsuggest ( 14 , [] , 2 )
halt()   // Press return to continue
 
// See the recommended number of simulations in dimension 4
mprintf("%20s %20s\n","N Min","N Recommended");
for nsimmin = logspace(1,10,10)
[nsim,skip,leap] = lowdisc_sobolsuggest ( 4 , nsimmin );
mprintf("%20.0f %20.0f\n",nsimmin,nsim);
end
halt()   // Press return to continue
 
// Use the minimum recommended number of simulations
// for integration in dimension 4.
// Use Sobol
dim = 4;
[nsim,skip,leap] = lowdisc_sobolsuggest ( dim );
lds = lowdisc_new("sobol");
lds = lowdisc_configure(lds,"-dimension",dim);
lds = lowdisc_configure(lds,"-skip",skip);
lds = lowdisc_configure(lds,"-leap",leap);
lds = lowdisc_startup (lds);
[lds,experiments]=lowdisc_next(lds,nsim);
lds = lowdisc_destroy(lds);
disp(computed)
halt()   // Press return to continue
 
// Use the minimum recommended number of simulations
// for integration in dimension 4.
// Use fast Sobol
dim = 4;
[nsim,skip,leap] = lowdisc_sobolsuggest ( dim );
lds = lowdisc_new("sobolf");
lds = lowdisc_configure(lds,"-dimension",dim);
lds = lowdisc_configure(lds,"-skip",skip);
lds = lowdisc_configure(lds,"-leap",leap);
lds = lowdisc_startup (lds);
[lds,experiments]=lowdisc_next(lds,nsim);
lds = lowdisc_destroy(lds);
halt()   // Press return to continue
 
// Display recommended number of simulations
// for integration in various dimensions.
// It grows extremely fast.
mprintf("%-10s %-10s %-10s %-10s\n", ..
"dim", "nsim", "skip", "leap");
for dim = 1:14;
[nsim,skip,leap] = lowdisc_sobolsuggest ( dim , [] , 1 );
mprintf("%-10s %-10s %-10s %-10s\n", ..
string(dim), string(nsim), string(skip), string(leap));
end
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_sobolsuggest.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );

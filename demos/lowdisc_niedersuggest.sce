//
// This help file was automatically generated from lowdisc_niedersuggest.sci using help_from_sci().
// PLEASE DO NOT EDIT
//
mode(1)
//
// Demo of lowdisc_niedersuggest.sci
//

halt()   // Press return to continue
 
// See the suggested number of simulations in dimension 4.
// See "Algorithm 659", p97, Table II
dim = 4;
// See with default base = 2.
[nsim,skip,leap] = lowdisc_niedersuggest ( dim );
// See with base = 5.
base = 5;
[nsim,skip,leap] = lowdisc_niedersuggest ( dim , base );
[nsim,skip,leap] = lowdisc_niedersuggest ( dim , base , 10000 );
[nsim,skip,leap] = lowdisc_niedersuggest ( dim , base , 50000 );
[nsim,skip,leap] = lowdisc_niedersuggest ( dim , base , 100000 );
// Set the number of simulations, but use default base
[nsim,skip,leap] = lowdisc_niedersuggest ( dim , [] , 100000 );
halt()   // Press return to continue
 
// Use the fast Niederreiter in arbitrary base,
// optimal base, minimum number of simulations in dimension 4.
dim = 4;
base = lowdisc_niederbase ( dim );
[nsim,skip,leap] = lowdisc_niedersuggest ( dim , base );
lds = lowdisc_new("niederreiterf");
lds = lowdisc_configure(lds,"-dimension",dim);
lds = lowdisc_configure(lds,"-base",base);
lds = lowdisc_configure(lds,"-skip",skip);
lds = lowdisc_configure(lds,"-leap",leap);
lds = lowdisc_startup (lds);
[lds,computed]=lowdisc_next(lds,nsim);
lds = lowdisc_destroy(lds);
halt()   // Press return to continue
 
// Use the slow Base 2 Niederreiter and minimum number of simulations in dimension 4.
dim = 4;
[nsim,skip,leap] = lowdisc_niedersuggest ( dim );
lds = lowdisc_new("niederreiter-base-2");
lds = lowdisc_configure(lds,"-dimension",dim);
lds = lowdisc_configure(lds,"-skip",skip);
lds = lowdisc_configure(lds,"-leap",leap);
lds = lowdisc_startup (lds);
[lds,computed]=lowdisc_next(lds,nsim);
lds = lowdisc_destroy(lds);
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_niedersuggest.sce";
dname = get_absolute_file_path(filename);
editor ( fullfile(dname,filename) );

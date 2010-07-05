mode(1)
//
// Demo of lowdisc_haltonsuggest.sci
//

halt()   // Press return to continue
 
// See the suggestions in dimension 4.
dim = 8;
nsimmin = 1000;
[nsim,skip,leap] = lowdisc_haltonsuggest ( dim , nsimmin )
// In dimension 500, we do not have any leap to suggest
dim = 500;
nsimmin = 1000;
[nsim,skip,leap] = lowdisc_haltonsuggest ( dim , nsimmin )
halt()   // Press return to continue
 
// Use the Halton sequence in dimension 4.
dim = 4;
nsimmin = 1000;
[nsim,skip,leap] = lowdisc_haltonsuggest ( dim , nsimmin );
lds = lowdisc_new("halton");
lds = lowdisc_configure(lds,"-dimension",dim);
lds = lowdisc_configure(lds,"-skip",skip);
lds = lowdisc_configure(lds,"-leap",leap);
lds = lowdisc_startup (lds);
[lds,computed]=lowdisc_next(lds,nsim);
lds = lowdisc_destroy(lds);
halt()   // Press return to continue
 
// Use the fast Halton sequence in dimension 4.
dim = 4;
nsimmin = 1000;
[nsim,skip,leap] = lowdisc_haltonsuggest ( dim , nsimmin );
lds = lowdisc_new("haltonf");
lds = lowdisc_configure(lds,"-dimension",dim);
lds = lowdisc_configure(lds,"-skip",skip);
lds = lowdisc_configure(lds,"-leap",leap);
lds = lowdisc_startup (lds);
[lds,computed]=lowdisc_next(lds,nsim);
lds = lowdisc_destroy(lds);
halt()   // Press return to continue
 
// See the number of simulations as the product of the
// primes used in the Halton sequence.
// It is assumed that leap = 0, skip = 0.
prmat = lowdisc_primes100 ( );
for n = 1 : 15
disp([n prod(1:n)])
end
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_haltonsuggest.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );

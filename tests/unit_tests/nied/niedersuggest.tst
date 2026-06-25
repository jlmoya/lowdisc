// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2011 - DIGITEO - Michael Baudin

//
// This file must be used under the terms of the GNU LGPL license.
// 

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

// This is from :
//    "Implementation and Tests of Low Discrepancy Sequences",
//    Paul Bratley, Bennett Fox, Harald Niederreiter,
//    ACM Transactions on Modeling and Computer Simulation,
//    Volume 2, Number 3, July 1992, pages 195-213.
// p208, table I
//
dim = 8;
[nsim,skip,leap] = lowdisc_niedersuggest ( dim );
assert_checkequal ( [nsim,skip,leap] , [4096 4096 0] );
//
dim = 8;
base = 2;
[nsim,skip,leap] = lowdisc_niedersuggest ( dim , base );
assert_checkequal ( [nsim,skip,leap] , [4096 4096 0] );
//
dim = 8;
base = 2;
[nsim,skip,leap] = lowdisc_niedersuggest ( dim , base , 10000 );
assert_checkequal ( [nsim,skip,leap] , [16384 4096 0] );
//
dim = 8;
base = 2;
[nsim,skip,leap] = lowdisc_niedersuggest ( dim , base , 30000 );
assert_checkequal ( [nsim,skip,leap] , [32768 4096 0] );
//
dim = 8;
base = 9;
[nsim,skip,leap] = lowdisc_niedersuggest ( dim , base , 50000 );
assert_checkequal ( [nsim,skip,leap] , [59049 6561 0] );

// Check that nsim >= nsimmin for several powers of 10
dim = 8;
base = 9;
for nsimmin = logspace(1,10,10)
  [nsim,skip,leap] = lowdisc_niedersuggest ( dim , base , nsimmin );
  assert_checkequal ( nsim >= nsimmin , %t );
end


// Use the fast Niederreiter in arbitrary base, 
// optimal base, minimum number of simulations in dimension 4.
dim = 4;
base = lowdisc_niederbase ( dim );
[nsim,skip,leap] = lowdisc_niedersuggest ( dim , base );
lds = lowdisc_new("niederreiter");
lds = lowdisc_configure(lds,"-dimension",dim);
lds = lowdisc_configure(lds,"-base",base);
lds = lowdisc_configure(lds,"-skip",skip);
lds = lowdisc_configure(lds,"-leap",leap);

[lds,computed]=lowdisc_next(lds,nsim);
lds = lowdisc_destroy(lds);


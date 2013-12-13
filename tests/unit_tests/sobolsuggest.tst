// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2011 - DIGITEO - Michael Baudin

//
// This file must be used under the terms of the GNU LGPL license.
// 

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->



// See the minimum number of simulations for integration in dimension 4.
[nsim,skip,leap] = lowdisc_sobolsuggest ( 4 );
assert_checkequal ( [nsim,skip,leap] , [256 0 0] );
// See the number of simulations larger than 1000 for integration in dimension 4
[nsim,skip,leap] = lowdisc_sobolsuggest ( 4 , 1000 );
assert_checkequal ( [nsim,skip,leap] , [1024 0 0] );
// See the number of simulations larger than 100 for global optimization in dimension 4
[nsim,skip,leap] = lowdisc_sobolsuggest ( 4 , 100 , 2 );
assert_checkequal ( [nsim,skip,leap] , [128 0 0] );

// Check that nsim >= nsimmin for several powers of 10
for nsimmin = logspace(1,10,10)
  [nsim,skip,leap] = lowdisc_sobolsuggest ( 4 , nsimmin );
  assert_checkequal ( nsim >= nsimmin , %t );
end


// Use the minimum number of simulations for integration in dimension 4.
dim = 4;
[nsim,skip,leap] = lowdisc_sobolsuggest ( dim );
lds = lowdisc_new("sobol");
lds = lowdisc_configure(lds,"-dimension",dim);
lds = lowdisc_configure(lds,"-skip",skip);
lds = lowdisc_configure(lds,"-leap",leap);

[lds,experiments]=lowdisc_next(lds,nsim);
lds = lowdisc_destroy(lds);

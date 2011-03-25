// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2011 - DIGITEO - Michael Baudin

//
// This file must be used under the terms of the GNU LGPL license.
// 

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

// This is from :
//    "Computational investigations of low-discrepancy sequences", Kocis,
//    L. and Whiten, W. J. 1997. ACM Trans. Math. Softw. 23, 2 (Jun. 1997),
//    266-294.
//
dim = 8;
nsimmin = 1000;
[nsim,skip,leap] = lowdisc_haltonsuggest ( dim , nsimmin );
assert_checkequal ( [nsim,skip,leap] , [1000 0 409] );
//
dim = 500;
nsimmin = 1000;
[nsim,skip,leap] = lowdisc_haltonsuggest ( dim , nsimmin );
assert_checkequal ( [nsim,skip,leap] , [1000 0 0] );
//

// Check that nsim >= nsimmin for several powers of 10
dim = 8;
for nsimmin = logspace(1,10,10)
  [nsim,skip,leap] = lowdisc_haltonsuggest ( dim , nsimmin );
  assert_checkequal ( nsim >= nsimmin , %t );
end


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


// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2010 - DIGITEO - Michael Baudin

//
// This file must be used under the terms of the GNU LGPL license.
// 

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

//
// assert_close --
//   Returns 1 if the two real matrices computed and expected are close,
//   i.e. if the relative distance between computed and expected is lesser than epsilon.
// Arguments
//   computed, expected : the two matrices to compare
//   epsilon : a small number
//
function flag = assert_close ( computed, expected, epsilon )
  if expected==0.0 then
    shift = norm(computed-expected);
  else
    shift = norm(computed-expected)/norm(expected);
  end
  if shift < epsilon then
    flag = 1;
  else
    flag = 0;
  end
  if flag <> 1 then pause,end
endfunction
//
// assert_equal --
//   Returns 1 if the two real matrices computed and expected are equal.
// Arguments
//   computed, expected : the two matrices to compare
//   epsilon : a small number
//
function flag = assert_equal ( computed , expected )
  if ( and ( computed==expected ) ) then
    flag = 1;
  else
    flag = 0;
  end
  if flag <> 1 then pause,end
endfunction

// This is from :
//    "Computational investigations of low-discrepancy sequences", Kocis,
//    L. and Whiten, W. J. 1997. ACM Trans. Math. Softw. 23, 2 (Jun. 1997),
//    266-294.
//
dim = 8;
nsimmin = 1000;
[nsim,skip,leap] = lowdisc_haltonsuggest ( dim , nsimmin );
assert_equal ( [nsim,skip,leap] , [1000 0 409] );
//
dim = 500;
nsimmin = 1000;
[nsim,skip,leap] = lowdisc_haltonsuggest ( dim , nsimmin );
assert_equal ( [nsim,skip,leap] , [1000 0 0] );
//

// Check that nsim >= nsimmin for several powers of 10
dim = 8;
for nsimmin = logspace(1,10,10)
  [nsim,skip,leap] = lowdisc_haltonsuggest ( dim , nsimmin );
  assert_equal ( nsim >= nsimmin , %t );
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


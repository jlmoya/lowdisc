// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt





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
  if computed==expected then
    flag = 1;
  else
    flag = 0;
  end
  if flag <> 1 then pause,end
endfunction

// This is from :
//    "Implementation and Tests of Low Discrepancy Sequences",
//    Paul Bratley, Bennett Fox, Harald Niederreiter,
//    ACM Transactions on Modeling and Computer Simulation,
//    Volume 2, Number 3, July 1992, pages 195-213.
// p208, table I
//
dim = 8;
[nsim,skip,leap] = lowdisc_niedersuggest ( dim );
assert_equal ( [nsim,skip,leap] , [4096 4096 0] );
//
dim = 8;
base = 2;
[nsim,skip,leap] = lowdisc_niedersuggest ( dim , base );
assert_equal ( [nsim,skip,leap] , [4096 4096 0] );
//
dim = 8;
base = 2;
[nsim,skip,leap] = lowdisc_niedersuggest ( dim , base , 10000 );
assert_equal ( [nsim,skip,leap] , [16384 4096 0] );
//
dim = 8;
base = 2;
[nsim,skip,leap] = lowdisc_niedersuggest ( dim , base , 30000 );
assert_equal ( [nsim,skip,leap] , [32768 4096 0] );
//
dim = 8;
base = 9;
[nsim,skip,leap] = lowdisc_niedersuggest ( dim , base , 50000 );
assert_equal ( [nsim,skip,leap] , [59049 6561 0] );

// Check that nsim >= nsimmin for several powers of 10
dim = 8;
base = 9;
for nsimmin = logspace(1,10,10)
  [nsim,skip,leap] = lowdisc_niedersuggest ( dim , base , nsimmin );
  assert_equal ( nsim >= nsimmin , %t );
end


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


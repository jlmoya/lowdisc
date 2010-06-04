// Copyright (C) 2008 - INRIA - Michael Baudin
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


//
// Check the configure/cget methods.
//
sequencearray = lowdisc_methods ();
for sequencename = sequencearray'
  lds = lowdisc_new(sequencename);
  //
  lds = lowdisc_configure(lds,"-dimension",12);
  nbdim = lowdisc_cget(lds,"-dimension");
  assert_equal ( nbdim , 12 );
  //
  i = lowdisc_get(lds,"-index");
  assert_equal ( i , 0 );
  //
  verbose = lowdisc_cget(lds,"-verbose");
  assert_equal ( verbose , %f );
  //
  lds = lowdisc_configure(lds,"-verbose",%T);
  verbose = lowdisc_cget(lds,"-verbose");
  assert_equal ( verbose , %T );
  //
  method = lowdisc_cget(lds,"-method");
  assert_equal ( method , sequencename );
  //
  lds = lowdisc_configure(lds,"-skip",12);
  skip = lowdisc_cget(lds,"-skip");
  assert_equal ( skip , 12 );
  //
  lds = lowdisc_configure(lds,"-leap",12);
  leap = lowdisc_cget(lds,"-leap");
  assert_equal ( leap , leap );
  //
  // Test printing system
  string(lds)
  lds
  lds.sequence
  lds = lowdisc_destroy(lds);
end


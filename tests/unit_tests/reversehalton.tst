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
// Check the Reverse Halton sequence
//
lds = lowdisc_new("reversehalton");
lds = lowdisc_configure(lds,"-dimension",2);
lds = lowdisc_startup (lds);
// Term #1
[lds,computed] = lowdisc_next (lds);
assert_close ( computed , [0.5 2./3.] , %eps );
// Terms #2 to #6
[lds,computed]=lowdisc_next(lds,5);
expected= [
    1./4. 1./3. 
    3./4. 2./9. 
    1./8. 8./9. 
    5./8. 5./9.
    3./8. 1./9. 
];
assert_close ( computed , expected , %eps );
lds = lowdisc_destroy(lds);

// test in dimension 2
lds = lowdisc_new("reversehalton");
lds = lowdisc_configure(lds,"-dimension",2);
lds = lowdisc_startup (lds);
[lds,computed] = lowdisc_next (lds);
[lds,computed] = lowdisc_next (lds);
[lds,computed] = lowdisc_next (lds);
// should be
// 0.5 0.666667
// 0.25 0.333333
// 0.75 0.222222
// 0.125 0.888889*/
assert_close ( computed, [3.0/4.0 2.0/9.0], 1.e-3 );
[lds,computed] = lowdisc_next (lds);
assert_close ( computed, [1.0/8.0 8.0/9.0], 1.e-3 );
lds = lowdisc_destroy(lds);


// test in dimension 3 */
lds = lowdisc_new("reversehalton");
lds = lowdisc_configure(lds,"-dimension",3);
lds = lowdisc_startup (lds);
[lds,computed] = lowdisc_next (lds);
[lds,computed] = lowdisc_next (lds);
[lds,computed] = lowdisc_next (lds);
assert_close ( computed, [0.75 2.0/9.0 0.4], 1.e-3 );
[lds,computed] = lowdisc_next (lds);
assert_close ( computed, [0.125 8.0/9.0 0.2], 1e-3 );
lds = lowdisc_destroy(lds);



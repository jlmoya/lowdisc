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
// Check the Niederreiter base 2 sequence
//
lds = ldnied2_new();
lds = ldnied2_configure(lds,"-dimension",2);
lds = ldnied2_startup (lds);
// Term #1
[lds,computed] = ldnied2_next (lds);
expected = [1./2. 1./2.];
assert_close ( computed, expected , 10 * %eps );
// Terms #2 to #5
[lds,computed]=ldnied2_next(lds,4);
expected= [
    3./4. 1./4. 
    1./4. 3./4. 
    3./8. 3./8. 
    7./8. 7./8. 
];
assert_close ( computed, expected , 10 * %eps );
lds = ldnied2_destroy(lds);



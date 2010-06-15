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

//
// Check the Sobol sequence in 4 dimensions
// tau=3, skip =2^(3+4-1)= 2^6=64
//
dim_num = 4;
lds = lowdisc_new("sobol");
lds = lowdisc_configure(lds,"-dimension",dim_num);
tau = lowdisc_soboltau ( dim_num );
assert_equal ( tau , 3 );
skip = 2^(tau + dim_num - 1);
lds = lowdisc_configure(lds,"-skip", skip);
lds = lowdisc_startup (lds);
[lds,computed]=lowdisc_next(lds,10);
expected= [
    0.5234375    0.8984375    0.9453125    0.3046875  
    0.7734375    0.1484375    0.6953125    0.5546875  
    0.2734375    0.6484375    0.1953125    0.0546875  
    0.3984375    0.0234375    0.8203125    0.9296875  
    0.8984375    0.5234375    0.3203125    0.4296875  
    0.6484375    0.2734375    0.0703125    0.6796875  
    0.1484375    0.7734375    0.5703125    0.1796875  
    0.2109375    0.2109375    0.1328125    0.4921875  
    0.7109375    0.7109375    0.6328125    0.9921875  
    0.9609375    0.4609375    0.8828125    0.2421875  
];
assert_close ( computed, expected, 10*%eps );
lds = lowdisc_destroy(lds);


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
// Check the Sobol sequence in 2 dimensions
//
rng = lowdisc_new();
rng = lowdisc_configure(rng,"-method","sobol");
rng = lowdisc_configure(rng,"-dimension",2);
rng = lowdisc_startup (rng);
// Term #1
[rng,computed] = lowdisc_next (rng);
expected = [0.5 0.5];
assert_close ( computed, expected, 10*%eps );
// Terms #2 to #6
[rng,computed]=lowdisc_terms(rng,5);
expected= [
    3./4. 1./4. 
    1./4. 3./4. 
    3./8. 3./8. 
    7./8. 7./8. 
    5./8. 1./8. 
];
assert_close ( computed, expected, 10*%eps );
rng = lowdisc_destroy(rng);
clear rng;

//
// Check the Sobol sequence in 4 dimensions
//
rng = lowdisc_new();
rng = lowdisc_configure(rng,"-method","sobol");
rng = lowdisc_configure(rng,"-dimension",4);
rng = lowdisc_startup (rng);
// Terms #1 to #11
[rng,computed]=lowdisc_terms(rng,11);
expected= [
   0.500000    0.500000    0.500000    0.500000  
   0.750000    0.250000    0.750000    0.250000  
   0.250000    0.750000    0.250000    0.750000  
   0.375000    0.375000    0.625000    0.125000  
   0.875000    0.875000    0.125000    0.625000  
   0.625000    0.125000    0.375000    0.375000  
   0.125000    0.625000    0.875000    0.875000  
   0.187500    0.312500    0.312500    0.687500  
   0.687500    0.812500    0.812500    0.187500  
   0.937500    0.062500    0.562500    0.937500  
   0.437500    0.562500    0.062500    0.437500  
];
assert_close ( computed, expected, 1.e-5 );
// Drop terms 12-94
[rng,computed]=lowdisc_terms(rng,94-12+1);
// Terms #95-110
[rng,computed]=lowdisc_terms(rng,110-95+1);
expected= [
   0.054688    0.929688    0.101562    0.960938  
   0.039062    0.132812    0.929688    0.351562  
   0.539062    0.632812    0.429688    0.851562  
   0.789062    0.382812    0.179688    0.101562  
   0.289062    0.882812    0.679688    0.601562  
   0.414062    0.257812    0.304688    0.476562  
   0.914062    0.757812    0.804688    0.976562  
   0.664062    0.007812    0.554688    0.226562  
   0.164062    0.507812    0.054688    0.726562  
   0.226562    0.445312    0.742188    0.914062  
   0.726562    0.945312    0.242188    0.414062  
   0.976562    0.195312    0.492188    0.664062  
   0.476562    0.695312    0.992188    0.164062  
   0.351562    0.070312    0.117188    0.789062  
   0.851562    0.570312    0.617188    0.289062  
   0.601562    0.320312    0.867188    0.539062  
];
assert_close ( computed, expected, 1.e-5 );
rng = lowdisc_destroy(rng);




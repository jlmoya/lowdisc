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
// Test the "hidden" API
dim = 4;
seed = 0;
computed = [];
// Skip first term
[ next , seed ] = _lowdisc_sobolf ( dim , seed );
for i = 1 : 11;
  [ next , seed ] = _lowdisc_sobolf ( dim , seed );
  computed(i,1:dim) = next;
end
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
assert_close ( computed , expected , %eps );

//
// Check the Fast Sobol sequence
//
rng = lowdisc_new();
rng = lowdisc_configure(rng,"-method","sobolf");
rng = lowdisc_configure(rng,"-dimension",2);
rng = lowdisc_startup (rng);
// Term #1
[rng,computed] = lowdisc_next (rng);
expected = [0.5 0.5];
assert_close ( computed, expected, 10*%eps );
// Terms #2 to #6
[rng,computed]=lowdisc_next(rng,5);
expected= [
    3./4. 1./4. 
    1./4. 3./4.    
    3./8. 3./8. 
    7./8. 7./8. 
    5./8. 1./8. 
];
assert_close ( computed, expected, 10*%eps );
rng = lowdisc_destroy(rng);

//
// test Fast Sobol in dimension 2 
rng = lowdisc_new();
rng = lowdisc_configure(rng,"-method","sobolf");
rng = lowdisc_configure(rng,"-dimension",2);
rng = lowdisc_startup (rng);
[rng,computed] = lowdisc_next (rng);
[rng,computed] = lowdisc_next (rng);
[rng,computed] = lowdisc_next (rng);
expected = [0.25 0.75];
assert_close ( computed, expected, 10*%eps );
[rng,computed] = lowdisc_next (rng);
expected = [0.375 0.375];
assert_close ( computed, expected, 10*%eps );
rng = lowdisc_destroy(rng);


// test in dimension 3
rng = lowdisc_new();
rng = lowdisc_configure(rng,"-method","sobolf");
rng = lowdisc_configure(rng,"-dimension",3);
rng = lowdisc_startup (rng);
[rng,computed] = lowdisc_next (rng);
[rng,computed] = lowdisc_next (rng);
[rng,computed] = lowdisc_next (rng);
expected = [0.25 0.75 0.25];
assert_close ( computed, expected, 10*%eps );
[rng,computed] = lowdisc_next (rng);
expected = [0.375 0.375 0.625];
assert_close ( computed, expected, 10*%eps );
rng = lowdisc_reset (rng);
[rng,computed] = lowdisc_next (rng);
[rng,computed] = lowdisc_next (rng);
[rng,computed] = lowdisc_next (rng);
expected = [0.25 0.75 0.25];
assert_close ( computed, expected, 10*%eps );
[rng,computed] = lowdisc_next (rng);
expected = [0.375 0.375 0.625];
assert_close ( computed, expected, 10*%eps );
rng = lowdisc_destroy(rng);

//
// Check the result against TOMS 647 data
//
rng = lowdisc_new();
rng = lowdisc_configure(rng,"-method","sobolf");
rng = lowdisc_configure(rng,"-dimension",4);
rng = lowdisc_startup (rng);
[rng,computed]=lowdisc_next(rng,100);
expected = [
0.500000      0.500000      0.500000      0.500000
0.750000      0.250000      0.750000      0.250000
0.250000      0.750000      0.250000      0.750000
0.375000      0.375000      0.625000      0.125000
0.875000      0.875000      0.125000      0.625000
0.625000      0.125000      0.375000      0.375000
0.125000      0.625000      0.875000      0.875000
0.187500      0.312500      0.312500      0.687500
0.687500      0.812500      0.812500      0.187500
0.937500      0.062500      0.562500      0.937500
0.437500      0.562500      0.062500      0.437500
0.312500      0.187500      0.937500      0.562500
0.812500      0.687500      0.437500      0.062500
0.562500      0.437500      0.187500      0.812500
0.062500      0.937500      0.687500      0.312500
0.093750      0.468750      0.843750      0.406250
0.593750      0.968750      0.343750      0.906250
0.843750      0.218750      0.093750      0.156250
0.343750      0.718750      0.593750      0.656250
0.468750      0.093750      0.468750      0.281250
0.968750      0.593750      0.968750      0.781250
0.718750      0.343750      0.718750      0.031250
0.218750      0.843750      0.218750      0.531250
0.156250      0.156250      0.531250      0.843750
0.656250      0.656250      0.031250      0.343750
0.906250      0.406250      0.281250      0.593750
0.406250      0.906250      0.781250      0.093750
0.281250      0.281250      0.156250      0.968750
0.781250      0.781250      0.656250      0.468750
0.531250      0.031250      0.906250      0.718750
0.031250      0.531250      0.406250      0.218750
0.046875      0.265625      0.609375      0.578125
0.546875      0.765625      0.109375      0.078125
0.796875      0.015625      0.359375      0.828125
0.296875      0.515625      0.859375      0.328125
0.421875      0.140625      0.234375      0.703125
0.921875      0.640625      0.734375      0.203125
0.671875      0.390625      0.984375      0.953125
0.171875      0.890625      0.484375      0.453125
0.234375      0.078125      0.796875      0.140625
0.734375      0.578125      0.296875      0.640625
0.984375      0.328125      0.046875      0.390625
0.484375      0.828125      0.546875      0.890625
0.359375      0.453125      0.421875      0.015625
0.859375      0.953125      0.921875      0.515625
0.609375      0.203125      0.671875      0.265625
0.109375      0.703125      0.171875      0.765625
0.078125      0.234375      0.265625      0.984375
0.578125      0.734375      0.765625      0.484375
0.828125      0.484375      0.515625      0.734375
0.328125      0.984375      0.015625      0.234375
0.453125      0.359375      0.890625      0.859375
0.953125      0.859375      0.390625      0.359375
0.703125      0.109375      0.140625      0.609375
0.203125      0.609375      0.640625      0.109375
0.140625      0.421875      0.078125      0.296875
0.640625      0.921875      0.578125      0.796875
0.890625      0.171875      0.828125      0.046875
0.390625      0.671875      0.328125      0.546875
0.265625      0.046875      0.703125      0.421875
0.765625      0.546875      0.203125      0.921875
0.515625      0.296875      0.453125      0.171875
0.015625      0.796875      0.953125      0.671875
0.023438      0.398438      0.445312      0.804688
0.523438      0.898438      0.945312      0.304688
0.773438      0.148438      0.695312      0.554688
0.273438      0.648438      0.195312      0.054688
0.398438      0.023438      0.820312      0.929688
0.898438      0.523438      0.320312      0.429688
0.648438      0.273438      0.070313      0.679688
0.148438      0.773438      0.570312      0.179688
0.210938      0.210938      0.132812      0.492188
0.710938      0.710938      0.632812      0.992188
0.960938      0.460938      0.882812      0.242188
0.460938      0.960938      0.382812      0.742188
0.335938      0.335938      0.507812      0.367188
0.835938      0.835938      0.007813      0.867188
0.585938      0.085938      0.257812      0.117188
0.085938      0.585938      0.757812      0.617188
0.117188      0.117188      0.664062      0.648438
0.617188      0.617188      0.164062      0.148438
0.867188      0.367188      0.414062      0.898438
0.367188      0.867188      0.914062      0.398438
0.492188      0.492188      0.039063      0.523438
0.992188      0.992188      0.539062      0.023438
0.742188      0.242188      0.789062      0.773438
0.242188      0.742188      0.289062      0.273438
0.179688      0.304688      0.976562      0.085938
0.679688      0.804688      0.476562      0.585938
0.929688      0.054688      0.226562      0.335938
0.429688      0.554688      0.726562      0.835938
0.304688      0.179688      0.351562      0.210938
0.804688      0.679688      0.851562      0.710938
0.554688      0.429688      0.601562      0.460938
0.054688      0.929688      0.101562      0.960938
0.039063      0.132812      0.929688      0.351562
0.539062      0.632812      0.429688      0.851562
0.789062      0.382812      0.179688      0.101562
0.289062      0.882812      0.679688      0.601562
0.414062      0.257812      0.304688      0.476562
];
assert_close ( computed , expected , 1.e-5 );
rng = lowdisc_destroy(rng);


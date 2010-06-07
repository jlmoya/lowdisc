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
// Test the "hidden" API
//
start = _lowdisc_sobolfisstart ( );
assert_equal ( start , 0 );
dim = 4;
seed = 0;
_lowdisc_sobolfstart ( dim );
start = _lowdisc_sobolfisstart ( );
assert_equal ( start , 1 );
dim2 = _lowdisc_sobolfdimget( );
assert_equal ( dim2 , dim );
computed = [];
// Skip first term
next = _lowdisc_sobolfnext ( 0 );
for i = 1 : 11;
  next = _lowdisc_sobolfnext ( i );
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
_lowdisc_sobolfstop ( );
start = _lowdisc_sobolfisstart ( );
assert_equal ( start , 0 );

//
// Test the "hidden" API.
// Get elements 0,1,2,3 then 5,6,7, then 1,2,3
// i.e. pick arbitrary experiments in the sequence.
//
dim = 4;
seed = 0;
_lowdisc_sobolfstart ( dim );
scenario = [0 1 2 3 5 6 7 1 2 3];
computed = [];
for k = 1 : size(scenario,"*")
  seed = scenario(k);
  computed(k,1:dim) = _lowdisc_sobolfnext ( seed );
end
expected= [
   0.          0.          0.          0.      
   0.500000    0.500000    0.500000    0.500000  
   0.750000    0.250000    0.750000    0.250000  
   0.250000    0.750000    0.250000    0.750000  
   0.875000    0.875000    0.125000    0.625000  
   0.625000    0.125000    0.375000    0.375000  
   0.125000    0.625000    0.875000    0.875000  
   0.500000    0.500000    0.500000    0.500000  
   0.750000    0.250000    0.750000    0.250000  
   0.250000    0.750000    0.250000    0.750000  
];
assert_close ( computed , expected , %eps );
_lowdisc_sobolfstop ( );



// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2011 - DIGITEO - Michael Baudin

//
// This file must be used under the terms of the GNU LGPL license.
// 

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

//
// Test the "hidden" API
//
start = _lowdisc_sobolfisstart ( );
assert_checkequal ( start , 0 );
dim = 4;
seed = 0;
_lowdisc_sobolfstart ( dim );
start = _lowdisc_sobolfisstart ( );
assert_checkequal ( start , 1 );
dim2 = _lowdisc_sobolfdimget( );
assert_checkequal ( dim2 , dim );
computed = [];
imax = 1;
leap = 0;
// Skip first term
next = _lowdisc_sobolfnext ( 0 , imax, leap);
for i = 1 : 11;
  next = _lowdisc_sobolfnext ( i , imax, leap);
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
assert_checkalmostequal ( computed , expected , %eps );
_lowdisc_sobolfstop ( );
start = _lowdisc_sobolfisstart ( );
assert_checkequal ( start , 0 );

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
imax = 1;
leap = 0;
for k = 1 : size(scenario,"*")
  seed = scenario(k);
  computed(k,1:dim) = _lowdisc_sobolfnext ( seed , imax, leap );
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
assert_checkalmostequal ( computed , expected , %eps );
_lowdisc_sobolfstop ( );


//
// Test the "hidden" API.
// Get elements 0,1,...,7 in one single call.
// Test imax.
//
dim = 4;
seed = 0;
_lowdisc_sobolfstart ( dim );
imax = 8;
leap = 0;
computed = _lowdisc_sobolfnext ( seed , imax, leap );
expected= [
    0.       0.       0.       0.     
    0.5      0.5      0.5      0.5    
    0.75     0.25     0.75     0.25   
    0.25     0.75     0.25     0.75   
    0.375    0.375    0.625    0.125  
    0.875    0.875    0.125    0.625  
    0.625    0.125    0.375    0.375  
    0.125    0.625    0.875    0.875  
];
assert_checkalmostequal ( computed , expected , %eps );
_lowdisc_sobolfstop ( );


//
// Test the "hidden" API.
// Get elements 0,2,4,6 in one single call.
// Test leap.
//
dim = 4;
seed = 0;
_lowdisc_sobolfstart ( dim );
imax = 4;
leap = 1;
computed = _lowdisc_sobolfnext ( seed , imax, leap );
expected= [
    0.       0.       0.       0.     
    0.75     0.25     0.75     0.25   
    0.375    0.375    0.625    0.125  
    0.625    0.125    0.375    0.375  
];
assert_checkalmostequal ( computed , expected , %eps );
_lowdisc_sobolfstop ( );



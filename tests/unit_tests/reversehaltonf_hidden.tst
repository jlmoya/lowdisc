// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2011 - DIGITEO - Michael Baudin

//
// This file must be used under the terms of the GNU LGPL license.
// 

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

//
// Test "hidden" Reverse Halton API
//
start = _lowdisc_revhaltfisstart ( );
assert_checkequal ( start , 0 );
dim = 2;
primelist = number_primes100();
_lowdisc_revhaltfstart ( dim , primelist(1:dim) );
start = _lowdisc_revhaltfisstart ( );
assert_checkequal ( start , 1 );
dim2 = _lowdisc_revhaltfdimget ( );
assert_checkequal ( dim , dim2 );
prime2 = _lowdisc_revhaltfbaseget ( );
assert_checkequal ( primelist(1:dim) , prime2 );
computed = [];
imax = 1;
leap = 0;
for i = 1 : 6
  computed(i,1:dim) = _lowdisc_revhaltfnext ( i , imax, leap);
end
expected= [
    0.5 2./3.
    1./4. 1./3. 
    3./4. 2./9.    
    1./8. 8./9. 
    5./8. 5./9. 
    3./8. 1./9. 
];
assert_checkalmostequal ( computed, expected , 10 * %eps );
_lowdisc_revhaltfstop ( );
start = _lowdisc_revhaltfisstart ( );
assert_checkequal ( start , 0 );


//
// Test the "hidden" API.
// Get elements 0,1,2,3 then 5,6,7, then 1,2,3
// i.e. pick arbitrary experiments in the sequence.
//
dim = 4;
primelist = number_primes100();
_lowdisc_revhaltfstart ( dim , primelist(1:dim) );
scenario = [0 1 2 3 5 6 7 1 2 3];
computed = [];
imax = 1;
leap = 0;
for k = 1 : size(scenario,"*")
  seed = scenario(k);
  computed(k,1:dim) = _lowdisc_revhaltfnext ( seed , imax, leap);
end
expected= [
    0.                     0.                     0.                     0.      
    0.5       0.6666667    0.8     0.8571429  
    0.25      0.3333333    0.6     0.7142857  
    0.75      0.2222222    0.4     0.5714286  
    0.625     0.5555556    0.16    0.2857143  
    0.375     0.1111111    0.96    0.1428571  
    0.875     0.7777778    0.76    0.1224490  
    0.5       0.6666667    0.8     0.8571429  
    0.25      0.3333333    0.6     0.7142857  
    0.75      0.2222222    0.4     0.5714286  
];
assert_checkalmostequal ( computed , expected , [], 1.e-7 );
_lowdisc_revhaltfstop ( );


//
// Test the "hidden" API.
// Get elements 0,1,..., 7 in one single call.
//
dim = 4;
primelist = number_primes100();
_lowdisc_revhaltfstart ( dim , primelist(1:dim) );
computed = [];
imax = 8;
leap = 0;
computed = _lowdisc_revhaltfnext ( 0 , imax, leap);
expected= [
    0.       0.           0.      0.         
    0.5      0.6666667    0.8     0.8571429  
    0.25     0.3333333    0.6     0.7142857  
    0.75     0.2222222    0.4     0.5714286  
    0.125    0.8888889    0.2     0.4285714  
    0.625    0.5555556    0.16    0.2857143  
    0.375    0.1111111    0.96    0.1428571  
    0.875    0.7777778    0.76    0.1224490  
];
assert_checkalmostequal ( computed , expected , [], 1.e-7 );
_lowdisc_revhaltfstop ( );


//
// Test the "hidden" API.
// Get elements 0,1,..., 7 in one single call.
// Test leap.
//
dim = 4;
primelist = number_primes100();
_lowdisc_revhaltfstart ( dim , primelist(1:dim) );
computed = [];
imax = 4;
leap = 1;
computed = _lowdisc_revhaltfnext ( 0 , imax, leap);
expected= [
    0.       0.           0.      0.         
    0.25     0.3333333    0.6     0.7142857  
    0.125    0.8888889    0.2     0.4285714  
    0.375    0.1111111    0.96    0.1428571  
];
assert_checkalmostequal ( computed , expected , [], 1.e-7 );
_lowdisc_revhaltfstop ( );



// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2010 - DIGITEO - Michael Baudin

//
// This file must be used under the terms of the GNU LGPL license.
// 

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

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
// Test the "hidden" Fast Faure API in dimension 3
//
dim = 3;
computed = [];
start = _lowdisc_faurefisstart ( );
assert_equal ( start , 0 );
// Skip first term
_lowdisc_faurefstart ( dim );
dim2 = _lowdisc_faurefdimget ( );
assert_equal ( dim2 , dim );
start = _lowdisc_faurefisstart ( );
assert_equal ( start , 1 );
qs = _lowdisc_faurefbaseget ( );
assert_equal ( qs , 3 );
next = _lowdisc_faurefnext ( 0 );
for i = 1 : 8
  next = _lowdisc_faurefnext ( i );
  computed(i,1:dim) = next;
end
expected= [
    1/3 1/3 1/3
    2/3 2/3 2/3 
    1/9 4/9 7/9 
    4/9 7/9 1/9 
    7/9 1/9 4/9 
    2/9 8/9 5/9 
    5/9 2/9 8/9 
    8/9 5/9 2/9
];
assert_close ( computed, expected, %eps );
_lowdisc_faurefstop ( );
start = _lowdisc_faurefisstart ( );
assert_equal ( start , 0 );

//
// Test the "hidden" Fast Faure API in dimension 4
//
dim = 4;
computed = [];
_lowdisc_faurefstart ( dim );
qs = _lowdisc_faurefbaseget ( );
assert_equal ( qs , 5 );
// Skip first term
next = _lowdisc_faurefnext ( 0 );
for i = 1 : 8
  next = _lowdisc_faurefnext ( i );
  computed(i,1:dim) = next;
end
expected= [
    0.2                    0.2                    0.2                    0.2                  
    0.4                    0.4                    0.4                    0.4                  
    0.6                    0.6                    0.6                    0.6
    0.8                    0.8                    0.8                    0.8                  
    0.04                   0.24                   0.44                   0.64 
    0.24                   0.44                   0.64                   0.84
    0.44                   0.64                   0.84                   0.04                 
    0.64                   0.84                   0.04                   0.24
];
assert_close ( computed, expected, %eps );
_lowdisc_faurefstop ( );


//
// Test the "hidden" API.
// Get elements 0,1,2,3 then 5,6,7, then 1,2,3
// i.e. pick arbitrary experiments in the sequence.
//
dim = 4;
_lowdisc_faurefstart ( dim );
scenario = [0 1 2 3 5 6 7 1 2 3];
computed = [];
for k = 1 : size(scenario,"*")
  seed = scenario(k);
  computed(k,1:dim) = _lowdisc_faurefnext ( seed );
end
expected= [
    0.                     0.                     0.                     0.      
    0.2                    0.2                    0.2                    0.2                  
    0.4                    0.4                    0.4                    0.4                  
    0.6                    0.6                    0.6                    0.6
    0.04                   0.24                   0.44                   0.64 
    0.24                   0.44                   0.64                   0.84
    0.44                   0.64                   0.84                   0.04                 
    0.2                    0.2                    0.2                    0.2                  
    0.4                    0.4                    0.4                    0.4                  
    0.6                    0.6                    0.6                    0.6
];
assert_close ( computed , expected , %eps );
_lowdisc_faurefstop ( );

//
// Test the "hidden" Fast Faure API in dimension 2000
//
dim = 2000;
primelist = lowdisc_primes10000();
k = find(primelist>dim,1);
qs = primelist(k);
_lowdisc_faurefstart ( dim , qs );
qs2 = _lowdisc_faurefbaseget ( );
assert_equal ( qs , qs2 );
next = _lowdisc_faurefnext ( 0 );
assert_equal ( size(next) , [1 dim] );
_lowdisc_faurefstop ( );



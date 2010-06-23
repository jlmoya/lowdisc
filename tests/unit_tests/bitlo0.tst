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
  if ( and ( computed==expected ) ) then
    flag = 1;
  else
    flag = 0;
  end
  if flag <> 1 then pause,end
endfunction

//
// Check the bitlo0 function
//
computed = [];
ilist =  [
  22
  96
  83
  56
  41
  6
  26
  11
  4
  64
]
expected =  [
  1
  1
  3
  1
  2
  1
  1
  3
  1
  1
];
for i = 1:size(ilist,"*")
  j = ilist(i);
  computed($+1) = lowdisc_bitlo0 ( j );
end
assert_equal ( computed , expected );

// Reproduce the test from the help
// Column #1 : n
// Column #2 : bitlo0(n)
expected = [
   0  1
   1  2
   2  1
   3  3 
   4  1
   5  2
   6  1
   7  4
   8  1
   9  2
  10  1
  11  3
  12  1
  13  2
  14  1
  15  5
  16  1
  17  2
1023 11
1024  1
1025  2
];
computed = [];
for i = 1:size(expected,"r")
  j = expected(i,1);
  computed($+1) = lowdisc_bitlo0 ( j );
end
assert_equal ( computed , expected(:,2) );


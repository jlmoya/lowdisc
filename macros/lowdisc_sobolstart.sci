// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
// Copyright (C) 2005-2009 - John Burkardt
// Copyright (C) 1986 - Bennett Fox

// This file must be used under the terms of the GNU LGPL license.

function [ v , maxcol , lastq , count , recipd ] = lowdisc_sobolstart ( dim_num )
  // Initialize the Sobol sequence.
  //
  // Calling Sequence
  //   [ v , maxcol , lastq , count , recipd ] = lowdisc_sobolstart ( dim_num )
  // 
  // Parameters
  //   dim_num : a 1 x 1 matrix of floating point integers, the current number of dimensions. We expect to have 1<= dim_num<= 40, since no more that 40 polynomials are stored in the database.
  //   v : a dimmax x logmax matrix of floating point integers, table of direction numbers. We have dimmax = 40 and logmax = 30. Each row corresponds to a primitive polynomial. The numbers in v are actually binary fractions.
  //   maxcol : a 1 x 1 matrix of floating point integers, number of bits in atmost
  //   lastq : a dim_num x 1 matrix of floating point integers, the numerators of the last vector generated
  //   count : a 1 x 1 matrix of floating point integers, the index of the element in the sequence
  //   recipd : (1/denominator) for the numerators lastq
  //
  // Description
  //   Returns the initial data for use in a Sobol sequence.
  //
  //   In the algorithm, the variable atmost is the maximum number of calls to the generator.
  //   We have atmost = 2^logmax - 1 with logmax = 30.
  //   This leads to atmost = 1.074 x 10^9.
  //
  //   This routine is designed to be used with the lowdisc_sobolnext() and lowdisc_sobolskip()
  //   functions.
  //
  // Authors
  //   Michael Baudin - 2008-2009 - INRIA
  //   Michael Baudin - 2010 - DIGITEO
  
  dimmax = 40
  logmax = 30
  //
  //  Initialize (part of) V.
  //
  v(1:dimmax,1:logmax) = zeros(dimmax,logmax)
  v(1:40,1) = [ ...
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ]'
  v(3:40,2) = [ ...
  1, 3, 1, 3, 1, 3, 3, 1, ...
  3, 1, 3, 1, 3, 1, 1, 3, 1, 3, ...
  1, 3, 1, 3, 3, 1, 3, 1, 3, 1, ...
  3, 1, 1, 3, 1, 3, 1, 3, 1, 3 ]'
  v(4:40,3) = [ ...
  7, 5, 1, 3, 3, 7, 5, ...
  5, 7, 7, 1, 3, 3, 7, 5, 1, 1, ...
  5, 3, 3, 1, 7, 5, 1, 3, 3, 7, ...
  5, 1, 1, 5, 7, 7, 5, 1, 3, 3 ]'
  v(6:40,4) = [ ...
  1, 7, 9,13,11, ...
  1, 3, 7, 9, 5,13,13,11, 3,15, ...
  5, 3,15, 7, 9,13, 9, 1,11, 7, ...
  5,15, 1,15,11, 5, 3, 1, 7, 9 ]'
  v(8:40,5) = [ ...
  9, 3,27, ...
  15,29,21,23,19,11,25, 7,13,17, ...
  1,25,29, 3,31,11, 5,23,27,19, ...
  21, 5, 1,17,13, 7,15, 9,31, 9 ]'
  v(14:40,6) = [ ...
  37,33, 7, 5,11,39,63, ...
  27,17,15,23,29, 3,21,13,31,25, ...
  9,49,33,19,29,11,19,27,15,25 ]'
  v(20:40,7) = [ ...
  13, ...
  33,115, 41, 79, 17, 29,119, 75, 73,105, ...
  7, 59, 65, 21,  3,113, 61, 89, 45,107 ]'
  v(38:40,8) = [ ...
  7, 23, 39 ]'
  //
  //  Set POLY.
  //
  spoly(1:40)= [ ...
  1,   3,   7,  11,  13,  19,  25,  37,  59,  47, ...
  61,  55,  41,  67,  97,  91, 109, 103, 115, 131, ...
  193, 137, 145, 143, 241, 157, 185, 167, 229, 171, ...
  213, 191, 253, 203, 211, 239, 247, 285, 369, 299 ]
  //
  atmost = 2^logmax - 1
  //
  //  Find the number of bits in ATMOST.
  //
  maxcol = lowdisc_bithi1 ( atmost )
  //
  //  Initialize row 1 of V.
  //
  v(1,1:maxcol) = 1
  //
  //  Initialize the remaining rows of V.
  //
  for i = 2 : dim_num
    //
    //  The bit pattern of the integer POLY(I) gives the form
    //  of polynomial I.
    //
    //  Find the degree of polynomial I from binary encoding.
    //
    j = spoly(i)
    m = 0
    while ( 1 )
      j = floor ( j / 2 )
      if ( j <= 0 )
        break
      end
      m = m + 1
    end
    //
    //  We expand this bit pattern to separate components of the logical array INCLUD.
    //
    j = spoly(i)
    for k = m : -1 : 1
      j2 = floor ( j / 2 )
      includ(k) = ( j ~= 2 * j2 )
      j = j2
    end
    //
    //  Calculate the remaining elements of row I as explained
    //  in Bratley and Fox, section 2.
    //
    for j = m + 1 : maxcol
      newv = v(i,j-m)
      l = 1
      for k = 1 : m
        l = 2 * l
        if ( includ(k) )
          newv = lowdisc_bitxor ( newv, l * v(i,j-k) )
        end
      end
      v(i,j) = newv
    end
  end
  //
  //  Multiply columns of V by appropriate power of 2.
  //
  l = 1
  for j = maxcol-1 : -1 : 1
    l = 2 * l
    v(1:dim_num,j) = v(1:dim_num,j) * l
  end
  //
  //  RECIPD is 1/(common denominator of the elements in V).
  //
  recipd = 1.0 / ( 2 * l )
  //
  //     SET UP FIRST VECTOR AND VALUES FOR "GOSOBL"
  //
  count = 0
  lastq(1:dim_num) = 0
endfunction


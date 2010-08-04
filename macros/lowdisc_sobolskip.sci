// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
// Copyright (C) 2005-2009 - John Burkardt
// Copyright (C) 1986 - Bennett Fox

// This file must be used under the terms of the GNU LGPL license.

function [ count , lastq ] = lowdisc_sobolskip ( skip , lastq , dim_num , count , v )
  // Skip elements in the Sobol sequence.
  //
  // Parameters
  //   skip : a 1 x 1 matrix of floating point integers, the number of elements to discard
  //   dim_num : a 1 x 1 matrix of floating point integers, the number of dimensions
  //   lastq : a dim_num x 1 matrix of floating point integers, the numerators of the last vector generated
  //   count : a 1 x 1 matrix of floating point integers, the index of the element in the sequence
  // 
  // Description
  //   The only difference with lowdisc_sobolnext is that we do not generate the 
  //   vector quasi.
  //
  //   This routine is designed to be used with the lowdisc_sobolnext() and lowdisc_sobolstart()
  //   functions.
  //
  // Authors
  //   Michael Baudin - 2008-2009 - INRIA
  //   Michael Baudin - 2010 - DIGITEO

  for i = 1 : skip
    l = lowdisc_bitlo0 ( count )
    lastq = lowdisc_bitxor ( lastq, v(1 : dim_num,l) )
    count = count + 1
  end
endfunction


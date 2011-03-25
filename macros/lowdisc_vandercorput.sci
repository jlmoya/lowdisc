// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function result = lowdisc_vandercorput ( i , basis )
  //   Returns the i-th term of the Van Der Corput sequence.
  //
  // Calling Sequence
  //   result = lowdisc_vandercorput ( i , basis )
  //
  // Parameters
  //   i : a 1 x 1 matrix of floating point integers, the index in the sequence
  //   basis : a 1 x 1 matrix of floating point integers, the basis of the sequence
  //   result : a 1 x 1 matrix of floating point doubles, the next element in the sequence, in the [0,1) interval
  //
  // Description
  // This function allows to compute the terms of the Van Der Corput sequence.
  // The current index i is decomposed in the basis as :
  // i = d0 b^0 + d1 b^1 + d2 b^2 + ... + dn b^n
  // with dn the last digit in the decomposition and b the basis.
  // The result is computed by reversing the digits and scaling by b^n :
  // r = d0 b^-1 + d1 b^-2 + ... + dn b^(-n-1)
  // Example : i = 11 or 1010 in binary because 
  // 11 = 1 * 2^3 + 0 * 2^2 + 1 * 2^1 + 0 * 2^0.
  // Therefore d0 = 0, d1 = 1, d2 = 0, d3 = 1.
  // Then r = 0 * 2^-1 + 1 * 2^-2 + 0 * 2^-3 + 1 * 2^-4 = 5/16.
  //
  // The digits of i are computed with an incremental process, by
  // using the remainder modulo b and dividing by b.
  // The digits are therefore computed in the order : d0, d1,..., dn.
  // The result r is initialized with value 0.
  // As they are computed, the terms di*b^(-i-1) are added to the
  // result r.
  //
  // The terms ib = b^(-i-1), called inversed basis (or inverse radix in 
  // Halton & Smith 1964 paper) are computed incrementally.
  // The inversed basis ib is initialized with value 1/b = b^-1.
  // It is updated by division by basis.
  //
  // This algorithm is also explained in :
  //   http://orion.math.iastate.edu/reu/2001/voronoi/halton_sequence.html
  // and used in :
  //   https://people.scs.fsu.edu/~burkardt/m_src/van_der_corput/van_der_corput.html
  //
  // Examples
  // // See the algorithm
  // edit lowdisc_vandercorput
  //
  // lowdisc_vandercorput ( 0 , 2 ) // 0.0
  // lowdisc_vandercorput ( 1 , 2 ) // 0.5
  // lowdisc_vandercorput ( 2 , 2 ) // 0.25
  // lowdisc_vandercorput ( 3 , 2 ) // 0.75
  // lowdisc_vandercorput ( 4 , 2 ) // 0.125
  // lowdisc_vandercorput ( 5 , 2 ) // 0.625
  //
  // // See the terms 0 to 10 in base 2.
  // for i = 0 : 10
  //   s(i+1) = lowdisc_vandercorput ( i , 2 );
  // end
  // disp(s')
  //
  // // See the terms 0 to 10 in base 3.
  // for i = 0 : 10
  //   s(i+1) = lowdisc_vandercorput ( i , 3 );
  // end
  // disp(s')
  //
  // // Plot the terms 0 to 2^7 in base 2
  // for i = 0 : 2^7
  //   s = lowdisc_vandercorput ( i , 2 );
  //   plot ( s , i , "bo" ) ;
  // end
  //
  // Authors
  //   Michael Baudin - 2008-2009 - INRIA
  //   Michael Baudin - 2010 - DIGITEO
  //
  // Bibliography
  //    "Algorithm 247: Radical-Inverse Quasi-Random Point Sequence", J H Halton and G B Smith, Communications of the ACM, Volume 7, 1964, pages 701-702.
  
  if (basis<2) then
    errmsg = msprintf ( gettext ( "%s: Unexpected basis" ) , "_vdc" , basis)
    error(errmsg)
  end
  current = i
  ib = 1.0 / basis
  result = 0.0
  while (current>0)
    digit = modulo ( current , basis )
    current = int ( current / basis )
    result = result + digit * ib
    ib = ib / basis
  end
endfunction


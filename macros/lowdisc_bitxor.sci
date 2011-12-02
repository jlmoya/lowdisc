// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 1995 - Dave Mellinger
//
// This file must be used under the terms of the GNU LGPL license.

function y = lowdisc_bitxor ( x1 , x2 ) 
  //  Bitwise logical XOR operator.
  // 
  // Calling Sequence
  //   y = bitxor ( x1 , x2 ) 
  //
  // Parameters
  //   x1 : a n-by-1 matrix of floating point integers
  //   x2 : a n-by-1 matrix of floating point integers
  //   y : a n-by-1 matrix of floating point integers
  //
  // Description
  // Return the bitwise XOR of x1 and x2.  This is the value that has 1 bits 
  // at positions where x1 and x2, but not both, have 1 bits.  Does not work 
  // when one of the numbers is negative. 
  // 
  // Note that this routine will work only up to 32 bits, or to the precision 
  // of your machine's double-precision float representation, whichever 
  // is smaller. 
  // 
  // This routine is vectorized, i.e. it does take a column matrix n as input argument.
  //
  // Examples
  //
  // // Compute xor for several pairs of integers.
  // // In base-2, 86 = [1 0 1 0 1 1 0]'
  // lowdisc_bary ( 86 , 2 )
  // // In base-2, 19 = [1 0 0 1 1]'
  // lowdisc_bary ( 19 , 2 )
  // // The xor of [1 0 1 0 1 1 0]' 
  // //        and     [1 0 0 1 1]' 
  // //         is [1 0 0 0 1 0 1]'
  // // The decimal value of [1 0 0 0 1 0 1]' is 69.
  // y = lowdisc_bitxor ( 86 , 19 )
  //
  // // Compute xor for several pairs of integers.
  // mprintf("%5s %5s %15s %15s %15s %5s\n",...
  //    "x1","x2","x1 - Binary", "x2 - Binary", "xor - Binary" , ...
  //    "xor - Decimal");
  // mprintf("-------------------------------------\n");
  // x12 = [
  //     86     19     
  //     90     31     
  //     32     48     
  //      4     22     
  //     41     36     
  //     55     71    
  //     77     77      
  //     37     57     
  //    100      8    
  //    99     76
  // ];
  // for i = 1 : 10
  //   y = lowdisc_bitxor ( x12(i,1) , x12(i,2) );
  //   d1 = lowdisc_bary ( x12(i,1) , 2 );
  //   d2 = lowdisc_bary ( x12(i,2) , 2 );
  //   d3 = lowdisc_bary ( y , 2 );
  //   mprintf("%5d %5d %15s %15s %15s %5d\n",...
  //     x12(i,1),x12(i,2),strcat(string(d1)," "),..
  //     strcat(string(d2)," "),strcat(string(d3)," "),y);
  // end
  //
  // // This function is vectorized.
  // y = lowdisc_bitxor ( x12(:,1) , x12(:,2) )
  //
  // Authors
  //   Dave Mellinger - 27 May 1995
  //   Michael Baudin - 2010 - 2011 - DIGITEO
  //

  x1 = x1(:)
  x2 = x2(:)
  bit_vals = 2 .^ (0:31) 
  invbv = 1 ./ bit_vals
  p1 = pmodulo ( floor ( x1 * invbv ) , 2) 
  p2 = pmodulo ( floor ( x2 * invbv ) , 2) 
  y = sum(pmodulo(p1 + p2, 2) * diag(bit_vals),"c")
endfunction


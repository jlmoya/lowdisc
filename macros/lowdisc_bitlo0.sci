// Copyright (C) 2010 - DIGITEO - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2005 - John Burkardt
//
// This file must be used under the terms of the GNU LGPL license.

function bit = lowdisc_bitlo0 ( n )
  // Returns the position of the low 0 bit base 2 in an integer.
  //
  // Calling Sequence
  //   bit = lowdisc_bitlo0 ( n )
  //
  // Parameters
  //    n : the integer to be measured, should be nonnegative.
  //    bit : the position of the low 0 bit.
  //
  //  Description
  //    This routine is not vectorized, i.e. it does not take a column matrix n as input argument, but only
  //    a 1 x 1 matrix.
  //
  //  Examples
  //  // n = 11 is equal to "1 0 1 1" in binary
  //  d = lowdisc_bary ( 11 , 2 )'
  //  // Hence, the low 0 bit is 3 
  //  // i.e., from the right, the first zero is at index 3.
  //  bit = lowdisc_bitlo0 ( 11 )
  //
  //  // Compute the low 0 bit for several integers
  //  mprintf("%5s %25s %5s\n","N","Binary","bit");
  //  mprintf("-------------------------------------\n");
  //  nmat =  [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 1023 1024 1025];
  //  for n = nmat
  //    bit = lowdisc_bitlo0 ( n );
  //    d = lowdisc_bary ( n , 2 );
  //    mprintf("%5d %25s %5d\n",n,strcat(string(d)," "),bit);
  //  end
  //
  //  Author:
  //    2005 - John Burkardt
  //    2009 - Digiteo - Michael Baudin (Scilab version)
  //
  
  bit = 0
  i = floor ( n )
  while ( 1 )
    bit = bit + 1
    i2 = floor ( i / 2 )
    if ( i == 2 * i2 )
      break
    end
    i = i2
  end
endfunction


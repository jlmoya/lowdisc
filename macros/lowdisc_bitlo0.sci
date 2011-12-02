// Copyright (C) 2010 - DIGITEO - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function bit = lowdisc_bitlo0 ( n )
  // Returns the position of the low zero bit base 2 in an integer.
  //
  // Calling Sequence
  //   bit = lowdisc_bitlo0 ( n )
  //
  // Parameters
  //    n : a 1-by-1 matrix of doubles, integer value, positive
  //    bit : the position of the low 0 bit, with 1<= bit <= d+1, where d is the number of digits to represent n in base 2.
  //
  //  Description
  //    Consider the number 11 = "1 0 1 1" in binary. The low zero bit is
  //    the first zero starting from the right. It is located at the index bit=3.
  //    If a number is made only of d ones in base 2, then bit = d+1.
  //
  //    This routine is not vectorized, i.e. it does not take a column matrix n as input argument, but only
  //    a 1-by-1 matrix.
  //
  //    TODO : vectorize this, if possible
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
  //  Authors
  //    2008-2009 - INRIA - Michael Baudin (Scilab version)
  //    2010 - Digiteo - Michael Baudin
  //
  
  d = lowdisc_bary(n)
  l = size(d,"*")
  k = find(d==0)
  bit = l - max(k) + 1
endfunction


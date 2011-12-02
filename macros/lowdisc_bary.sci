// Copyright (C) 2010 - DIGITEO - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.


function digits = lowdisc_bary ( varargin )
  //  Returns the digits of a number given the basis.
  //
  // Calling Sequence
  //   digits = lowdisc_bary ( n )
  //   digits = lowdisc_bary ( n , basis )
  //   digits = lowdisc_bary ( n , basis , order )
  // 
  // Parameters
  //   n : a 1-by-1 matrix of floating point integers, the integer to decompose
  //   basis : a 1-by-1 matrix of floating point integers, the basis. Default basis = 2.
  //   order : a string, the order of the digits. If order="littleendian", then the least significant digits are at the end. If order="bigendian", then the biggest significant digits are at the begining. Default is order="littleendian".
  //   digits : a n-by-1 matrix of floating point integers, the digits of the decomposition. The i-th digit satisfies 0<= digit(i) <= b - 1
  //
  // Description
  //   Returns the list of digits of the decomposition of
  //   n in base b, i.e. decompose n as
  //   n = d0 b^jmax + d1 b^{jmax-1} + ... + d{jmax+1} b^0.
  //   The order is little endian order, i.e. the first
  //   digit is associated with b^jmax, and the last digit
  //   is associated with b^0.
  //
  // This function is not vectorized, that is, it converts only one integer at a time.
  //
  // Examples
  //   lowdisc_bary ( 4 , 2 )                  // [1 0 0]'
  //   lowdisc_bary ( 4 , 2 , "bigendian" )    // [0 0 1]'
  //   lowdisc_bary ( 4 , 2 )                  // [1 0 0]'
  //   lowdisc_bary ( 4 , 2 , "littleendian" ) // [1 0 0]'
  //   lowdisc_bary ( 4 , 2 , "bigendian" )    // [0 0 1]'
  //
  // Authors
  //   Michael Baudin - 2008-2009 - INRIA
  //   Michael Baudin - 2010 - DIGITEO
  //
  // Bibliography
  //   "Monte-Carlo methods in Financial Engineering", Paul Glasserman
  //

  [lhs,rhs]=argn();
  if ( ( rhs < 1 ) | ( rhs > 3 ) ) then
    errmsg = msprintf(gettext("%s: Unexpected number of input arguments : %d provided while %d to %d are expected."), "lowdisc_bary" , rhs , 1 , 3 );
    error(errmsg)
  end
  //
  n = varargin ( 1 )
  if ( rhs < 2 ) then
    basis = 2
  else
    basis = varargin ( 2 )
  end
  if ( rhs < 3 ) then
    order = "littleendian";
  else
    order = varargin ( 3 )
  end
  //
  select order
  case "littleendian"
    if ( n==0 ) then
      digits = zeros(1,1);
    else
      jmax = int(log(n)/log(basis));
      q = int(basis^jmax);
      for j=1:jmax+1
        aj = int(n/q);
        digits(j) = aj;
        n = n - q * aj;
        q = q/basis;
      end
    end
  case "bigendian"
    if ( n==0 ) then
      digits = zeros(1,1);
    else
      jmax = int(log(n)/log(basis));
      current = n
      j = 1;
      while ( current > 0 )
        digit = modulo ( current , basis )
        digits(j) =digit
        current = int ( current / basis )
        j = j + 1
      end
    end
  else
    error ( msprintf ( gettext ( "%s: Unknown order"  ), ...
      "_bary" ) )
  end
endfunction


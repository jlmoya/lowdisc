// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

//
// lowdisc_bary --
//   Returns the list of digits of the decomposition of 
//   k in base b, i.e. decompose k as 
//   k = d0 b^jmax + d1 b^{jmax-1} + ... + d{jmax+1} b^0.
//   The order is little endian order, i.e. the first 
//   digit is associated with b^jmax, and the last digit
//   is associated with b^0.
// Arguments
//   k : the integer to decompose
//   basis : the basis
// References
//   Monte-Carlo methods in Financial Engineering, Paul Glasserman
// Test : lowdisc_bary (4,2) = [1 0 0]
//   lowdisc_bary (4,2,"bigendian") = [0 0 1]
//
function digits = lowdisc_bary ( k , basis , order )
  if (~isdef('order','local')) then
    order = "littleendian";
  end
  select order
  case "littleendian"
    if (k==0) then
      digits = zeros(1,1);
    else
      jmax = int(log(k)/log(basis));
      q = int(basis^jmax);
      for j=1:jmax+1
        aj = int(k/q);
        digits(1,j) = aj;
        k = k - q * aj;
        q = q/basis;
      end
    end
  case "bigendian"
    if k==0 then
      digits = zeros(1,1);
    else
      jmax = int(log(k)/log(basis));
      current = k
      j = 1;
      while ( current > 0 )
        digit = modulo ( current , basis )
        digits(1,j) =digit
        current = int ( current / basis )
        j = j + 1
      end
    end
  else
    error ( sprintf ( gettext ( "%s: Unknown order"  ), ...
      "lowdisc_bary" ) )
  end
endfunction


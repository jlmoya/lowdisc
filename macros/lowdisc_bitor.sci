// Copyright (C) ???? - INRIA - Farid BELAHCENE
// Copyright (C) 2008 - INRIA - Pierre MARECHAL
// Copyright (C) 2010 - DIGITEO - Michael Baudin
// 
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

function z = lowdisc_bitor(x,y)
  // bitwise OR
  //
  // Calling Sequence
  //   z = lowdisc_bitor(x,y)
  //
  // Parameters
  //  x : a m-by-n matrix of doubles, integer value, positive
  //  y : a m-by-n matrix of doubles, integer value, positive
  //  z : a m-by-n matrix of doubles, integer value, positive
  //
  // Description
  // Given x,y two positives integers this function returns the decimal
  // number whose the binary form is the OR of the binary representations 
  // of x and y.
  // If dimension of x is superior than 1 then z(i) is equal to bitor(x(i),y(i)).
  //
  // Examples
  // // example 1 :
  // // '110000' : is the binary representation of 48 
  // // '100101' : is the binary representation of 37   
  // // '110101' : is the binary representation for the OR operator 
  // // applied to the binary forms 48 and 37 
  // // so the decimal number corresponding to the OR operator 
  // // applied to binary forms 48 and 37 is : 53
  // x=48;
  // lowdisc_dec2bin(x)
  // y=37;
  // lowdisc_dec2bin(y)
  // z=lowdisc_bitor(x,y)
  // lowdisc_dec2bin(z)
  // // example 2 : the function is vectorized
  // x=[12,45]; 
  // y=[25,49];
  // z=lowdisc_bitor(x,y)
  //
  // Authors
  // INRIA - F.Belahcene
  // 2008 - INRIA - Pierre MARECHAL
  // 2010 - DIGITEO - Michael Baudin


  
  // P. Marechal, 5 Feb 2008
  //   - fix bug 2691 and 2692
  //   - Add argument check
  
  // Check input arguments
  // =========================================================================
  
  rhs = argn(2);
  
  if rhs <> 2 then
    error(msprintf(gettext("%s: Wrong number of input argument(s): %d expected.\n"),"lowdisc_bitor",2));
  end
  
  if typeof(x)<>typeof(y)
    error(msprintf(gettext("%s: Wrong type for input arguments: Same types expected.\n"),"lowdisc_bitor"));
  end
  
  if or(size(x)<>size(y)) then
    error(msprintf(gettext("%s: Wrong size for input arguments: Same size expected.\n"),"lowdisc_bitor"));
  end
  
  if isempty(x) & isempty(x)
    z=[];
    return
  end
  
  if    (type(x)==1  & (x-floor(x)<>0 | x<0)) ..
    | (type(x)==8  & (inttype(x)<10) ) ..
    | (type(x)<>1  & type(x)<>8) then
    
    error(msprintf(gettext("%s: Wrong input argument #%d: Scalar/matrix of unsigned integers expected.\n"),"lowdisc_bitor",1));
  end
  
  if    (type(y)==1  & (y-floor(y)<>0 | y<0)) ..
    | (type(y)==8  & (inttype(y)<10) ) ..
    | (type(y)<>1  & type(y)<>8) then
    
    error(msprintf(gettext("%s: Wrong input argument #%d: Scalar/matrix of unsigned integers expected.\n"),"lowdisc_bitor",2));
  end
  
  // Algorithm
  // =========================================================================
  
  if type(x)==8 then
    z = x | y;
  else
    a = 2^32;
    z = double( uint32(x/a) | uint32(y/a) ) * a;
    z = z + double(uint32(x-z) | uint32(y-z));
  end
  
endfunction


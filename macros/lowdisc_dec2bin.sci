// Copyright (C) 2010 - DIGITEO - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) INRIA - Farid BELAHCENE
//
//
// This file must be used under the terms of the CeCILL.
// 




function y = lowdisc_dec2bin ( varargin )
  // Convert a decimal floating point integer into binary.
  //
  // Calling Sequence
  //   y = lowdisc_dec2bin ( x )
  //   y = lowdisc_dec2bin ( x , n )
  //   y = lowdisc_dec2bin ( x , n , m )
  //
  // Parameters
  //    x : a  scalar/vector/matix of positives floating point integers, the decimal values to convert.
  //    n : (optionnal) a floating point integer, the number of bits in the generated binary string. Default is n=[], which means no padding.
  //    m : a floating point integer, the mode. The type of the output matrix. If m=1, then a string is returned. If m = 2, then a matrix of floating point integers is returned. Default m = 1.
  //    y : a vector of strings (positives)
  //
  // Description
  // Given x, a positive (or a vector/matix of integers) integer, this function returns a 
  // string (or a column vector of strings) which is the binary representation of x. 
  // If dimension of x is superior than 1 then each component of the colums vector str is 
  // the binary representation of the x components (i.e str(i) is the binary representation of x(i)). 
  // If the components length of str is less than n ( i.e length str(i) < n ), then add to 
  // str components the characters '0' on the left in order to have componants length equal to n.
  //
  // If m=2, then all floating point integers have the same number of bits, equal to the maximum
  // number of digits necessary to represent the largest integer.
  // If m=2, then the result y is always row-by-row, where y(i,:) stores the bits which 
  // represent the digits of x(i).
  // If m=2, and n<>[], then zeros are inserted at the head so that the matrix has n columns.
  //
  // This function is vectorized, that is, takes matrices of inputs x and returns matrices of output y.
  // It can convert many integers x at a time.
  //
  // Examples
  // // example 1
  // x=86
  // str=dec2bin(x)
  // 
  // // example 2
  // // the binary representation of 86 is: '1010110'
  // // its length is 7(less than n), so we add to str, 8 times the character '0'  (on the left)
  // x=86
  // n=15
  // str=dec2bin(x,n)
  // 
  // // example 3
  // x=[12 45 135]
  // z=dec2bin(x)
  // x=[12 45 135]'
  // z=dec2bin(x)
  //
  // // example 4 : returns integers, instead of string
  // x=[12 45 135]
  // z=dec2bin(x,[],2)
  // // See that the result does not depend on the orientation of x.
  // x=[12 45 135]'
  // z=dec2bin(x,[],2)
  //
  // // example 4 : returns integers, instead of string and pad to 8 bits
  // x=[12 45 135]
  // z=dec2bin(x,8,2)
  // // See that the result does not depend on the orientation of x.
  // x=[12 45 135]'
  // z=dec2bin(x,8,2)
  //
  // Authors
  //   INRIA - F.Belahcene
  //   2010 - DIGITEO - Michael Baudin

  rhs = argn(2)
  // check the number of input arguments
  if ( rhs<1 | rhs>3 ) then
    error(msprintf(gettext("%s: Wrong number of input argument(s): %d or %d expected.\n"),"lowdisc_dec2bin",1,2))
  end
  // Get arguments
  x = varargin(1)
  if ( rhs < 2 ) then
    n = []
  else
    n = varargin(2)
  end
  if ( rhs < 3 ) then
    m = 1
  else
    m = varargin(3)
  end
  // check type and size of the input arguments
  if ( or(type(x)<>8) & (or(type(x)<>1) | or(x<0)) ) then
    error(msprintf(gettext("%s: Wrong value for input argument #%d: Scalar/vector/matrix of positive integers expected.\n"),"lowdisc_dec2bin",1))
  end
  if ( rhs==2 & ((type(n)<>8 & (type(n)<>1 | n<0)) | prod(size(n))<>1) ) then
    error(msprintf(gettext("%s: Wrong value for input argument #%d: A positive integer expected"),"lowdisc_dec2bin",2))
  end
  // Check the m parameter
  if ( and ( m <> [1 2] ) ) then
    error(msprintf(gettext("%s: Wrong value for input argument #%d: Either 1 or 2 is expected, but got %d."),"lowdisc_dec2bin",2,m))
  end
  //
  // Case #1 : x=empty matrix
  if ( x==[] ) then
    if ( m == 1 ) then
      y=string([])
    else
      y=[]
    end
    return
  end
  [nr,nc] = size(x)
  x=x(:)
  //
  // Case #2 : input argument is a scalar/vector/matrix of zeros
  if ( and(x==0) ) then
    if ( n==[] ) then
      // No padding
      if ( m == 1 ) then
        y = "0" + emptystr(nr,nc)
      else
        y = zeros(nr,nc)
      end
    else
      // Padding
      if ( m == 1 ) then
        y = strcat(string(zeros(1:n))) + emptystr(nr,nc)
      else
        y = zeros(1:n) + zeros(nr,nc)
      end
    end
    return
  end
  // for x=25, pow=[4 3 0], because x=2^4+2^3+2^0
  // for x=23, pow=[4 2 1 0] because x=2^4+2^2+2^1+2^0
  // for x=[25 23]
  // pow=[4 3 0 -1
  //      4 2 1 0]
  while find(x>0)<>[]
    pow(x>0,$+1) = floor(log2(double(x(x>0))))
    pow(x<=0,$)  = -1
    x(x>0)       = floor(x(x>0)-2^pow(x>0,$))
  end
  pow   = pow+1
  ytemp = zeros(size(pow,1),size(pow,2))
  for i=1:size(ytemp,1)
    ind          = pow(i,pow(i,:)>=1)
    ytemp(i,ind) = 1
  end
  //
  if ( n == [] ) then
    // No padding
    for i=1:size(ytemp,1)
      if ( m == 1 ) then
        y(i)=strcat(string(ytemp(i,size(ytemp,2):-1:1)))
      else
        y(i,:)=ytemp(i,size(ytemp,2):-1:1)
      end
    end
  else
    // Padding
    for i=1:size(ytemp,1)
      if ( m == 1 ) then
        y(i)=strcat(string([zeros(1,round(n-size(ytemp,2))) ytemp(i,size(ytemp,2):-1:1)]))
      else
        y(i,:)=[zeros(1,round(n-size(ytemp,2))) ytemp(i,size(ytemp,2):-1:1)]
      end
    end
  end
  if ( m == 1 ) then
    y = matrix(y,nr,nc)
  end
endfunction


// Copyright (C) Anders Holtsberg
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function [this,next] = ldfaure_next ( varargin )
  [lhs,rhs]=argn();
  if ( rhs > 2 ) then
    errmsg = msprintf(gettext("%s: Unexpected number of input arguments : %d provided while from 1 or 2 are expected."), "ldfaure_next", rhs);
    error(errmsg)
  end
  //
  this = varargin(1)
  if ( rhs < 2 ) then
    imax = 1
  else
    imax = varargin(2)
  end
  //
  // Check that the object is started up
  if ( ~ldbase_get ( this.baseobj , "-startedup" ) ) then
    errmsg = msprintf(gettext("%s: The sequence is not started up. Call ldfaure_startup first."), "ldfaure_next");
    error(errmsg)
  end
  //
  dimension = ldbase_cget ( this.baseobj , "-dimension" )
  leap = ldbase_cget ( this.baseobj , "-leap" )
  //
  // Get the basis
  k = find(this.primeslist>= dimension,1)
  if (k == []) then
    errmsg = sprintf( gettext ( "%s: The dimension %d is larger than any prime in the table. Configure the -primeslist option to increase the prime table." ) , ...
      "_next_faure" , dimension);
    error(errmsg);
  end
  basis  = this.primeslist ( k )
  if (basis < dimension) then
    errmsg = sprintf( gettext ( "%s: Internal error : the current basis %d is lower than the current dimension %d, which is not consistent with the Faure sequence." ) , ...
      "_next_faure" , basis , dimension);
    error(errmsg);
  end
  //
  // Initialize the vector
  next = zeros(imax,dimension)
  //
  for i=1:imax
    this.baseobj = ldbase_incr ( this.baseobj )
    index = ldbase_get ( this.baseobj , "-index" )
    onevector = _fauresequence ( dimension , index , basis )
    next(i,1:dimension) = onevector
    // Leap over (i.e. ignore) as many elements as required
    // TODO : improve this to leap the elements without actually generating them
    if ( leap > 0 ) then
      for j = 1 : leap
        this.baseobj = ldbase_incr ( this.baseobj )
        index = ldbase_get ( this.baseobj , "-index" )
        onevector = _fauresequence ( dimension , index , basis )
      end
    end
  end
endfunction
//
// _fauresequence --
//   Returns the next term of the Faure sequence
//
// Parameters
//   dimension : the number of variables
//   index : the number of the element in the sequence
//   basis : the basis used in the sequence
//
// Examples
//   _fauresequence ( 3 , 4 , 3 ) = [4/9 7/9 1/9]
//
// Description
//   This implementation is not protected against overflow.
//   Practically, we did not experience any problem with 
//   that specific issue.
//   If that point was being an issue, we could use
//   as in TOMS 647, the Faure matrix modulo the basis.
//   To do this, it suffices to pass the basis to the fauremat
//   function and to use binomialmod instead of binomial.
//
// References
//   Monte-Carlo methods in Financial Engineering, Paul Glasserman
//
function next = _fauresequence ( dimension , index , basis )
  digits = _bary ( index , basis , "bigendian" )
  digits = digits'
  r = size ( digits , 1 )
  // Compute a vector made of 1/b, 1/b^2, etc...
  ib = 1.0/basis
  for i = 1:r
    bpwrs(i) = ib
    ib = ib / basis
  end
  // Compute the element #i in the sequence
  for idim = 1 : dimension
    ci = _fauremat ( r , idim - 1 )
    y = ci * digits
    ymodb = modulo ( y , basis )
    // Compute the component #idim of sequence
    next(1,idim) = ymodb' * bpwrs
  end
endfunction
//
// _fauremat --
//   Returns the Faure generator rxr matrix C(i).
// Arguments
//   r : the number of digits in the base-b expansion of k
//   i : the index of the coordinate of the point in the sequence,
//       with i= 1,d and d is the dimension
//   basis : the basis to use 
//     The binomial coefficients are computed modulo basis
// References
//   Monte-Carlo methods in Financial Engineering, Paul Glasserman
// Test : 
// faurematrix(3,2) = [1 2 4; 0 1 4; 0 0 1]
// faurematrix(2,1) = [1 1; 0 1]
// faurematrix(2,2) = [1 2; 0 1]
// faurematrix ( 5 , 1 );
// expected = [
//     1.    1.    1.    1.    1.                        
//     0.    1.    2.    3.    4.  
//     0.    0.    1.    3.    6.  
//     0.    0.    0.    1.    4.  
//     0.    0.    0.    0.    1.                        
// ];
// faurematrix ( 5 , 1 );
// expected = [
//     1.    1.    1.    1.    1.                        
//     0.    1.    2.    3.    4.  
//     0.    0.    1.    3.    6.  
//     0.    0.    0.    1.    4.  
//     0.    0.    0.    0.    1.                        
// ];
//
function c = _fauremat ( r , i )
  for m = 1:r
    for n = 1:r
      if ( m <= n ) then
        c(m,n) = i^(n-m) * _binomial ( n-1 , m-1 );
      end
    end
  end
endfunction


// 
// _binomial --
//   Returns the binomial number (n,k), i.e.
//   the number of k-element subsets of an n-element set.
//   It is defined by n!/(k! (n-k)!
//   and can be computed as 
//
//   n (n-1) ... (n-k+1)
//   -------------------
//   k (k-1) ... 1
//                    
// References
//   http://en.wikipedia.org/wiki/Binomial_coefficients
//   http://wiki.tcl.tk/1755
//
// Note about floating point accuracy
//   factorial(170) ~ 7.e306
//   So n=170 is the greatest integer for which
//   n! can be computed.
//   If the naive formula 
//
//   b = factorial(n)/factorial(k)/factorial(n-k);
//
//   was used, the maximum value n for which 
//   the binomial can be computed is n = 170.
//   But binomial(171,1) = 1, so there is no reason
//   to prevent the computation of 1 because an intermediate
//   result is > 1.e308.
//   This is why the gammaln function is used instead.
// Note about rounding for integer inputs
//   If n = 4 and k = 1, the gammaln and exp functions 
//   are accurate only to 1ulp. This leads to the 
//   result that b = 3.99...99998.
//   It is the result of the fact that we use the elementary 
//   functions exp and gammaln.
//   This is very close to 4, but is not equal to 4.
//   Assume that you know compute c = b (mod 4) and you 
//   get c = b = 3.99...99998, intead of getting c  = 4.
//   This is why, when input arguments are integers,
//   the result is rounded to the nearest integer.
// c = lowdisc_binomial ( 4 , 1 ) // 4
// c = lowdisc_binomial ( 5 , 0 ) // 1
// c = lowdisc_binomial ( 5 , 1 ) // 5
// c = lowdisc_binomial ( 5 , 2 ) // 10
// c = lowdisc_binomial ( 5 , 3 ) // 10
// c = lowdisc_binomial ( 5 , 4 ) // 5
// c = lowdisc_binomial ( 5 , 5 ) // 1
// c = lowdisc_binomial ( 17 , 18 ) // 0
// c = lowdisc_binomial ( 17 , -1 ) // 0
// c = lowdisc_binomial ( 1.5 , 0.5 ) // 1.5
// c = lowdisc_binomial ( 10000 , 134 ) // 2.050083865024873735e307
//
function b = _binomial ( n , k )
  if ( ( k < 0 ) | ( k > n ) ) then 
    b = 0
  else
    r = gammaln ( n + 1 ) - gammaln (k + 1) - gammaln (n - k + 1)
    b = exp( r );
  end
  // If the input where integers, returns also an integer.
  if ( and(round(n)==n) & and(round(k)==k) ) then
    b = round ( b )
  end
endfunction
//
// _bary --
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
// Test : 
//   _bary (4,2)                      // [1 0 0]
//   _bary (4,2,"bigendian")          // [0 0 1]
//   _bary ( 4 , 2 )                  // [1 0 0]
//   _bary ( 4 , 2 , "littleendian" ) // [1 0 0]
//   _bary ( 4 , 2 , "bigendian" )    // [0 0 1]
//
function digits = _bary ( k , basis , order )
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
      "_bary" ) )
  end
endfunction


// Copyright (C) 2010 - DIGITEO - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009 - John Burkardt
// Copyright (C) 1986 - Bennett Fox

// This file must be used under the terms of the GNU LGPL license.

function [this,next] = ldsobol_next ( varargin )
  
  [lhs,rhs]=argn();
  if ( rhs > 2 ) then
    errmsg = msprintf(gettext("%s: Unexpected number of input arguments : %d provided while from 1 or 2 are expected."), "ldsobol_next", rhs);
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
    errmsg = msprintf(gettext("%s: The sequence is not started up. Call ldsobol_startup first."), "ldsobol_next");
    error(errmsg)
  end
  //
  dimension = ldbase_cget ( this.baseobj , "-dimension" )
  leap = ldbase_cget ( this.baseobj , "-leap" )
  //
  // Initialize the vector
  next = zeros(imax,dimension)
  //
  for i=1:imax
    this.baseobj = ldbase_incr ( this.baseobj )
    [ this , onevector ] = _next_sobol ( this );
    next(i,1:dimension) = onevector
    // Leap over (i.e. ignore) as many elements as required
    // TODO : improve this to leap the elements without actually generating them
    if ( leap > 0 ) then
      for j = 1 : leap
        this.baseobj = ldbase_incr ( this.baseobj )
        [ this , onevector ] = _next_sobol ( this );
      end
    end
  end
endfunction

// References
//
//    Antonov, Saleev,
//    USSR Computational Mathematics and Mathematical Physics,
//    Volume 19, 1980, pages 252 - 256.
//
//    Paul Bratley, Bennett Fox,
//    Algorithm 659:
//    Implementing Sobol's Quasirandom Sequence Generator,
//    ACM Transactions on Mathematical Software,
//    Volume 14, Number 1, pages 88-100, 1988.
//
//    Bennett Fox,
//    Algorithm 647:
//    Implementation and Relative Efficiency of Quasirandom 
//    Sequence Generators,
//    ACM Transactions on Mathematical Software,
//    Volume 12, Number 4, pages 362-376, 1986.
//
//    Ilya Sobol,
//    USSR Computational Mathematics and Mathematical Physics,
//    Volume 16, pages 236-242, 1977.
//
//    Ilya Sobol, Levitan, 
//    The Production of Points Uniformly Distributed in a Multidimensional 
//    Cube (in Russian),
//    Preprint IPM Akad. Nauk SSSR, 
//    Number 40, Moscow 1976.
//
// _next_sobol --
//    generates a new quasirandom Sobol vector with each call.
//
//  Discussion:
//
//    The routine adapts the ideas of Antonov and Saleev.
//
//    Thanks to Francis Dalaudier for pointing out that the range of allowed
//    values of DIM_NUM should start at 1, not 2!  17 February 2009.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license.
//
//  Modified:
//
//    17 February 2009
//
//  Author:
//
//    Original FORTRAN77 version by Bennett Fox.
//    MATLAB version by John Burkardt
//    Scilab version : 
//       2009 - Digiteo - Michael Baudin
//
//  Parameters:
//
//    Input, integer DIM_NUM, the number of spatial dimensions.
//    DIM_NUM must satisfy 1 <= DIM_NUM <= 40.
//
//    Input/output, integer SEED, the "seed" for the sequence.
//    This is essentially the index in the sequence of the quasirandom
//    value to be generated.  On output, SEED has been set to the
//    appropriate next value, usually simply SEED+1.
//    If SEED is less than 0 on input, it is treated as though it were 0.
//    An input value of 0 requests the first (0-th) element of the sequence.
//
//    Output, real QUASI(DIM_NUM), the next quasirandom vector.
//
function [ this , quasi ] = _next_sobol ( this )
  // Get data from structure
  lastq = this.sobollastq
  count = this.sobolcount
  v = this.sobolv
  recipd = this.sobolrecipd
  dim_num = ldbase_cget ( this.baseobj , "-dimension" )
  maxcol = this.sobolmaxcol;
  //
  //  Find the position of the right-hand zero in count
  //
  l = _bitlo0 ( count );
  //
  //  Check that the user is not calling too many times!
  //
  if ( maxcol < l )
    error ( msprintf ( gettext ( "%s: Too many calls. maxcol=%d, l=%d") , "_next_sobol" , l , maxcol ));
  end
  //
  //  Calculate the new components of QUASI.
  //
  for i = 1 : dim_num
    quasi(1,i) = lastq(i) * recipd;
    lastq(i) = _xor ( lastq(i), v(i,l) );
  end
  // Put data into structure
  this.sobollastq = lastq;
  this.sobolcount = this.sobolcount + 1;
endfunction

//
// _bitlo0 --
//   I4_BIT_LO0 returns the position of the low 0 bit base 2 in an integer.
//
//  Example:
//
//       N    Binary     BIT
//    ----    --------  ----
//       0           0     1
//       1           1     2
//       2          10     1
//       3          11     3 
//       4         100     1
//       5         101     2
//       6         110     1
//       7         111     4
//       8        1000     1
//       9        1001     2
//      10        1010     1
//      11        1011     3
//      12        1100     1
//      13        1101     2
//      14        1110     1
//      15        1111     5
//      16       10000     1
//      17       10001     2
//    1023  1111111111     1
//    1024 10000000000     1
//    1025 10000000001     1
//
//  Licensing:
//    This code is distributed under the GNU LGPL license.
//
//  Modified:
//    16 February 2005
//
//  Author:
//    John Burkardt
//    Scilab version : 
//       2009 - Digiteo - Michael Baudin
//
//  Parameters:
//    Input, integer N, the integer to be measured.
//    N should be nonnegative.
//
//    Output, integer BIT, the position of the low 1 bit.
//
function bit = _bitlo0 ( n )
  bit = 0;
  i = floor ( n );
  while ( 1 )
    bit = bit + 1;
    i2 = floor ( i / 2 );
    if ( i == 2 * i2 )
      break;
    end
    i = i2;
  end
endfunction

// _xor --
//   calculates the exclusive OR of two integers.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license.
//
//  Modified:
//
//    16 February 2005
//
//  Author:
//
//   John Burkardt
//    Scilab version : 
//       2009 - Digiteo - Michael Baudin
//
//  Parameters:
//
//    Input, integer I, J, two values whose exclusive OR is needed.
//
//    Output, integer K, the exclusive OR of I and J.
//
function k = _xor ( i, j )
  k = 0;
  l = 1;
  //
  i = floor ( i );
  j = floor ( j );
  while ( i ~= 0 | j ~= 0 )
    //
    //  Check the current right-hand bits of I and J.
    //  If they differ, set the appropriate bit of K.
    //
    i2 = floor ( i / 2 );
    j2 = floor ( j / 2 );
    if ( ...
      ( ( i == 2 * i2 ) & ( j ~= 2 * j2 ) ) | ...
      ( ( i ~= 2 * i2 ) & ( j == 2 * j2 ) ) )
      k = k + l;
    end
    i = i2;
    j = j2;
    l = 2 * l;
  end
endfunction


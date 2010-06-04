// Copyright (C) 2010 - DIGITEO - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2003 - John Burkardt
// Copyright (C) 1994 - Paul Bratley, Bennett Fox, Harald Niederreiter
//
// This file must be used under the terms of the GNU LGPL license.





function [this,next] = ldnied2_next ( varargin )

  [lhs,rhs]=argn();
  if ( rhs > 2 ) then
    errmsg = msprintf(gettext("%s: Unexpected number of input arguments : %d provided while from 1 or 2 are expected."), "ldnied2_next", rhs);
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
    errmsg = msprintf(gettext("%s: The sequence is not started up. Call ldnied2_startup first."), "ldnied2_next");
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
    [ this , onevector ] = _next_nieder2 ( this );
    next(i,1:dimension) = onevector
    // Leap over (i.e. ignore) as many elements as required
    // TODO : improve this to leap the elements without actually generating them
    if ( leap > 0 ) then
      for j = 1 : leap
        this.baseobj = ldbase_incr ( this.baseobj )
        [ this , onevector ] = _next_nieder2 ( this );
      end
    end
  end
endfunction
// _next_nieder2 --
//  Returns an element of the Niederreiter sequence base 2.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license.
//
//  Modified:
//
//    31 March 2003
//
//  Author:
//
//    Original FORTRAN77 version by Paul Bratley, Bennett Fox, Harald Niederreiter.
//    MATLAB version by John Burkardt
//    Scilab version : 
//       2009 - Digiteo - Michael Baudin
//
//  Reference:
//
//    Harald Niederreiter,
//    Low-discrepancy and low-dispersion sequences,
//    Journal of Number Theory,
//    Volume 30, 1988, pages 51-70.
//
//    "Algorithm 738: Programs to generate Niederreiter's low-discrepancy
//    sequences", P. Bratley, B. L. Fox, and H. Niederreiter, 1994. ACM Trans.
//    Math. Softw. 20, 4 (Dec. 1994), 494-495.
//
//  Parameters:
//
//    Input, integer DIM, the dimension of the sequence to be generated.
//
//    Input, integer SEED, the index of the element to compute.
//
//    Output, real QUASI(DIM), the next quasirandom vector.
//
//    Output, integer SEED_NEW, the next value of the SEED.
//
//  Local Parameters:
//
//    Local, integer MAXDIM, the maximum dimension that will be used.
//
//    Local, integer NBITS, the number of bits (not counting the sign) in a
//    fixed-point integer.
//
//    Local, real RECIP is the multiplier which changes the
//    integers in NEXTQ into the required real values in QUASI.
//
//    Local, integer NR_cj(MAXDIM,NBITS), the packed values of
//    Niederreiter's C(I,J,R).
//
//    Local, integer NR_dim, the spatial dimension of the sequence
//    as specified on an initialization call.
//
//    Local, integer NR_nextq(MAXDIM), the numerators of the next item in the
//    series.  These are like Niederreiter's XI(N) (page 54) except that
//    N is implicit, and the NR_nextq are integers.  To obtain
//    the values of XI(N), multiply by RECIP.
//
function [ this , quasi ] = _next_nieder2 ( this )

  // Extract data
  NR_cj = this.NR_cj;
  dim = ldbase_cget ( this.baseobj , "-dimension" )
  NR_nextq = this.NR_nextq;
  NR_seed = this.NR_seed;
  NR_recip = this.NR_recip;
  nbits = this.NR_nbits;
//
//  Multiply the numerators in NEXTQ by RECIP to get the next
//  quasi-random vector.
//
  quasi(1:dim) = NR_nextq(1:dim) * NR_recip;
  quasi = quasi.';
//
//  Find the position of the right-hand zero in SEED.  This
//  is the bit that changes in the Gray-code representation as
//  we go from SEED to SEED+1.
//
  r = 0;
  i = NR_seed;
  while ( _divremainder ( i, 2 ) ~= 0 )
    r = r + 1;
    i = floor ( i / 2 );
  end
//
//  Check that we have not passed 2**NBITS calls.
//
  if ( nbits <= r )
    error ( sprintf ( gettext ( "%s: Too many calls" ) , "_next_nieder2" ) );
  end
//
//  Compute the new numerators in vector NEXTQ.
//
  for i = 1 : dim
    NR_nextq(i) = _exor ( NR_nextq(i), NR_cj(i,r+1) );
  end
  NR_seed = NR_seed + 1;
  // Insert data
  this.NR_nextq = NR_nextq;
  this.NR_seed = NR_seed;

endfunction


// _divremainder --
//  Remainder after division.
// TODO : isn't that modulo ? modulop ?
//
function r = _divremainder ( X , Y )
  r = X - fix ( X ./ Y ) .* Y
endfunction

//  _exor --
//    calculates the exclusive OR of two integers.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license.
//
//  Modified:
//
//    31 March 2003
//
//  Author:
//
//   John Burkardt
//    Scilab version : 
//       2009 - Digiteo - Michael Baudin
//
//  Reference:
//
//    Bennett Fox,
//    Algorithm 647:
//    Implementation and Relative Efficiency of Quasirandom 
//    Sequence Generators,
//    ACM Transactions on Mathematical Software,
//    Volume 12, Number 4, pages 362-376, 1986.
//
//  Parameters:
//
//    Input, integer I, J, two values whose exclusive OR is needed.
//
//    Output, integer K, the exclusive OR of I and J.
//
function k = _exor ( i, j )
  k = 0;
  l = 1;
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


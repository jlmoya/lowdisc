// Copyright (C) 2010 - DIGITEO - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2003 - John Burkardt
// Copyright (C) 1994 - Paul Bratley, Bennett Fox, Harald Niederreiter
//
// This file must be used under the terms of the GNU LGPL license.





function [this,next] = ldnied2_next ( varargin )
  
  [lhs,rhs]=argn()
  if ( rhs > 2 ) then
    errmsg = msprintf(gettext("%s: Unexpected number of input arguments : %d provided while from 1 or 2 are expected."), "ldnied2_next", rhs)
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
    errmsg = msprintf(gettext("%s: The sequence is not started up. Call ldnied2_startup first."), "ldnied2_next")
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
    [ this.seed , this.nextq , onevector ] = _next_nieder2 ( dimension , this.cj , this.nextq , this.seed , this.recip , this.nbits )
    next(i,1:dimension) = onevector'
    if ( leap > 0 ) then
      // Leap over (i.e. ignore) as many elements as required
      // Vectorized call to lowdisc_bitxor : this is the best that we can do.
      [ this.seed , this.nextq ] = _nieder2skip ( dimension , this.cj , this.nextq , this.seed , this.nbits , leap )
      index = ldbase_get ( this.baseobj , "-index" )
      this.baseobj = ldbase_indexset ( this.baseobj , index + leap )
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
//    Local, integer cj(MAXDIM,NBITS), the packed values of
//    Niederreiter's C(I,J,R).
//
//    Local, integer NR_dim, the spatial dimension of the sequence
//    as specified on an initialization call.
//
//    Local, integer nextq(MAXDIM), the numerators of the next item in the
//    series.  These are like Niederreiter's XI(N) (page 54) except that
//    N is implicit, and the nextq are integers.  To obtain
//    the values of XI(N), multiply by RECIP.
//
function [ seed , nextq , quasi ] = _next_nieder2 ( dimension , cj , nextq , seed , recip , nbits )
  //
  //  Multiply the numerators in NEXTQ by RECIP to get the next
  //  quasi-random vector.
  //
  quasi(1:dimension) = nextq(1:dimension) * recip
  //
  //  Find the position of the right-hand zero in SEED.  This
  //  is the bit that changes in the Gray-code representation as
  //  we go from SEED to SEED+1.
  //
  r = lowdisc_bitlo0 ( seed ) - 1
  //
  //  Check that we have not passed 2**NBITS calls.
  //
  if ( nbits <= r )
    error ( msprintf ( gettext ( "%s: Too many calls" ) , "_next_nieder2" ) )
  end
  //
  //  Compute the new numerators in vector NEXTQ.
  //  Call to lowdisc_bitxor is vectorized.
  //
  nextq = lowdisc_bitxor ( nextq, cj(1 : dimension,r+1) )
  seed = seed + 1
endfunction

function [ seed , nextq ] = _nieder2skip ( dimension , cj , nextq , seed , nbits , skip )
  // _nieder2skip
  //   Discard (i.e. ignore) skip elements in the sequence.
  //   The only difference with next is that we do not generate the quasi vector.
  // Parameters
  //   dimension : the current dimension
  //   cj : the values of Niederreiter's C(I,J,R)
  //   seed : sequence number of this call. By default, seed  should be set to zero, i.e. we start from the 0-th element of the sequence. If elements of the sequence are to be skipped, set seed accordingly. 
  //   nextq : The numerators of the next item in the series.  These are like Niederreiter's XI(N) (page 54) except that N is implicit, and the NEXTQ are integers.  
  //   nbits : the number of bits in a fixed-point integer, not counting the sign.
  
  for i = 1 : skip
    //
    //  Find the position of the right-hand zero in SEED.  This
    //  is the bit that changes in the Gray-code representation as
    //  we go from SEED to SEED+1.
    //  TODO : vectorize this
    //
    r = lowdisc_bitlo0 ( seed ) - 1
    //
    //  Check that we have not passed 2**NBITS calls.
    //
    if ( nbits <= r )
      error ( msprintf ( gettext ( "%s: Too many calls" ) , "_next_nieder2" ) )
    end
    //
    //  Compute the new numerators in vector NEXTQ.
    //  Call to lowdisc_bitxor is vectorized.
    //
    nextq = lowdisc_bitxor ( nextq, cj(1 : dimension,r+1) )
    seed = seed + 1
  end
endfunction



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
    [ onevector , this.lastq , this.count ] = _next_sobol ( this.count , this.maxcol , dimension , this.lastq , this.v , this.recipd )
    next(i,1:dimension) = onevector'
    if ( leap > 0 ) then
      // Leap over (i.e. ignore) as many elements as required
      // Vectorized call to lowdisc_bitxor : this is the best that we can do.
      [ this.count , this.lastq ] = lowdisc_sobolskip ( leap , this.lastq , dimension , this.count , this.v )
      index = ldbase_get ( this.baseobj , "-index" )
      this.baseobj = ldbase_indexset ( this.baseobj , index + leap )
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
function [ quasi , lastq , count ] = _next_sobol ( count , maxcol , dim_num , lastq , v , recipd )
  //
  //  Find the position of the right-hand zero in count
  //
  l = lowdisc_bitlo0 ( count )
  //
  //  Check that the user is not calling too many times!
  //
  if ( maxcol < l )
    error ( msprintf ( gettext ( "%s: Too many calls. maxcol=%d, l=%d") , "_next_sobol" , l , maxcol ))
  end
  //
  //  Calculate the new components of QUASI.
  //
  quasi(1 : dim_num) = lastq(1 : dim_num) * recipd
  lastq(1 : dim_num) = lowdisc_bitxor ( lastq(1 : dim_num), v(1 : dim_num,l) )
  count = count + 1
endfunction



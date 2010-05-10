// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

function [this,next] = ldsobol_next ( varargin )

  [lhs,rhs]=argn();
  if ( rhs > 2 ) then
    errmsg = msprintf(gettext("%s: Unexpected number of input arguments : %d provided while from 1 or 2 are expected."), "lowdisc_next", rhs);
    error(errmsg)
  end
  
  this = varargin(1)
  if ( rhs < 2 ) then
    imax = 1
  else
    imax = varargin(2)
  end

  //
  // Check that the object is started up
  if ( this.startedup == 0 ) then
    errmsg = msprintf(gettext("%s: The sequence is not started up. Call lowdisc_startup first."), "lowdisc_next");
    error(errmsg)
  end
  //
  // Initialize the vector
  next = zeros(imax,this.dimension)
  
  for i=1:imax
    this.sequenceindex = this.sequenceindex + 1;
    [ this , onevector ] = _next_sobol ( this );
    next(i,1:this.dimension) = onevector
    // Leap over (i.e. ignore) as many elements as required
    if ( this.leap > 0 ) then
      for j = 1 : this.leap
        this.sequenceindex = this.sequenceindex + 1;
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
  dim_num = this.dimension
  maxcol = this.sobolmaxcol;
//
//  Find the position of the right-hand zero in count
//
    l = lowdisc_bitlo0 ( count );
//
//  Check that the user is not calling too many times!
//
  if ( maxcol < l )
    error ( sprintf ( gettext ( "%s: Too many calls. maxcol=%d, l=%d") , "_next_sobol" , l , maxcol ));
  end
//
//  Calculate the new components of QUASI.
//
  for i = 1 : dim_num
    quasi(1,i) = lastq(i) * recipd;
    lastq(i) = lowdisc_xor ( lastq(i), v(i,l) );
  end
  // Put data into structure
  this.sobollastq = lastq;
  this.sobolcount = this.sobolcount + 1;
endfunction


// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function [this,next] = ldrevhal_next ( varargin )

  [lhs,rhs]=argn();
  if ( rhs > 2 ) then
    errmsg = msprintf(gettext("%s: Unexpected number of input arguments : %d provided while from 1 or 2 are expected."), "ldrevhal_next", rhs);
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
    errmsg = msprintf(gettext("%s: The sequence is not started up. Call ldrevhal_startup first."), "ldrevhal_next");
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
    index = ldbase_get ( this.baseobj , "-index" )
    onevector = _reversehalton ( dimension , index , this.primeslist )
    next(i,1:dimension) = onevector
    // Leap over (i.e. ignore) as many elements as required
    if ( leap > 0 ) then
      for j = 1 : leap
        this.baseobj = ldbase_incr ( this.baseobj )
        index = ldbase_get ( this.baseobj , "-index" )
        onevector = _reversehalton ( dimension , index , this.primeslist )
      end
    end
  end
endfunction
//
// _reversehalton --
//   Returns the next value of the reverse Halton
//   sequence.
// Parameters
//   dimension : the number of variables
//   index : the index of the element in the sequence
//   primes : a matrix of consecutive prime numbers, in increasing order
//
function next = _reversehalton ( dimension , index , primes )
  next = zeros(1:dimension);
  for idim=1:dimension
    basis = primes ( idim );
    next(idim) = _vdcinv ( index , basis )
  end
endfunction
//
// _vdcinv --
//   Returns the term #i of the inverted Van Der Corput low discrepancy sequence in 
//   given basis.
// Arguments, input
//   i : the index in the sequence
//   basis : the basis of the sequence
// Arguments, output
//   result : the next element in the sequence, uniform in [0,1]
//
function result = _vdcinv ( i , basis )
  current = i;
  ib = 1.0 / basis;
  result = 0.0;
  while (current>0)
    digit = modulo ( current , basis );
    current = int ( current / basis );
    if ( digit <> 0 ) then
      result = result + ( basis - digit ) * ib;
    end
    ib = ib / basis;
  end
endfunction


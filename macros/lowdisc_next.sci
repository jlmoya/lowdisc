// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt


// References
// Reverse Halton
// B. Vandewoestyne and R. Cools, 
// Good permutations for deterministic scrambled Halton
// sequences in terms of L2-discrepancy, Computational and Applied
// Mathematics 189, 2006
// See also O. Teytaud, 2007, Gnu Scientific Library
//


//
// lowdisc_next --
//   Returns the next term of the sequence, that is,
//   returns a matrix of values with shape 1 x s, where s is the
//   dimension of the space.
// Arguments
//   next : the next vector in the sequence
// Caution !
//   The current object is updated after the call to next :
//   both this and next are mandatory output arguments.
//
function [this,next] = lowdisc_next (this)
  this.sequenceindex = this.sequenceindex + 1;
  //
  // Compute vector
  //
  select this.method
  case "vandercorput" then
    next = _next_vandercorput (this);
  case "halton" then
    next = _next_halton (this);
  case "faure" then
    next = _next_faure (this);
  case "reversehalton" then
    [this,next] = _next_reversehalton (this);
  case "sobol" then
    [ this , next ] = lowdisc_sobol ( this );
  case "niederreiter-base-2" then
    [ this , next ] = lowdisc_nieder2 ( this );
//
// Fast sequences based on primitives
//
  case "haltonf" then
    [ this , next ] = _next_haltonf (this);
  case "reversehaltonf" then
    [ this , next ] = _next_reversehaltonf (this);
  case "niederreiter-base-2f" then
    [ this , next ] = _next_nieder2f (this);
  case "sobolf" then
    [ this , next ] = _next_sobolf (this);
  case "fauref" then
    [ this , next ] = _next_fauref (this);
  else
    errmsg = sprintf ( gettext ( "%s: Unknown method %s" ) , ...
      "lowdisc_next" , this.method);
    error(errmsg);
  end
  // Leap over (i.e. ignore) as many elements as required
  if ( this.leap > 0 ) then
    [ this , result ] = lowdisc_terms ( this , this.leap )
  end
endfunction
//
// _next_vandercorput --
//   Returns the next term of the Van Der Corput sequence
//
function next = _next_vandercorput (this)
  if (this.dimension<>1) then
    errmsg = sprintf ( gettext ( "%s: The current dimension is %d but the Van Der Corput sequence is not available with dimension different from 1"), ...
    "_next_vandercorput" , this.dimension);
    error(errmsg);
  end
  next = lowdisc_vdc (this.sequenceindex,this.vdcbasis)
endfunction

//
// _next_halton --
//   Returns the next term of the Halton sequence
//
function next = _next_halton (this)
  next = zeros(1:this.dimension);
  for idim=1:this.dimension
    basis = this.primeslist(idim);
    next(idim) = lowdisc_vdc (this.sequenceindex,basis);
  end
endfunction


//
// _next_faure --
//   Returns the next term of the Faure sequence
//
function next = _next_faure (this)
  basis = this.fauredim2prime(this.dimension);
  if (basis < this.dimension) then
    errmsg = sprintf( gettext ( "%s: Internal error : the current basis %d is lower than the current dimension %d, which is not consistent with the Faure sequence." ) , ...
      "_next_faure" , basis , this.dimension);
    error(errmsg);
  end
  next = lowdisc_faure ( this.sequenceindex , basis , this.dimension )
endfunction

//
// _next_reversehalton --
//   Returns the next value of the reverse Halton
//   sequence.
// Arguments:
//
function [ this , next ] = _next_reversehalton (this)
  next = zeros(1:this.dimension);
  for idim=1:this.dimension
    basis = this.primeslist(idim);
    next(idim) = lowdisc_vdcinv (this.sequenceindex,basis);
  end
endfunction
//
// _next_reversehaltonf --
//   Returns the next value of the Fast reverse Halton
//   sequence.
// Arguments:
//
function [ this , next ] = _next_reversehaltonf ( this )
  
endfunction
//
// _next_haltonf --
//   Returns the next value of the Fast Halton
//   sequence.
// Arguments:
//
function [ this , next ] = _next_haltonf ( this )
  dim = this.dimension;
  next = _lowdisc_haltonf ( dim );
endfunction
//
// _next_fauref --
//   Returns the next value of the Fast Faure
//   sequence.
// Arguments:
//
function [ this , next ] = _next_fauref ( this )
  dim = this.dimension;
  seed = this.sequenceindex;
  [ next , seed ] = _lowdisc_fauref ( dim , seed );
endfunction
//
// _next_sobolf --
//   Returns the next value of the Fast Sobol
//   sequence.
// Arguments:
//
function [ this , next ] = _next_sobolf ( this )
  dim = this.dimension;
  seed = this.sequenceindex;
  [ next , seed ] = _lowdisc_sobolf ( dim , seed );
endfunction
//
// _next_nieder2f --
//   Returns the next value of the Fast Niederreier base 2
//   sequence.
// Arguments:
//
function [ this , next ] = _next_nieder2f ( this )
  dim = this.dimension;
  base = 2;
  seed = this.sequenceindex;
  [ next , seed ] = _lowdisc_niederf ( dim , base , seed )
endfunction


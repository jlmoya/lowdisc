// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

function [this,next] = lowdisc_next ( varargin )
  // Returns the next term of the sequence
  //
  // Calling Sequence
  //   [this,next] = lowdisc_next ( this )
  //   [this,next] = lowdisc_next ( this , imax )
  //
  // Parameters
  //   this: the current object
  //   imax: the number of terms to retrieve (default = 1)
  //   next : a matrix of size imax x s, the next vector in the sequence
  //
  // Description
  //   Returns a matrix of values with shape 1 x s, where s is the
  //   dimension of the space.
  //   The current object is updated after the call to next :
  //   both this and next are mandatory output arguments.
  //   This function is sensitive to the "-leap" option.
  //
  // Examples
  //   rng = lowdisc_new();
  //   rng = lowdisc_configure(rng,"-method","halton");
  //   rng = lowdisc_startup (rng);
  //   // Term #1
  //   [rng,computed] = lowdisc_next (rng);
  //   // Term #2
  //   [rng,computed] = lowdisc_next (rng);
  //   // Term #3, etc...
  //   [rng,computed] = lowdisc_next (rng);
  //   rng
  //   rng = lowdisc_destroy(rng);
  //
  //   // See the imax parameter in action
  //   rng = lowdisc_new();
  //   rng = lowdisc_configure(rng,"-method","halton");
  //   rng = lowdisc_startup (rng);
  //   // Term #1 to 100
  //   [rng,computed] = lowdisc_next (rng,100);
  //   // Term #101 to 201
  //   [rng,computed] = lowdisc_next (rng,100);
  //   rng
  //   rng = lowdisc_destroy(rng);
  //
  //   // See the -leap option in action
  //   rng = lowdisc_new();
  //   rng = lowdisc_configure(rng,"-method","halton");
  //   rng = lowdisc_configure(rng,"-leap",10);
  //   rng = lowdisc_startup (rng);
  //   // Term #1
  //   [rng,computed] = lowdisc_next (rng);
  //   // Term #11
  //   [rng,computed] = lowdisc_next (rng);
  //   // Term #21
  //   [rng,computed] = lowdisc_next (rng);
  //   rng
  //   rng = lowdisc_destroy(rng);
  //
  //   // See the -skip option in action.
  //   rng = lowdisc_new();
  //   rng = lowdisc_configure(rng,"-method","fauref");
  //   rng = lowdisc_configure(rng,"-dimension",4);
  //   // Skip qs^4 - 1 terms, as in TOMS implementation
  //   qs = lowdisc_get ( rng , "-faurefprime" );
  //   rng = lowdisc_configure(rng,"-skip", qs^4 - 2);
  //   rng
  //   rng = lowdisc_startup (rng);
  //   [rng,computed]=lowdisc_next(rng);
  //   // Terms #1 to #100
  //   [rng,computed]=lowdisc_terms(rng,100);
  //   for i = 1:100
  //     mprintf ("%8d %14.6f %14.6f %14.6f %14.6f\n", i , computed(i,1) , computed(i,2) , computed(i,3) , computed(i,4) )
  //   end
  //   rng = lowdisc_destroy(rng);
  //   
  // Authors
  //   Michael Baudin - 2008-2009 - INRIA
  //   Michael Baudin - 2010 - DIGITEO
  //

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
    //
    // Compute vector
    //
    select this.method
    case "vandercorput" then
      onevector = _next_vandercorput (this);
    case "halton" then
      onevector = _next_halton (this);
    case "faure" then
      onevector = _next_faure (this);
    case "reversehalton" then
      [this,onevector] = _next_reversehalton (this);
    case "sobol" then
      [ this , onevector ] = lowdisc_sobol ( this );
    case "niederreiter-base-2" then
      [ this , onevector ] = lowdisc_nieder2 ( this );
      //
      // Fast sequences based on primitives
      //
    case "haltonf" then
      [ this , onevector ] = _next_haltonf (this);
    case "reversehaltonf" then
      [ this , onevector ] = _next_reversehaltonf (this);
    case "niederreiter-base-2f" then
      [ this , onevector ] = _next_nieder2f (this);
    case "sobolf" then
      [ this , onevector ] = _next_sobolf (this);
    case "fauref" then
      [ this , onevector ] = _next_fauref (this);
    else
      errmsg = sprintf ( gettext ( "%s: Unknown method %s" ) , ...
      "lowdisc_next" , this.method);
      error(errmsg);
    end
    next(i,1:this.dimension) = onevector
    // Leap over (i.e. ignore) as many elements as required
    if ( this.leap > 0 ) then
      [ this , ignored ] = lowdisc_terms ( this , this.leap )
    end
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
  k = find(this.primeslist>= this.dimension,1)
  if (k == []) then
    errmsg = sprintf( gettext ( "%s: The dimension %d is larger than any prime in the table. Configure the -primeslist option to increase the prime table." ) , ...
      "_next_faure" , this.dimension);
    error(errmsg);
  end
  basis  = this.primeslist ( k )
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
    next(idim) = lowdisc_vdcinv (this.sequenceindex,basis)
  end
endfunction
//
// _next_reversehaltonf --
//   Returns the next value of the Fast reverse Halton
//   sequence.
// Arguments:
//
function [ this , next ] = _next_reversehaltonf ( this )
  next = _lowdisc_revhaltf ( this.sequenceindex )
endfunction
//
// _next_haltonf --
//   Returns the next value of the Fast Halton
//   sequence.
// Arguments:
//
function [ this , next ] = _next_haltonf ( this )
  next = _lowdisc_haltonf ( this.sequenceindex );
endfunction
//
// _next_fauref --
//   Returns the next value of the Fast Faure
//   sequence.
// Arguments:
//
function [ this , next ] = _next_fauref ( this )
  next = _lowdisc_fauref ( this.sequenceindex );
endfunction
//
// _next_sobolf --
//   Returns the next value of the Fast Sobol
//   sequence.
// Arguments:
//
function [ this , next ] = _next_sobolf ( this )
  next = _lowdisc_sobolf ( this.sequenceindex )
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


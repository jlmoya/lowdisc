// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

function [this,next] = ldfaure_next ( varargin )

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
    onevector = _next_faure (this);
    next(i,1:this.dimension) = onevector
    // Leap over (i.e. ignore) as many elements as required
    if ( this.leap > 0 ) then
      for j = 1 : this.leap
        this.sequenceindex = this.sequenceindex + 1;
        onevector = _next_faure (this);
      end
    end
  end
endfunction
//
// _next_faure --
//   Returns the next term of the Faure sequence
// References
//   Monte-Carlo methods in Financial Engineering, Paul Glasserman
// Test : fauresequence ( 4 , 3 , 3 ) = [4/9 7/9 1/9]
// Caution !
//   This implementation is not protected against overflow.
//   Practically, we did not experience any problem with 
//   that specific issue.
//   If that point was being an issue, we could use
//   as in TOMS 647, the Faure matrix modulo the basis.
//   To do this, it suffices to pass the basis to the fauremat
//   function and to use binomialmod instead of binomial.
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
  digits = lowdisc_bary ( this.sequenceindex , basis , "bigendian" )
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
//
function c = _fauremat ( r , i )
  for m = 1:r
    for n = 1:r
      if ( m <= n ) then
        c(m,n) = i^(n-m) * lowdisc_binomial ( n-1 , m-1 );
      end
    end
  end
endfunction



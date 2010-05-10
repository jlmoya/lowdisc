// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

function [this,next] = ldhalton_next ( varargin )

  [lhs,rhs]=argn();
  if ( rhs > 2 ) then
    errmsg = msprintf(gettext("%s: Unexpected number of input arguments : %d provided while from 1 or 2 are expected."), "ldhalton_next", rhs);
    error(errmsg)
  end
  
  this = varargin(1)
  if ( rhs < 2 ) then
    imax = 1
  else
    imax = varargin(2)
  end
  
  if ( this.startedup == 0 ) then
    errmsg = msprintf(gettext("%s: The sequence is not started up. Call ldhalton_startup first."), "ldhalton_next");
    error(errmsg)
  end

  next = zeros(imax,this.dimension)
  
  for i=1:imax
    this.sequenceindex = this.sequenceindex + 1;
    onevector = _next_halton (this);
    next(i,1:this.dimension) = onevector
    for j = 1 : this.leap
      this.sequenceindex = this.sequenceindex + 1;
      onevector = _next_halton (this);
    end
  end
endfunction

function next = _next_halton (this)
  next = zeros(1:this.dimension);
  for idim=1:this.dimension
    basis = this.primeslist(idim);
    next(idim) = _vdc (this.sequenceindex,basis);
  end
endfunction


//
// Note for Van Der Corput sequence :
// * The name has been truncated from lowdisc_ldvandercorput to 
// fit in 24 characters
// * The current index i is decomposed in the basis as :
// i = d0 b^0 + d1 b^1 + d2 b^2 + ... + dn b^n
// with dn the last digit in the decomposition and b the basis.
// The result is computed by reversing the digits and scaling by b^n :
// r = d0 b^-1 + d1 b^-2 + ... + dn b^(-n-1)
// * Example : i = 11 or 1010 in binary because 
// 11 = 1 * 2^3 + 0 * 2^2 + 1 * 2^1 + 0 * 2^0
// so d0 = 0, d1 = 1, d2 = 0, d3 = 1
// Then r = 0 * 2^-1 + 1 * 2^-2 + 0 * 2^-3 + 1 * 2^-4 = 5/16
// * The digits of i are computed with an incremental process, by
// using the remainder modulo b and dividing by b.
// The digits are therefore computed in the order : d0, d1,..., dn.
// * The result r is initialized with value 0.
// As they are computed, the terms di b^(-i-1) are added to the
// result r.
// * The terms ib = b^(-i-1), called inversed basis (or inverse radix in 
// Halton & Smith 1964 paper) are computed incrementally.
// The inversed basis ib is initialized with value 1/b = b^-1.
// It is updated by division by basis.
// This is also explained in :
//   http://orion.math.iastate.edu/reu/2001/voronoi/halton_sequence.html
// and used in :
//   https://people.scs.fsu.edu/~burkardt/m_src/van_der_corput/van_der_corput.html
//
//    J H Halton and G B Smith,
//    Algorithm 247: Radical-Inverse Quasi-Random Point Sequence,
//    Communications of the ACM,
//    Volume 7, 1964, pages 701-702.

//
// _vdc --
//   Returns the term #i of the Van Der Corput low discrepancy sequence in 
//   given basis.
// Arguments, input
//   i : the index in the sequence
//   basis : the basis of the sequence
// Arguments, output
//   result : the next element in the sequence, uniform in [0,1]
// _vdc ( 0 , 2 ) = 0.0
// _vdc ( 1 , 2 ) =0.5
// _vdc ( 2 , 2 ) = 0.25
// _vdc ( 3 , 2 ) = 0.75
// _vdc ( 4 , 2 ) = 0.125
// _vdc ( 5 , 2 ) = 0.625
//
function result = _vdc ( i , basis )
  if (basis<2) then
    errmsg = sprintf ( gettext ( "%s: Unexpected basis" ) , "_vdc" , basis);
    error(errmsg);
  end
  current = i;
  ib = 1.0 / basis;
  result = 0.0;
  while (current>0)
    digit = modulo ( current , basis );
    current = int ( current / basis );
    result = result + digit * ib;
    ib = ib / basis;
  end
endfunction


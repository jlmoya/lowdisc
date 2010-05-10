// Copyright (C) 2008-2009 - INRIA - Michael Baudin

// This file must be used under the terms of the GNU LGPL license.


//
// lowdisc_vdcinv --
//   Returns the term #i of the inverted Van Der Corput low discrepancy sequence in 
//   given basis.
// Arguments, input
//   i : the index in the sequence
//   basis : the basis of the sequence
// Arguments, output
//   result : the next element in the sequence, uniform in [0,1]
//
function result = lowdisc_vdcinv ( i , basis )
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


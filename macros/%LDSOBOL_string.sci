// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





//
// %LDSOBOL_string --
//   Returns the string containing the low discrepancy sequence
//
function str = %LDSOBOL_string ( this )
  str = []
  k = 1
  str(k) = msprintf("Low Discrepancy Sequence: Sobol")
  k = k + 1
  str(k) = msprintf("=========================")
  k = k + 1
  str(k) = msprintf("Maximum dimension = %d",this.dimmax)
  k = k + 1
  str(k) = msprintf("Maximum number of simulations = %e",this.nbsimmax)
  k = k + 1
  str(k) = msprintf("count = %d",this.count)
  k = k + 1
  str(k) = msprintf("maxcol = %d",this.maxcol)
  k = k + 1
  str(k) = msprintf("lastq = %s",_tostring ( this.lastq ))
  k = k + 1
  str(k) = msprintf("recipd = %e",this.recipd)
  k = k + 1
  //
  // Get the baseobj string
  str(k) = ""
  k = k + 1
  objstr = string(this.baseobj)
  str(k : k + size(objstr,"r") - 1 ) = objstr
endfunction

function s = _tostring ( x )
  if ( x==[] ) then
    s = "[]"
  else
    n = size ( x , "*" )
    if ( n == 1 ) then
      s = string(x)
    else
      s = "["+strcat(string(x)," ")+"]"
    end
  end
endfunction



// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





//
// %LDHALTON_string --
//   Returns the string containing the low discrepancy sequence
//
function str = %LDHALTON_string ( this )
  str = []
  k = 1
  str(k) = msprintf("Low Discrepancy Sequence: Halton")
  k = k + 1
  str(k) = msprintf("=========================")
  k = k + 1
  nbp = size(this.primeslist,"*")
  if ( nbp > 10 ) then
    str(k) = msprintf("Primes List (%d primes): %s %s\n", nbp , _tostring(this.primeslist(1:10)),"...")
  else
    str(k) = msprintf("Primes List (%d primes): %s\n", nbp , _tostring(this.primeslist))
  end
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



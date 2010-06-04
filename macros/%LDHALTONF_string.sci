// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





//
// %LDHALTONF_string --
//   Returns the string containing the low discrepancy sequence
//
function str = %LDHALTONF_string ( this )
  str = []
  k = 1
  str(k) = sprintf("Low Discrepancy Sequence: Halton Fast")
  k = k + 1
  str(k) = sprintf("=========================")
  k = k + 1
  nbp = size(this.primeslist,"*")
  if ( nbp > 10 ) then
    str(k) = sprintf("Primes List (%d primes): %s %s\n", nbp , _tostring(this.primeslist(1:10)),"...")
  else
    str(k) = sprintf("Primes List (%d primes): %s\n", nbp , _tostring(this.primeslist))
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



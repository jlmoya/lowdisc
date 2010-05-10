// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

//
// %LDREVHALF_string --
//   Returns the string containing the low discrepancy sequence
//
function str = %LDREVHALF_string ( this )
  str = []
  k = 1
  str(k) = sprintf("Low Discrepancy Sequence: Fast Reverse Halton")
  k = k + 1
  str(k) = sprintf("=========================")
  k = k + 1
  str(k) = sprintf("Dimension of space: %s\n", _tostring(this.dimension))
  k = k + 1
  str(k) = sprintf("Sequence Index: %s\n", _tostring(this.sequenceindex))
  k = k + 1
  str(k) = sprintf("Verbose logging: %s\n", _tostring(this.verbose))
  k = k + 1
  str(k) = sprintf("Skip: %s\n", _tostring(this.skip))
  k = k + 1
  str(k) = sprintf("Leap: %s\n", _tostring(this.leap))
  k = k + 1
  nbp = size(this.primeslist,"*")
  if ( nbp > 10 ) then
    str(k) = sprintf("Primes List (%d primes): %s %s\n", nbp , _tostring(this.primeslist(1:10)),"...")
  else
    str(k) = sprintf("Primes List (%d primes): %s\n", nbp , _tostring(this.primeslist))
  end
  k = k + 1
  str(k) = sprintf("Started Up: %s\n", _tostring(this.startedup))
  k = k + 1
endfunction

function bool = _mlist_isfield ( s , fieldname ) 
  // Get the matrix of integers representing defined fields
  df = definedfields ( s )
  // Search for the index ifield associated with given fieldname
  ifield = find(s(1)==fieldname)
  // Search for ifield in the matrix of defined fields
  jj = find(df==ifield)
  bool = jj <> []
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



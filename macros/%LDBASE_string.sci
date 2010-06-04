// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





//
// %LDBASE_string --
//   Returns the string containing the low discrepancy sequence
//
function str = %LDBASE_string ( this )
  str = []
  k = 1
  str(k) = sprintf("Abstract Low Discrepancy Sequence:")
  k = k + 1
  str(k) = sprintf("=========================")
  k = k + 1
  str(k) = sprintf("Dimension of space: %s\n", _tostring(this.dimension))
  k = k + 1
  str(k) = sprintf("Index: %s\n", _tostring(this.index))
  k = k + 1
  str(k) = sprintf("Verbose logging: %s\n", _tostring(this.verbose))
  k = k + 1
  str(k) = sprintf("Skip: %s\n", _tostring(this.skip))
  k = k + 1
  str(k) = sprintf("Leap: %s\n", _tostring(this.leap))
  k = k + 1
  str(k) = sprintf("Started Up: %s\n", _tostring(this.startedup))
  k = k + 1
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



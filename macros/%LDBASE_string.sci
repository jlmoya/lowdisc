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
  str(k) = msprintf("Abstract Low Discrepancy Sequence:")
  k = k + 1
  str(k) = msprintf("=========================")
  k = k + 1
  str(k) = msprintf("Dimension of space: %s\n", _tostring(this.dimension))
  k = k + 1
  str(k) = msprintf("Index: %s\n", _tostring(this.index))
  k = k + 1
  str(k) = msprintf("Verbose logging: %s\n", _tostring(this.verbose))
  k = k + 1
  str(k) = msprintf("Skip: %s\n", _tostring(this.skip))
  k = k + 1
  str(k) = msprintf("Leap: %s\n", _tostring(this.leap))
  k = k + 1
  str(k) = msprintf("Started Up: %s\n", _tostring(this.startedup))
  k = k + 1
  str(k) = msprintf("Speed: %s\n", _tostring(this.speed))
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



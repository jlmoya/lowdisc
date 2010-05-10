// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

//
// %LOWDISC_string --
//   Returns the string containing the low discrepancy sequence
//
function str = %LOWDISC_string ( this )
  str = []
  k = 1
  str(k) = sprintf("Low Discrepancy Sequence:")
  k = k + 1
  str(k) = sprintf("=========================")
  k = k + 1
  str(k) = sprintf("method: %s\n", _tostring(this.method))
  k = k + 1
  str(k) = sprintf("sequence: <a Low Discrepancy Sequence>\n")
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



// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





//
// %LOWDISC_string --
//   Returns the string containing the low discrepancy sequence
//
function str = %LOWDISC_string ( this )
  str = []
  k = 1
  str(k) = msprintf("Low Discrepancy Sequence:")
  k = k + 1
  str(k) = msprintf("=========================")
  k = k + 1
  str(k) = msprintf("method: %s\n", _tostring(this.method))
  k = k + 1
  str(k) = msprintf("sequence: <a Low Discrepancy Sequence>\n")
  k = k + 1
  //
  // Get the sequence string
  str(k) = ""
  k = k + 1
  seqstr = string(this.sequence)
  nbrows = size(seqstr,"r")
  for i = 1 : nbrows
    str(k) = seqstr(i)
    k = k + 1
  end
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



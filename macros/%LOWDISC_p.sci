// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





//
// %LOWDISC_p --
//   Prints the string containing the low discrepancy sequence
//
function %LOWDISC_p ( this )
  str = string(this)
  nbrows = size(str,"r")
  for i = 1 : nbrows
    mprintf("%s\n",str(i))
  end
endfunction


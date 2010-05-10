// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





//
// lowdisc_print --
//   Prints the string containing the low discrepancy sequence
//
function lowdisc_print ( this )
  str = string(this)
  nbrows = size(str,"r")
  for i = 1 : nbrows
    mprintf("%s\n",str(i))
  end
endfunction


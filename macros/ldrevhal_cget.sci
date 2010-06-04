// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function value = ldrevhal_cget (this,key)

  select key
  case "-primeslist" then
    value = this.primeslist;
  else
    // Delegate to ldbase
    value = ldbase_cget ( this.baseobj , key )
  end
endfunction


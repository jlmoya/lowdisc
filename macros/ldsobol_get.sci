// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function value = ldsobol_get (this,key)
  select key
  case "-dimmax" then
    value = this.dimmax
  case "-nbsimmax" then
    value = this.nbsimmax
  else
    // Delegate to ldbase
    value = ldbase_get ( this.baseobj , key )
  end
endfunction


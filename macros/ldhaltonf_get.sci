// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function value = ldhaltonf_get (this,key)
  select key
  case "-dimmax" then
    value = this.primessize
  case "-nbsimmax" then
    value = this.nbsimmax
  case "-scrambling" then
    value = this.scrambling
  else
    // Delegate to ldbase
    value = ldbase_get ( this.baseobj , key )
  end
endfunction


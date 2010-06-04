// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function this = ldsobol_destroy (this)
  // Delegate to ldbase
  this.baseobj = ldbase_destroy ( this.baseobj )
endfunction


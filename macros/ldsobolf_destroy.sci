// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function this = ldsobolf_destroy (this)
  if ( ldbase_get ( this.baseobj , "-startedup" ) ) then
    _lowdisc_sobolfstop ( );
  end
  // Delegate to ldbase
  this.baseobj = ldbase_destroy ( this.baseobj )
endfunction


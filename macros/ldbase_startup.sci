// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function this = ldbase_startup (this)
  if (this.startedup) then
    errmsg = sprintf( gettext ( "%s: Startup can only be run once." ) , "ldbase_startup" );
    error(errmsg);
  end
  if (this.verbose) then
    mprintf( "Starting up the sequence." );
  end
  this.startedup = %t;
  this.index = 0;
endfunction


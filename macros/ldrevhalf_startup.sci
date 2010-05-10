// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

function this = ldrevhalf_startup (this)
  
  if (this.startedup<>0) then
    errmsg = sprintf( gettext ( "%s: Startup can only be run once." ) , "lowdisc_startup" );
    error(errmsg);
  end
  if (this.verbose) then
    mprintf( "Starting up the sequence." );
  end
  this.startedup = 1;
  _lowdisc_revhaltfstart ( this.dimension , this.primeslist(1:this.dimension) );
  // Initialize the sequence
  this.sequenceindex = 0;
  // Skip (i.e. ignore) as many elements as required
  // TODO : skip directly when sequence authorizes it.
  if ( this.skip > 0 ) then
    [ this , result ] = ldrevhalf_next ( this , this.skip )
  end
endfunction


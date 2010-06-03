// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
//    This code is distributed under the GNU LGPL license.

function this = ldniedf_startup (this)
// ldniedf_startup --
//  Startup Fast Niederreiter's sequence.
//
//  Licensing:
//    This code is distributed under the GNU LGPL license.
//
//  Author:
//       2010 - Digiteo - Michael Baudin
//
  
  if (this.startedup<>0) then
    errmsg = sprintf( gettext ( "%s: Startup can only be run once." ) , "ldniedf_startup" );
    error(errmsg);
  end
  if (this.verbose) then
    mprintf( "Starting up the sequence." );
  end
  this.startedup = 1;
  //
  // Create the sequence
  //
  // Start the sequence
  _lowdisc_niedfstart ( this.dimension , this.base , skip , this.gfaritfile , this.gfplysfile );
  //
  // Initialize the sequence at the right place
  this.sequenceindex = skip;
endfunction


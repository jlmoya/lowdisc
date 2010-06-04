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
  
  this.baseobj = ldbase_startup ( this.baseobj )
  //
  // Create the sequence
  skip = ldbase_cget ( this.baseobj , "-skip" )
  dimension = ldbase_cget ( this.baseobj , "-dimension" )
  _lowdisc_niedfstart ( dimension , this.base , skip , this.gfaritfile , this.gfplysfile );
  //
  // Initialize the sequence at the right place
  // TODO : test this
  this.baseobj = ldbase_indexset ( this.baseobj , skip )
endfunction


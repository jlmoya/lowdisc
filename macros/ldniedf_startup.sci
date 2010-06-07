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
  // We ignore the first element in the sequence, which is [0 0] in dimension 2.
  // Our Niederreiter sequence starts with [0.5 0.5] in 2 dimensions.
  // This is why we add 1 to the skip.
  skip = ldbase_cget ( this.baseobj , "-skip" )
  dimension = ldbase_cget ( this.baseobj , "-dimension" )
  _lowdisc_niedfstart ( dimension , this.base , skip + 1 , this.gfaritfile , this.gfplysfile );
  //
  // Initialize the sequence at the right place
  // TODO : test this
  this.baseobj = ldbase_indexset ( this.baseobj , skip )
endfunction


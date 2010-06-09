// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function this = ldrevhal_startup (this)
  
  this.baseobj = ldbase_startup ( this.baseobj )
  //
  // Create the sequence
  //
  dimension = ldbase_cget ( this.baseobj , "-dimension" )
  if ( dimension > this.primessize ) then
    errmsg = msprintf ( gettext ( "%s: The %s method is not available for %d dimension because the database contains only %d primes"), "ldrevhal_startup" , "reverse Halton" ,dimension,this.primessize);
    error(errmsg);
  end
  //
  skip = ldbase_cget ( this.baseobj , "-skip" )
  if ( skip > 0 ) then
    // Skip (i.e. ignore) as many elements as required
    // Directly set the index.
    this.baseobj = ldbase_indexset ( this.baseobj , skip )
  end
endfunction






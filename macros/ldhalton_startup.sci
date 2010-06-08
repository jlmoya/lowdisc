// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function this = ldhalton_startup (this)
  
  this.baseobj = ldbase_startup ( this.baseobj )
  //
  // Create the sequence
  //
    dimension = ldbase_cget ( this.baseobj , "-dimension" )
    if ( dimension > this.primessize ) then
      errmsg = msprintf( gettext ( "%s: The %s method is not available for %d dimension because the database contains only %d primes" ), "ldhalton_startup" , "halton",dimension,this.primessize);
      error(errmsg);
    end
  // Skip (i.e. ignore) as many elements as required
  // TODO : skip directly when sequence authorizes it.
  skip = ldbase_cget ( this.baseobj , "-skip" )
  if ( skip > 0 ) then
    [ this , result ] = ldhalton_next ( this , skip )
  end
endfunction


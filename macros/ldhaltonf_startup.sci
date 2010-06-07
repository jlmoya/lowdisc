// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function this = ldhaltonf_startup (this)
  
  this.baseobj = ldbase_startup ( this.baseobj )
  //
    dimension = ldbase_cget ( this.baseobj , "-dimension" )
    seed = zeros(1,dimension);
    leap = ones(1,dimension);
    if ( dimension > this.primessize ) then
      errmsg = msprintf ( gettext ( "%s: The %s method is not available for %d dimension because the database contains only %d primes"), "ldhaltonf_startup" , this.method,dimension,this.primessize);
      error(errmsg);
    end
    base = this.primeslist(1:dimension);
    _lowdisc_haltonfstart ( dimension , base , seed , leap );
  // Skip (i.e. ignore) as many elements as required
  // TODO : skip directly when sequence authorizes it.
  skip = ldbase_cget ( this.baseobj , "-skip" )
  if ( skip > 0 ) then
    [ this , result ] = ldhaltonf_next ( this , skip )
  end
endfunction


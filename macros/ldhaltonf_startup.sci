// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function this = ldhaltonf_startup (this)
  
  this.baseobj = ldbase_startup ( this.baseobj )
  //
  dimension = ldbase_cget ( this.baseobj , "-dimension" )
  if ( dimension > this.primessize ) then
    errmsg = msprintf ( gettext ( "%s: The %s method is not available for %d dimension because the database contains only %d primes"), "ldhaltonf_startup" , "fast reverse Halton",dimension,this.primessize);
    error(errmsg);
  end
  //
  base = this.primeslist(1:dimension)
  leap = ones(1,dimension)
  //
  skip = ldbase_cget ( this.baseobj , "-skip" )
  if ( skip > 0 ) then
    // Skip (i.e. ignore) as many elements as required
    // Set the seed accordingly and skip directly the elements.
    seed = ones(1,dimension) * skip
    _lowdisc_haltonfstart ( dimension , base , seed , leap )
  else
    seed = zeros(1,dimension)
    _lowdisc_haltonfstart ( dimension , base , seed , leap )
  end
endfunction



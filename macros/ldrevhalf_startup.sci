// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function this = ldrevhalf_startup (this)
  this.baseobj = ldbase_startup ( this.baseobj )
  dimension = ldbase_cget ( this.baseobj , "-dimension" )
  if (dimension>this.primessize) then
    errmsg = msprintf( gettext ( "%s: Reverse Halton sequence : the dimension %d is larger than any prime in the table. Configure the -primeslist option to increase the prime table." ) , "ldrevhalf_startup" , dimension);
    error(errmsg);
  end
  //
  _lowdisc_revhaltfstart ( dimension , this.primeslist(1:dimension) )
  //
  skip = ldbase_cget ( this.baseobj , "-skip" )
  if ( skip > 0 ) then
    // Skip (i.e. ignore) as many elements as required
    // Directly set the index.
    this.baseobj = ldbase_indexset ( this.baseobj , skip )
  end
endfunction


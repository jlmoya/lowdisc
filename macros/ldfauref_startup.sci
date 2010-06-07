// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function this = ldfauref_startup (this)
  
  this.baseobj = ldbase_startup ( this.baseobj )
  //
  // Create the sequence
  //
    dimension = ldbase_cget ( this.baseobj , "-dimension" )
    k = find(this.primeslist>=dimension,1)
    if (k == []) then
      errmsg = msprintf( gettext ( "%s: Faure Fast sequence : the dimension %d is larger than any prime in the table. Configure the -primeslist option to increase the prime table." ) , "ldfauref_startup" , dimension);
      error(errmsg);
    end
    qs = this.primeslist(k)
    _lowdisc_faurefstart ( dimension , qs )
  // Skip (i.e. ignore) as many elements as required
  // TODO : skip directly when sequence authorizes it.
  skip = ldbase_cget ( this.baseobj , "-skip" )
  if ( skip > 0 ) then
    [ this , result ] = ldfauref_next ( this , skip )
  end
endfunction


// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function this = ldfaure_startup (this)
  this.baseobj = ldbase_startup ( this.baseobj )
  //
  // Create the sequence
  //
  dimension = ldbase_cget ( this.baseobj , "-dimension" )
  k = find(this.primeslist>=dimension,1)
  if (k == []) then
    errmsg = msprintf( gettext ( "%s: Faure sequence : the dimension %d is larger than any prime in the table. Configure the -primeslist option to increase the prime table." ) , "ldfaure_startup" , dimension);
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


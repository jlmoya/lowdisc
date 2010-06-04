// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function this = ldsobolf_startup (this)
  
  this.baseobj = ldbase_startup ( this.baseobj )
  dimension = ldbase_cget ( this.baseobj , "-dimension" )
  _lowdisc_sobolfstart ( dimension );
  // Skip (i.e. ignore) as many elements as required
  // TODO : skip directly when sequence authorizes it.
  skip = ldbase_cget ( this.baseobj , "-skip" )
  if ( skip > 0 ) then
    [ this , result ] = ldsobolf_next ( this , skip )
  end
endfunction


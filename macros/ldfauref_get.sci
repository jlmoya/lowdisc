// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function value = ldfauref_get (this,key)

  select key
  case "-faurefprime" then
    dimension = ldbase_cget ( this.baseobj , "-dimension" )
    k = find(this.primeslist>=dimension,1)
    if (k == []) then
      errmsg = msprintf( gettext ( "%s: The dimension %d is larger than any prime in the table. Configure the -primeslist option to increase the prime table." ) , ...
        "ldfauref_get" , dimension);
      error(errmsg);
    end
    value  = this.primeslist ( k )
  else
    // Delegate to ldbase
    value = ldbase_get ( this.baseobj , key )
  end
endfunction


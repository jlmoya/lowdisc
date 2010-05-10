// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function value = ldfaure_get (this,key)

  select key
  case "-faureprime" then
    k = find(this.primeslist>=this.dimension,1)
    if (k == []) then
      errmsg = sprintf( gettext ( "%s: The dimension %d is larger than any prime in the table. Configure the -primeslist option to increase the prime table." ) , ...
        "lowdisc_get" , this.dimension);
      error(errmsg);
    end
    value  = this.primeslist ( k )
  else
    errmsg = sprintf(gettext("%s: Unknown key %s"),"ldfaure_get",key);
    error(errmsg);
  end
endfunction


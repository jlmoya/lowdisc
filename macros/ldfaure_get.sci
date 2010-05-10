// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

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
    errmsg = sprintf("Unknown key %s",key);
    error(errmsg);
  end
endfunction


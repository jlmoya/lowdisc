// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

function value = ldsobolf_get (this,key)

  select key
  else
    errmsg = sprintf(gettext("%s: Unknown key %s"),"lowdisc_get",key);
    error(errmsg);
  end
endfunction


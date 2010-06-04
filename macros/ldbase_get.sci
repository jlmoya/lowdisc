// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function value = ldbase_get ( this , key )
  select key
  case "-startedup" then
    value = this.startedup
  case "-index" then
    value = this.index
  else
    errmsg = sprintf(gettext("%s: Unknown key %s"),"ldbase_get",key);
    error(errmsg);
  end
endfunction


// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function value = ldbase_cget (this,key)

  select key
  case "-verbose" then
    value = this.verbose;
  case "-dimension" then
    value = this.dimension;
  case "-skip" then
    value = this.skip;
  case "-leap" then
    value = this.leap;
  else
    errmsg = msprintf(gettext("%s: Unknown key %s"),"ldbase_cget",key);
    error(errmsg);
  end
endfunction


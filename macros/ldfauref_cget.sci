// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function value = ldfauref_cget (this,key)

  select key
  case "-verbose" then
    value = this.verbose;
  case "-dimension" then
    value = this.dimension;
  case "-sequenceindex" then
    value = this.sequenceindex;
  case "-primeslist" then
    value = this.primeslist;
  case "-skip" then
    value = this.skip;
  case "-leap" then
    value = this.leap;
  else
    errmsg = sprintf(gettext("%s: Unknown key %s"),"ldfauref_cget",key);
    error(errmsg);
  end
endfunction


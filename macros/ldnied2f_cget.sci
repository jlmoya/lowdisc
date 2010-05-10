// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

function value = ldnied2f_cget (this,key)

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
    errmsg = sprintf(gettext("%s: Unknown key %s"),"ldnied2f_cget",key);
    error(errmsg);
  end
endfunction


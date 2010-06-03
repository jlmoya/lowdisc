// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function value = ldniedf_get (this,key)
    errmsg = sprintf(gettext("%s: Unknown key %s"),"ldniedf_get",key);
    error(errmsg);
endfunction


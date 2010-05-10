// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function value = ldrevhal_get (this,key)
    errmsg = sprintf(gettext("%s: Unknown key %s"),"ldrevhal_get",key);
    error(errmsg);
endfunction


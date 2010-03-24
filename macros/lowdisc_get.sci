// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

//
// lowdisc_get --
//   Quiery one not-configurable field.
//
function value = lowdisc_get (this,key)
  select key
  case "-faureprime" then
    value = this.fauredim2prime(this.dimension);
  case "-faurefprime" then
    value = _lowdisc_faureprimege ( this.dimension );
  else
    errmsg = sprintf("Unknown key %s",key);
    error(errmsg);
  end
endfunction


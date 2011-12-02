// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function this = ldniedf_configure (this,key,value)

  select key
  case "-base" then
    apifun_checktype ( "ldniedf_configure" , value , "value" , 3 , "constant" )
    apifun_checkscalar ( "ldniedf_configure" , value , "value" , 3 )
    apifun_checkflint ( "ldniedf_configure" , value , "value" , 3 )
    apifun_checkgreq ( "ldniedf_configure" , value , "value" , 3 , 1 )
    this.base = value;
  else
    // Delegate to ldbase
    this.baseobj = ldbase_configure ( this.baseobj , key ,value )
  end
endfunction

// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function this = ldrevhalf_configure (this,key,value)
  select key
  case "-primeslist" then
    apifun_checktype ( "ldrevhalf_configure" , value , "value" , 3 , "constant" )
    apifun_checkvector ( "ldrevhalf_configure" , value , "value" , 3 )
    apifun_checkflint ( "ldrevhalf_configure" , value , "value" , 3 )
    apifun_checkgreq ( "ldrevhalf_configure" , value , "value" , 3 , 1 )
    this.primeslist = value(:)';
    this.primessize = size(value,"*");
  else
    // Delegate to ldbase
    this.baseobj = ldbase_configure ( this.baseobj , key ,value )
  end
endfunction

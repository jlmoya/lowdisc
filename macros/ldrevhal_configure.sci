// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function this = ldrevhal_configure (this,key,value)
  [lhs, rhs] = argn()
  apifun_checkrhs ( "ldrevhal_configure" , rhs , 3:3 )
  apifun_checklhs ( "ldrevhal_configure" , lhs , 1 )
  //
  select key
  case "-primeslist" then
    apifun_checktype ( "ldrevhal_configure" , value , "value" , 3 , "constant" )
    apifun_checkvector ( "ldrevhal_configure" , value , "value" , 3 )
    apifun_checkflint ( "ldrevhal_configure" , value , "value" , 3 )
    apifun_checkgreq ( "ldrevhal_configure" , value , "value" , 3 , 1 )
    this.primeslist = value(:)';
    this.primessize = size(value,"*");
  else
    // Delegate to ldbase
    this.baseobj = ldbase_configure ( this.baseobj , key ,value )
  end
endfunction

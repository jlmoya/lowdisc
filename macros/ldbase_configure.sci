// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function this = ldbase_configure (this,key,value)

  [lhs, rhs] = argn()
  apifun_checkrhs ( "ldbase_configure" , rhs , 3:3 )
  apifun_checklhs ( "ldbase_configure" , lhs , 1 )
  //
  apifun_checktype ( "ldbase_configure" , this , "this" , 1 , "LDBASE" )
  apifun_checktype ( "ldbase_configure" , key , "key" , 2 , "string" )
  apifun_checkscalar ( "ldbase_configure" , key , "key" , 2 )
  //
  select key
  case "-verbose" then
    apifun_checktype ( "ldbase_configure" , value , "value" , 3 , "boolean" )
    apifun_checkscalar ( "ldbase_configure" , value , "value" , 3 )
    this.verbose = value
  case "-dimension" then
    apifun_checktype ( "ldbase_configure" , value , "value" , 3 , "constant" )
    apifun_checkscalar ( "ldbase_configure" , value , "value" , 3 )
    apifun_checkgreq ( "ldbase_configure" , value , "value" , 3 , 1 )
    this.dimension = value
  case "-skip" then
    apifun_checktype ( "ldbase_configure" , value , "value" , 3 , "constant" )
    apifun_checkscalar ( "ldbase_configure" , value , "value" , 3 )
    apifun_checkgreq ( "ldbase_configure" , value , "value" , 3 , 0 )
    this.skip = value;
  case "-leap" then
    apifun_checktype ( "ldbase_configure" , value , "value" , 3 , "constant" )
    apifun_checkscalar ( "ldbase_configure" , value , "value" , 3 )
    apifun_checkgreq ( "ldbase_configure" , value , "value" , 3 , 0 )
    this.leap = value;
  else
    errmsg = msprintf ( gettext ( "%s: Unknown key %s" ) , "ldbase_configure" , key)
    error(errmsg)
  end
endfunction

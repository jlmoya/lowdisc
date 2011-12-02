// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function this = ldbase_new ( speed )

  [lhs, rhs] = argn()
  apifun_checkrhs ( "ldbase_new" , rhs , 1:1 )
  apifun_checklhs ( "ldbase_new" , lhs , 1 )
  //
  apifun_checktype ( "ldbase_configure" , speed , "speed" , 1 , "string" )
  apifun_checkscalar ( "ldbase_configure" , speed , "speed" , 1 )
  apifun_checkoption ( "ldbase_configure" , speed , "speed" , 1 , ["fast" "slow"] )
  //
  this = tlist([
    "LDBASE"
    "verbose"
    "dimension"
    "index"
    "startedup"
    "skip"
    "leap"
    "speed"
    ])
  //
  // Configurable options
  this.verbose=%f
  this.dimension=1
  this.index=0
  this.skip = 0
  this.leap = 0
  this.startedup = %f
  this.speed = speed
endfunction

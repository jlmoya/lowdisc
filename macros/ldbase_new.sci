// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function this = ldbase_new ( speed )

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
  assert_typestring ( speed )
  this.speed = speed
endfunction


// Generates an error if the given variable is not of type string
function assert_typestring ( var )
  if ( type ( var ) <> 10 ) then
    errmsg = msprintf(gettext("%s: Expected string variable but got %s instead"),"assert_typestring", typeof(var) );
    error(errmsg);
  end
endfunction


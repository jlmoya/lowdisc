// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function this = ldbase_new ()

  this = tlist([
    "LDBASE"
    "verbose"
    "dimension"
    "index"
    "startedup"
    "skip"
    "leap"
    ])
  //
  // Configurable options
  this.verbose=%f
  this.dimension=1
  this.index=0
  this.skip = 0
  this.leap = 0
  this.startedup = %f
endfunction



// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function this = ldsobolf_new ()

  this = tlist([
    "LDSOBOLF"
    "baseobj"
    "dimmax"
    "nbsimmax"
    ])
  this.baseobj = ldbase_new ( "fast" )
  this.dimmax = 1111
  this.nbsimmax = 2^30 - 1
endfunction



// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function this = ldsobol_new ()
  // Create a new Sobol object.
  //

  this = tlist([
    "LDSOBOL"
    "baseobj"
    "v"
    "maxcol"
    "lastq"
    "recipd"
    "count"
    "dimmax"
    "nbsimmax"
    ])
  this.baseobj = ldbase_new ()
  this.dimmax = 40
  this.nbsimmax = 2^30 - 1
  this.v = []
  this.maxcol = 0
  this.lastq = []
  this.recipd = 0
  this.count = 0
endfunction



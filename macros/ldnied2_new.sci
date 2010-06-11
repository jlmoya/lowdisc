// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





// TODO : rename the "cj", "seed", "nextq", "recip", "nbits" fields
// TODO : remove the field seed, which should be replaced by the index

function this = ldnied2_new ()
  // Create a new Niederreiter Base 2 object.
  //

  this = tlist([
    "LDNIED2"
    "baseobj"
    "cj"
    "seed"
    "nextq"
    "recip"
    "nbits"
    "dimmax"
    "nbsimmax"
    "maxe"
    ])
  this.baseobj = ldbase_new ()
  this.dimmax = 20
  this.nbits = 31
  this.nbsimmax = 2^(this.nbits) - 1
  this.maxe = 6
endfunction



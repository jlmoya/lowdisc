// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function this = ldhalton_new ()
  this = tlist([
    "LDHALTON"
    "baseobj"
    "primeslist"
    "primessize"
    "nbsimmax"
    ])
  this.baseobj = ldbase_new ( "slow" )
  //
  // Configurable options
 // This makes the component available up to dimension 100
  this.primeslist = number_primes100 ( )
  //
  // Non Configurable options
  this.primessize = size(this.primeslist,2)
  this.nbsimmax = 2^52 - 1
endfunction



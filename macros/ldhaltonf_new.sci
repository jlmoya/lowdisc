// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function this = ldhaltonf_new ()

  this = tlist([
    "LDHALTONF"
    "baseobj"
    "primeslist"
    "primessize"
    "nbsimmax"
    ])
  this.baseobj = ldbase_new ()
  //
  // Configurable options
  // This makes the component available up to dimension 100
  this.primeslist = lowdisc_primes100 ( )
  //
  // Non Configurable options
  this.primessize = size(this.primeslist,2)
  this.nbsimmax = 2^31 - 1
endfunction



// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function this = ldfaure_new ()
  // Create a new Faure object.
  //

  this = tlist([
    "LDFAURE"
    "verbose"
    "dimension"
    "sequenceindex"
    "primeslist"
    "startedup"
    "primessize"
    "skip"
    "leap"
    ])
  //
  // Configurable options
  this.verbose=%f
  this.dimension=1
  this.sequenceindex=0
  // This makes the component available up to dimension 100
  this.primeslist = lowdisc_primes100 ( )
  this.skip = 0
  this.leap = 0
  //
  // Non Configurable options
  this.primessize = size(this.primeslist,2)
  this.startedup = 0
endfunction



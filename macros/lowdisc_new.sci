// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

function this = lowdisc_new ()
  // Create a new object.
  //
  // Calling Sequence
  //   this = lowdisc_new ()
  //
  // Parameters
  //   this: the current object
  //
  // Description
  //   This function requires to take the current object both as an input
  //   and an output argument.
  //
  // Examples
  //   rng = lowdisc_new();
  //   rng = lowdisc_configure(rng,"-method","faure");
  //   rng
  //   rng = lowdisc_destroy(rng);
  //
  // Authors
  //   Michael Baudin - 2008-2009 - INRIA
  //   Michael Baudin - 2010 - DIGITEO

  this = tlist([
    "LOWDISC"
    "verbose"
    "dimension"
    "method"
    "sequenceindex"
    "vdcbasis"
    "primeslist"
    "startedup"
    "primessize"
    "sobolv"
    "sobolmaxcol"
    "sobollastq"
    "sobolrecipd"
    "sobolcount"
    "NR_cj"
    "NR_seed"
    "NR_nextq"
    "NR_recip"
    "NR_nbits"
    "skip"
    "leap"
    ])
  //
  // Configurable options
  this.verbose=%f
  this.dimension=1
  this.method="halton"
  this.sequenceindex=0
  this.vdcbasis = 2
  // This makes the component available up to dimension 100
  this.primeslist = lowdisc_primes100 ( )
  this.skip = 0
  this.leap = 0
  //
  // Non Configurable options
  this.primessize = size(this.primeslist,2)
  this.startedup = 0
endfunction



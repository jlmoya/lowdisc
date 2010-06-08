// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





// TODO : rename the fields "sobolv", "sobolmaxcol", "sobollastq", "sobolrecipd", "sobolcount"
// TODO : remove the field sobolcount, which should be replaced by the index
function this = ldsobol_new ()
  // Create a new Sobol object.
  //

  this = tlist([
    "LDSOBOL"
    "baseobj"
    "sobolv"
    "sobolmaxcol"
    "sobollastq"
    "sobolrecipd"
    "sobolcount"
    "dimmax"
    "nbsimmax"
    ])
  this.baseobj = ldbase_new ()
  this.dimmax = 40
  this.nbsimmax = 2^30 - 1
endfunction



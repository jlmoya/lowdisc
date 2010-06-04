// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





// TODO : rename the "NR_cj", "NR_seed", "NR_nextq", "NR_recip", "NR_nbits" fields
// TODO : remove the field NR_seed, which should be replaced by the index

function this = ldnied2_new ()
  // Create a new Niederreiter Base 2 object.
  //

  this = tlist([
    "LDNIED2"
    "baseobj"
    "NR_cj"
    "NR_seed"
    "NR_nextq"
    "NR_recip"
    "NR_nbits"
    ])
  this.baseobj = ldbase_new ()
endfunction



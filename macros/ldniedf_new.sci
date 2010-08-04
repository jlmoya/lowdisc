// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function this = ldniedf_new ()
  // Create a new Fast Niederreiter Arbitrary Base object.
  //

  this = tlist([
    "LDNIEDF"
    "baseobj"
    "base"
    "gfaritfile"
    "gfplysfile"
    "dimmax"
    "nbsimmax"
    ])
  this.baseobj = ldbase_new ( "fast" )
  //
  // Configurable options
  this.base = 2
  this.gfaritfile = fullfile(TMPDIR,"gfarit.txt")
  this.gfplysfile = fullfile(TMPDIR,"gfplys.txt")
  this.dimmax = 50
  this.nbsimmax = 2^31 - 1
endfunction



// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function this = ldniedf_new ()
  // Create a new Fast Niederreiter Arbitrary Base object.
  //

  this = tlist([
    "LDNIEDF"
    "verbose"
    "dimension"
    "sequenceindex"
    "startedup"
    "skip"
    "leap"
    "base"
    "gfaritfile"
    "gfplysfile"
    ])
  //
  // Configurable options
  this.verbose =%f
  this.dimension = 1
  this.sequenceindex = 0
  this.skip = 0
  this.leap = 0
  this.base = 2
  this.gfaritfile = fullfile(TMPDIR,"gfarit.txt")
  this.gfplysfile = fullfile(TMPDIR,"gfplys.txt")
  //
  // Non Configurable options
  this.startedup = 0
endfunction



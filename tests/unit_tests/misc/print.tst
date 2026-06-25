// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2011 - DIGITEO - Michael Baudin

//
// This file must be used under the terms of the GNU LGPL license.
// 

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->
// <-- NO CHECK REF --> 

//
// Check the printing system.
// Do not check the reference file, because 
// temporary files used by Niederreiter algorithm: 
// this depends on the O.S. in a non-portable way.
//
sequencearray = lowdisc_methods ();
for sequencename = sequencearray'
  lds = lowdisc_new(sequencename);
  //
  // Test the display before startup
  disp(string(lds))
  disp(lds)
  //

  // Test printing system (after startup)
  disp(string(lds))
  disp(lds)
  disp(lds.sequence)
  lds = lowdisc_destroy(lds);
end


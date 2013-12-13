// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2011 - DIGITEO - Michael Baudin

//
// This file must be used under the terms of the 
// GNU LGPL license.
// 

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

// See http://forge.scilab.org/index.php/p/lowdisc/issues/1297/
lds = lowdisc_new ( );
lds = lowdisc_destroy(lds);

//
// Check the configure/cget methods.
//
sequencearray = lowdisc_methods ();
for sequencename = sequencearray'
  lds = lowdisc_new(sequencename);
  //
  lds = lowdisc_configure(lds,"-dimension",12);
  nbdim = lowdisc_cget(lds,"-dimension");
  assert_checkequal ( nbdim , 12 );
  //
  index = lowdisc_get(lds,"-index");
  assert_checkequal ( index , 0 );
  //
  verbose = lowdisc_cget(lds,"-verbose");
  assert_checkequal ( verbose , %f );
  //
  lds = lowdisc_configure(lds,"-verbose",%T);
  verbose = lowdisc_cget(lds,"-verbose");
  assert_checkequal ( verbose , %T );
  //
  method = lowdisc_cget(lds,"-method");
  assert_checkequal ( method , sequencename );
  //
  lds = lowdisc_configure(lds,"-skip",12);
  skip = lowdisc_cget(lds,"-skip");
  assert_checkequal ( skip , 12 );
  //
  lds = lowdisc_configure(lds,"-leap",12);
  leap = lowdisc_cget(lds,"-leap");
  assert_checkequal ( leap , leap );
  //
  dimmax = lowdisc_get(lds,"-dimmax");
  assert_checkequal ( dimmax > 0 , %t );
  //
  nbsimmax = lowdisc_get(lds,"-nbsimmax");
  assert_checkequal ( nbsimmax > 0 , %t );
  //
  lds = lowdisc_destroy(lds);
end


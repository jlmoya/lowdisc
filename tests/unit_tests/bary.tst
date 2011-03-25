// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2011 - DIGITEO - Michael Baudin

//
// This file must be used under the terms of the GNU LGPL license.


// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->


d = lowdisc_bary ( 4 );
assert_checkequal ( d , [1 0 0]' );
//
basis = 2;
digits = lowdisc_bary ( 4 , basis );
assert_checkequal ( digits , [1 0 0]' );
//
digits = lowdisc_bary ( 4 , basis , "littleendian" );
assert_checkequal ( digits , [1 0 0]' );
//
digits = lowdisc_bary ( 4 , basis , "bigendian" );
assert_checkequal ( digits , [0 0 1]' );


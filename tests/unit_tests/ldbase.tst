// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2011 - DIGITEO - Michael Baudin

//
// This file must be used under the terms of the GNU LGPL license.
// 

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

ldb = ldbase_new("fast");
ldb
//
startedup = ldbase_get ( ldb , "-startedup" );
assert_checkequal ( startedup , %f );
//
ldb = ldbase_configure ( ldb , "-dimension" , 4 );
dimension = ldbase_cget ( ldb , "-dimension" );
assert_checkequal ( dimension , 4 );
//
verbose = ldbase_cget ( ldb , "-verbose" );
assert_checkequal ( verbose , %f );
//
ldb = ldbase_configure ( ldb , "-verbose" , %t );
verbose = ldbase_cget ( ldb , "-verbose" );
assert_checkequal ( verbose , %t );
//
skip = ldbase_cget ( ldb , "-skip" );
assert_checkequal ( skip , 0 );
//
ldb = ldbase_configure ( ldb , "-skip" , 10 );
skip = ldbase_cget ( ldb , "-skip" );
assert_checkequal ( skip , 10 );
//
leap = ldbase_cget ( ldb , "-leap" );
assert_checkequal ( leap , 0 );
//
ldb = ldbase_configure ( ldb , "-leap" , 10 );
leap = ldbase_cget ( ldb , "-leap" );
assert_checkequal ( leap , 10 );
//
ldb = ldbase_startup ( ldb );
//
startedup = ldbase_get ( ldb , "-startedup" );
assert_checkequal ( startedup , %t );
//
sequenceindex = ldbase_get ( ldb , "-index" );
assert_checkequal ( sequenceindex , 0 );
//
ldb = ldbase_incr ( ldb );
sequenceindex = ldbase_get ( ldb , "-index" );
assert_checkequal ( sequenceindex , 1 );
//
ldb = ldbase_indexset ( ldb , 10 );
sequenceindex = ldbase_get ( ldb , "-index" );
assert_checkequal ( sequenceindex , 10 );
//
ldb = ldbase_destroy ( ldb );


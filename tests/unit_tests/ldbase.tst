// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2011 - DIGITEO - Michael Baudin

//
// This file must be used under the terms of the 
// GNU LGPL license.
// 

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

for m=lowdisc_methods()'
    ldb = lowdisc_new(m);
    disp(ldb)
    //
    startedup = lowdisc_get ( ldb , "-startedup" );
    assert_checkequal ( startedup , %f );
    //
    ldb = lowdisc_configure ( ldb , "-dimension" , 4 );
    dimension = lowdisc_cget ( ldb , "-dimension" );
    assert_checkequal ( dimension , 4 );
    //
    verbose = lowdisc_cget ( ldb , "-verbose" );
    assert_checkequal ( verbose , %f );
    //
    ldb = lowdisc_configure ( ldb , "-verbose" , %t );
    verbose = lowdisc_cget ( ldb , "-verbose" );
    assert_checkequal ( verbose , %t );
    //
    skip = lowdisc_cget ( ldb , "-skip" );
    assert_checkequal ( skip , 0 );
    //
    ldb = lowdisc_configure ( ldb , "-skip" , 10 );
    skip = lowdisc_cget ( ldb , "-skip" );
    assert_checkequal ( skip , 10 );
    ldb = lowdisc_configure ( ldb , "-skip" , 0 );
    //
    leap = lowdisc_cget ( ldb , "-leap" );
    assert_checkequal ( leap , 0 );
    //
    ldb = lowdisc_configure ( ldb , "-leap" , 10 );
    leap = lowdisc_cget ( ldb , "-leap" );
    assert_checkequal ( leap , 10 );
    ldb = lowdisc_configure ( ldb , "-leap" , 0 );
    //
    sequenceindex = lowdisc_get ( ldb , "-index" );
    assert_checkequal ( sequenceindex , 0 );
    //
    [ldb,next] = lowdisc_next ( ldb );
    sequenceindex = lowdisc_get ( ldb , "-index" );
    assert_checkequal ( sequenceindex , 1 );
    //
    startedup = lowdisc_get ( ldb , "-startedup" );
    assert_checkequal ( startedup , %t );
    //
    [ldb,next] = lowdisc_next ( ldb , 9 );
    sequenceindex = lowdisc_get ( ldb , "-index" );
    assert_checkequal ( sequenceindex , 10 );
    //
    ldb = lowdisc_destroy ( ldb );
end


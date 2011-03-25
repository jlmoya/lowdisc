// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2011 - DIGITEO - Michael Baudin

//
// This file must be used under the terms of the GNU LGPL license.
// 

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

ld = ldfaure_new();
ld
ld = ldfaure_configure ( ld , "-dimension" , 3 );
ld = ldfaure_startup ( ld );
[ld,computed] = ldfaure_next (ld);
expected = [1/3 1/3 1/3];
assert_checkalmostequal ( computed, expected, %eps );
[ld,computed]=ldfaure_next(ld,7);
expected= [
    2/3 2/3 2/3 
    1/9 4/9 7/9 
    4/9 7/9 1/9 
    7/9 1/9 4/9 
    2/9 8/9 5/9 
    5/9 2/9 8/9 
    8/9 5/9 2/9
];
assert_checkalmostequal ( computed, expected, %eps );
ld = ldfaure_destroy ( ld );


// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2011 - DIGITEO - Michael Baudin

//
// This file must be used under the terms of the 
// GNU LGPL license.
// 

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

//
// Check the Fast Faure sequence in dimension 3
//
lds = lowdisc_new("faure");
lds = lowdisc_configure(lds,"-dimension",3);
lds = lowdisc_startup (lds);
// Term #1
[lds,computed] = lowdisc_next (lds);
expected = [1/3 1/3 1/3];
assert_checkalmostequal ( computed, expected, %eps );
// Terms #2 to #6
[lds,computed]=lowdisc_next(lds,7);
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
lds = lowdisc_destroy(lds);



// Copyright (C) 2013 - 2014 - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2011 - DIGITEO - Michael Baudin

//
// This file must be used under the terms of the 
// GNU LGPL license.
// 

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

//
// Check the Fast Reverse Halton sequence
//
lds = lowdisc_new("halton");
lds = lowdisc_configure(lds,"-dimension",2);
lds = lowdisc_configure(lds,"-scrambling","Reverse");

// Term #1
[lds,computed] = lowdisc_next (lds);
expected = [0.5 2.0/3.];
assert_checkalmostequal ( computed, expected , 10 * %eps );
// Terms #2 to #6
[lds,computed]=lowdisc_next(lds,5);
expected= [...
    1.0/4. 1.0/3. 
    3.0/4. 2.0/9.    
    1.0/8. 8.0/9. 
    5.0/8. 5.0/9. 
    3.0/8. 1.0/9. 
];
assert_checkalmostequal ( computed, expected , 10 * %eps );
lds = lowdisc_destroy(lds);


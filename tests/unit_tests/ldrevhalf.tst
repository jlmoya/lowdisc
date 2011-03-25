// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2011 - DIGITEO - Michael Baudin

//
// This file must be used under the terms of the GNU LGPL license.
// 

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

//
// Check the Fast Reverse Halton sequence
//
lds = ldrevhalf_new();
lds = ldrevhalf_configure(lds,"-dimension",2);
lds = ldrevhalf_startup (lds);
// Term #1
[lds,computed] = ldrevhalf_next (lds);
expected = [0.5 2./3.];
assert_checkalmostequal ( computed, expected , 10 * %eps );
// Terms #2 to #6
[lds,computed]=ldrevhalf_next(lds,5);
expected= [...
    1./4. 1./3. 
    3./4. 2./9.    
    1./8. 8./9. 
    5./8. 5./9. 
    3./8. 1./9. 
];
assert_checkalmostequal ( computed, expected , 10 * %eps );
lds = ldrevhalf_destroy(lds);


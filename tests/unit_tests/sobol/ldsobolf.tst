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
// Check the Fast Sobol sequence
//
lds = lowdisc_new("sobol");
lds = lowdisc_configure(lds,"-dimension",2);

// Term #1
[lds,computed] = lowdisc_next (lds);
expected = [0.5 0.5];
assert_checkalmostequal ( computed, expected, 10*%eps );
// Terms #2 to #6
[lds,computed]=lowdisc_next(lds,5);
expected= [
    3./4. 1./4. 
    1./4. 3./4.    
    3./8. 3./8. 
    7./8. 7./8. 
    5./8. 1./8. 
];
assert_checkalmostequal ( computed, expected, 10*%eps );
lds = lowdisc_destroy(lds);



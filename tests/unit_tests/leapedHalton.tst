// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

// Check leaped Halton in dimensions 2-10.
// This checks that bug #1112
// http://forge.scilab.org/index.php/p/lowdisc/issues/1112
// wont happen again.
for s=2:20
    u=lowdisc_ldgen ( 1000 , s , "halton" , %f );
    umin=min(u,"r");
    assert_checkalmostequal(umin,zeros(1,s),[],1.e-2);
    umax=max(u,"r");
    assert_checkalmostequal(umax,ones(1,s),[],1.e-2);
end

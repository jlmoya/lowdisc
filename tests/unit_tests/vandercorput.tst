// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2011 - DIGITEO - Michael Baudin

//
// This file must be used under the terms of the GNU LGPL license.
// 

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

// Check the terms 0 to 10 in base 2.
for i = 0 : 10
  s(i+1) = lowdisc_vandercorput ( i , 2 );
end
e = [0,0.5,0.25,0.75,0.125,0.625,0.375,0.875,0.0625,0.5625,0.3125]';
assert_checkalmostequal ( s , e , %eps );





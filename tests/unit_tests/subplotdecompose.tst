// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2011 - DIGITEO - Michael Baudin

//
// This file must be used under the terms of the GNU LGPL license.
// 

[m,n] = lowdisc_subplotdecompose(7);
assert_checkequal(m,3);
assert_checkequal(n,3);

// Print a table of decomposition
T = [];
for p = 1:20
[m,n] = lowdisc_subplotdecompose(p);
T(p,:)=[p m n n/m];
end
E = [
    1.     1.    1.    1.         
    2.     1.    2.    2.         
    3.     2.    2.    1.         
    4.     2.    2.    1.         
    5.     2.    3.    1.5        
    6.     2.    3.    1.5        
    7.     3.    3.    1.         
    8.     2.    4.    2.         
    9.     3.    3.    1.         
    10.    3.    4.    1.3333333  
    11.    3.    4.    1.3333333  
    12.    3.    4.    1.3333333  
    13.    4.    4.    1.         
    14.    4.    4.    1.         
    15.    3.    5.    1.6666667  
    16.    4.    5.    1.25       
    17.    4.    5.    1.25       
    18.    4.    5.    1.25       
    19.    4.    5.    1.25       
    20.    4.    5.    1.25       
];
assert_checkalmostequal(T,E,1.e-5);

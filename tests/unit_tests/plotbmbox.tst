// Copyright (C) 2012 - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.
// 

// Plot all elementary intervals with volume 2^3
scf();
lowdisc_plotbmbox(2,3)

// Plot elementary intervals with volume 2^3,
// and add Faure points (insert zero).
[ evalf , u ] = lowdisc_ldgen ( 2^4-1 , 2 , "fauref" , %t );
u = [0,0;u];
scf();
lowdisc_plotbmbox(2,3,u);

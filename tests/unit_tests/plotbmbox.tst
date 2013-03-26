// Copyright (C) 2012 - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.
// 

// Plot all elementary intervals with volume 2^3
scf();
lowdisc_plotbmbox(2,3)

// Plot elementary intervals with volume 2^3,
// and add Sobol points (insert zero).
u = lowdisc_ldgen ( 2^4-1 , 2 );
u = [0,0;u];
scf();
lowdisc_plotbmbox(2,3,u);

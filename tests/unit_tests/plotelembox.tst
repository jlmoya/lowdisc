// Copyright (C) 2012 - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.
// 

// Plot an elementary interval with volume 2^3
lowdisc_plotelembox(2,[2 1]);

// Use a different basis for each direction.
// This is useful for Halton sequence.
scf();
lowdisc_plotelembox([2 3],[2 1]);

// Plot all elementary intervals with volume b^m=2^3
b = 2;
m = 3;
C = lowdisc_combinesum(m);
n = size(C,"r");
for i = 1 : n
scf();
lowdisc_plotelembox(b,C(i,:));
end

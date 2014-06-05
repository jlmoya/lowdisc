// Copyright (C) 2014 - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.
// 

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

// See the -coordinate option in action.
// Show how to get the 12-th coordinate of the
// Sobol sequence.
lds = lowdisc_new("sobol");
lds = lowdisc_configure(lds,"-dimension",12);
lds = lowdisc_configure(lds,"-coordinate",%t);
// Elements #1,...,#5, coordinate index = 12.
[lds,computed1] = lowdisc_next (lds,5);
// Elements #6,...,#10, coordinate index = 12.
[lds,computed2] = lowdisc_next (lds,5);
lds = lowdisc_destroy(lds);
//
// Reference : 12-th coordinate of dimension 12 Sobol
lds = lowdisc_new("sobol");
lds = lowdisc_configure(lds,"-dimension",12);
[lds,expected] = lowdisc_next (lds,10);
lds = lowdisc_destroy(lds);
expected=expected(:,12)
//
// Tests
assert_checkequal(computed1,expected(1:5));
assert_checkequal(computed2,expected(6:10));
//
// Scrambled Sobol sequence.
lds = lowdisc_new("sobol");
lds = lowdisc_configure(lds,"-dimension",12);
lds = lowdisc_configure(lds,"-scrambling","Owen");
lds = lowdisc_configure(lds,"-coordinate",%t);
// Elements #1,...,#5, coordinate index = 12.
[lds,computed1] = lowdisc_next (lds,5);
// Elements #6,...,#10, coordinate index = 12.
[lds,computed2] = lowdisc_next (lds,5);
lds = lowdisc_destroy(lds);
//
// Reference : 12-th coordinate of dimension 12 Sobol
lds = lowdisc_new("sobol");
lds = lowdisc_configure(lds,"-dimension",12);
lds = lowdisc_configure(lds,"-scrambling","Owen");
[lds,expected] = lowdisc_next (lds,10);
lds = lowdisc_destroy(lds);
expected=expected(:,12)
//
// Tests
assert_checkequal(computed1,expected(1:5));
assert_checkequal(computed2,expected(6:10));

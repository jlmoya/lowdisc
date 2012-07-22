// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

demopath = get_absolute_file_path("lowdisc.dem.gateway.sce");
subdemolist = [
"bench_ldgen", "bench_ldgen.sce"; ..
"tms_nets", "tms_nets.sce";..
"runtests", "runtests.sce"; ..
"test_faure.dim3", "test_faure.dim3.sce"; ..
"test_faure.dim4", "test_faure.dim4.sce"; ..
"test_faure.glasserman", "test_faure.glasserman.sce"; ..
"test_fauref.dim4", "test_fauref.dim4.sce"; ..
"test_halton.dim4", "test_halton.dim4.sce"; ..
"test_haltonf.dim4", "test_haltonf.dim4.sce"; ..
"test_nied2.dim4", "test_nied2.dim4.sce"; ..
"test_niedf.base2.dim4", "test_niedf.base2.dim4.sce"; ..
"test_niedf.base2.dim6", "test_niedf.base2.dim6.sce"; ..
"test_niedf.base7.dim6", "test_niedf.base7.dim6.sce"; ..
"test_sobol.dim4", "test_sobol.dim4.sce"; ..
"test_sobolf.dim4", "test_sobolf.dim4.sce"; ..
];
subdemolist(:,2) = demopath + subdemolist(:,2)

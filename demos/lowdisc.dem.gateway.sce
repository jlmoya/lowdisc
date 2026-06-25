// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

demopath = get_absolute_file_path("lowdisc.dem.gateway.sce");
subdemolist = [
"Macros Generators", fullfile("ld-macros","ld-macros.dem.gateway.sce"); ..
"Scrambled Sequences", fullfile("rqmc","rqmc.dem.gateway.sce"); ..
"Van Der Corput", "demo_vandercorput.sce"; ..
"Gray Code", "gray-code.sce"; ..
"Sobol t", "sobol-t.sce"; ..
"bench_ldgen", "bench_ldgen.sce"; ..
"Faure dim. 3", "test_faure.dim3.sce"; ..
"Faure dim. 4", "test_fauref.dim4.sce"; ..
"Faure glasserman", "test_faure.glasserman.sce"; ..
"Halton dim. 4", "test_haltonf.dim4.sce"; ..
"Nied. base 2.dim. 4", "test_niedf.base2.dim4.sce"; ..
"Nied. base 2.dim. 6", "test_niedf.base2.dim6.sce"; ..
"Nied. base 7.dim. 6", "test_niedf.base7.dim6.sce"; ..
"Sobol dim. 4", "test_sobolf.dim4.sce"; ..
"Discrepancy in 1D", "compute-disc1D.sce"; ..
];
subdemolist(:,2) = demopath + subdemolist(:,2)

// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

demopath = get_absolute_file_path("rqmc.dem.gateway.sce");
subdemolist = [
"Scrambled Halton", "rqmc-halton.sce"; ..
"Scrambled Sobol", "rqmc-sobol.sce"; ..
];
subdemolist(:,2) = demopath + subdemolist(:,2)

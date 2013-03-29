// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

demopath = get_absolute_file_path("ld-macros.dem.gateway.sce");
subdemolist = [
"Van Der Corput", "macros-vandercorput.sce"; ..
"Halton", "macros-halton.sce"; ..
"Halton-RR2", "macros-halton-RR2.sce"; ..
"Sobol", "macros-sobol.sce"; ..
"Faure", "macros-faure.sce"; ..
"Niederreiter2", "macros-niederreiter2.sce"; ..
"Reverse Halton", "macros-reversehalton.sce"; ..
];
subdemolist(:,2) = demopath + subdemolist(:,2)

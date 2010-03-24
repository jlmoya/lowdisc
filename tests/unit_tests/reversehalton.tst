// Copyright (C) 2008 - INRIA - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt





//
// Check the Reverse Halton sequence
//
rng = lowdisc_new();
rng = lowdisc_configure(rng,"-method","reversehalton");
rng = lowdisc_configure(rng,"-dimension",2);
rng = lowdisc_startup (rng);
// Term #1
[rng,computed] = lowdisc_next (rng);
expected = [0.5 2./3.];
shift = norm(computed-expected)/norm(expected);
if shift > 1.e-6 then pause,end
// Terms #2 to #6
[rng,computed]=lowdisc_terms(rng,5);
expected= [
    1./4. 1./3. 
    3./4. 2./9. 
    1./8. 8./9. 
    5./8. 5./9.
    3./8. 1./9. 
];
shift = norm(computed-expected)/norm(expected);
if shift > 1.e-6 then pause,end
rng = lowdisc_destroy(rng);
clear rng;


// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.
//

//
// Check the Fast Halton sequence in dimension 4
//
DIMEN = 4;
mprintf ("SCILAB\n")
mprintf ("DIMENSION = %d\n", DIMEN)
rng = lowdisc_new("halton");
rng = lowdisc_configure(rng,"-dimension",DIMEN);
rng = lowdisc_startup (rng);
[rng,computed]=lowdisc_next(rng);
mprintf ("%8d %14.6f %14.6f %14.6f %14.6f\n", 0 , computed(1) , computed(2) , computed(3) , computed(4) )
// Terms #1 to #100
[rng,computed]=lowdisc_next(rng,100);
for i = 1:100
  mprintf ("%8d %14.6f %14.6f %14.6f %14.6f\n", i , computed(i,1) , computed(i,2) , computed(i,3) , computed(i,4) )
end
rng = lowdisc_destroy(rng);



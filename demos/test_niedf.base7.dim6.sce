// Copyright (C) 2008 - INRIA - Michael Baudin

//
// Check the Fast Niederreiter in dimension 6
// Use the base 7.
//
DIMEN = 6;
BASE = 7;
mprintf ("SCILAB\n")
mprintf ("DIMENSION = %d\n", DIMEN)
mprintf ("BASE = %d\n", BASE)
rng = lowdisc_new("niederreiterf");
rng = lowdisc_configure(rng,"-dimension",DIMEN);
rng = lowdisc_configure(rng,"-base",BASE);
rng = lowdisc_startup (rng);
[rng,computed]=lowdisc_next(rng);
mprintf ("%8d %14.6f %14.6f %14.6f %14.6f %14.6f %14.6f\n", 0 , computed(1) , computed(2) , computed(3) , computed(4) , computed(5) , computed(6) )
// Terms #1 to #100
[rng,computed]=lowdisc_next(rng,100);
for i = 1:100
  mprintf ("%8d %14.6f %14.6f %14.6f %14.6f %14.6f %14.6f\n", i , computed(i,1) , computed(i,2) , computed(i,3) , computed(i,4) , computed(i,5) , computed(i,6) )
end
rng = lowdisc_destroy(rng);

//
// Load this script into the editor
//
filename = "test_niedf.base7.dim6.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );


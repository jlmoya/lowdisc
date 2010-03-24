// Copyright (C) 2008 - INRIA - Michael Baudin

//
// Check the Faure sequence in dimension 4
//
mprintf ("SCILAB\n")
rng = lowdisc_new();
rng = lowdisc_configure(rng,"-method","faure");
rng = lowdisc_configure(rng,"-dimension",3);
// Skip qs^4 - 1 terms, as in TOMS implementation
qs = lowdisc_get ( rng , "-faureprime" );
rng = lowdisc_configure(rng,"-skip", qs^4 - 2);
lowdisc_display ( rng )
rng = lowdisc_startup (rng);
[rng,computed]=lowdisc_next(rng);
mprintf ("%8d %14.6f %14.6f %14.6f\n", 0 , computed(1) , computed(2) , computed(3) )
// Terms #1 to #100
[rng,computed]=lowdisc_terms(rng,100);
for i = 1:100
  mprintf ("%8d %14.6f %14.6f %14.6f\n", i , computed(i,1) , computed(i,2) , computed(i,3) )
end
rng = lowdisc_destroy(rng);



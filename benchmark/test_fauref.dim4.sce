// Copyright (C) 2008 - INRIA - Michael Baudin

//
// Check the Fast Faure sequence in dimension 4
//
[fd,err]=mopen( "test_fauref.dim4.log.txt" , "w" )
mfprintf ( fd , "SCILAB\n")
rng = lowdisc_new();
rng = lowdisc_configure(rng,"-method","fauref");
rng = lowdisc_configure(rng,"-dimension",4);
// Skip qs^4 - 1 terms, as in TOMS implementation
qs = lowdisc_get ( rng , "-faurefprime" );
rng = lowdisc_configure(rng,"-skip", qs^4 - 2);
str = string(rng);
nrows = size(str,"r");
for irow = 1 : nrows
  mfprintf ( fd , "%s\n" , str(irow) )
end
rng = lowdisc_startup (rng);
mfprintf ( fd , "====================================================================\n" )
[rng,computed]=lowdisc_next(rng,100);
for i = 1:100
  mfprintf ( fd , "%8d %14.6f %14.6f %14.6f %14.6f\n", i , computed(i,1) , computed(i,2) , computed(i,3) , computed(i,4) )
end
rng = lowdisc_destroy(rng);
mclose(fd)


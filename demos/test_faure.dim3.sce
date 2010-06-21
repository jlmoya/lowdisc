// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.
//

//
// Check the Faure sequence in dimension 3
//
[fd,err]=mopen( "test_faure.dim3.log.txt" , "w" )
mfprintf ( fd , "SCILAB\n")
rng = lowdisc_new("faure");
rng = lowdisc_configure(rng,"-dimension",3);
// Skip qs^4 - 1 terms, as in TOMS implementation
qs = lowdisc_get ( rng , "-faureprime" );
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
  mfprintf ( fd , "%8d %14.6f %14.6f %14.6f\n", i , computed(i,1) , computed(i,2) , computed(i,3) )
end
rng = lowdisc_destroy(rng);
mclose(fd)
//
// Load this script into the editor
//
filename = "test_faure.dim3.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );


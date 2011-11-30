// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.
//

//
// Check the Fast Niederreiter in dimension 6
// Use the base 7.
mprintf("Check the Fast Niederreiter in dimension 6.\n");
mprintf("Use the base 7.\n");
//
path = get_absolute_file_path("test_niedf.base7.dim6.sce");
filepath = fullfile(path,"test_niedf.base7.dim6.txt");
mprintf("Produced Filename: %s\n",filepath);
reffilepath = fullfile(path,"test_nied.base7.dim6.TOMS738.GENIN.log.txt");
mprintf("Reference Filename: %s\n",reffilepath);
//
[fd,err]=mopen( filepath , "w" );
DIMEN = 6;
BASE = 7;
mfprintf (fd,"SCILAB\n")
mfprintf (fd,"DIMENSION = %d\n", DIMEN)
mfprintf (fd,"BASE = %d\n", BASE)
mfprintf(fd,"====================================================================\n")
rng = lowdisc_new("niederreiterf");
rng = lowdisc_configure(rng,"-dimension",DIMEN);
rng = lowdisc_configure(rng,"-base",BASE);
rng = lowdisc_startup (rng);
[rng,computed]=lowdisc_next(rng);
mfprintf (fd,"%8d %14.6f %14.6f %14.6f %14.6f %14.6f %14.6f\n", ..
    0 , computed(1) , computed(2) , computed(3) , computed(4) , computed(5) , computed(6) )
// Terms #1 to #100
[rng,computed]=lowdisc_next(rng,100);
for i = 1:100
  mfprintf (fd,"%8d %14.6f %14.6f %14.6f %14.6f %14.6f %14.6f\n", ..
    i , computed(i,1) , computed(i,2) , computed(i,3) , computed(i,4) , computed(i,5) , computed(i,6) )
end
rng = lowdisc_destroy(rng);
mclose(fd);

//
// Load this script into the editor
//
filename = "test_niedf.base7.dim6.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );


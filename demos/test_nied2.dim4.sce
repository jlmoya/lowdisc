// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.
//

//
// Check the Slow Niederreiter base 2 sequence in dimension 4
mprintf("Check the Slow Niederreiter base 2 sequence in dimension 4.\n");
path = get_absolute_file_path("test_nied2.dim4.sce");
filepath = fullfile(path,"test_nied2.dim4.txt");
mprintf("Produced Filename: %s\n",filepath);
reffilepath = fullfile(path,"test_nied.base2.dim4.TOMS738.GENIN2.log.txt");
mprintf("Reference Filename: %s\n",reffilepath);
reffilepath = fullfile(path,"test_nied.base2.dim4.TOMS738.GENIN.log.txt");
mprintf("Reference Filename #2: %s\n",reffilepath);
mprintf("Caution: with GENIN, the values are the same\n");
mprintf("but the points (i.e. the rows of the file)\n");
mprintf("come in a different order.\n");
//
[fd,err]=mopen( filepath , "w" );
DIMEN = 4;
mfprintf (fd,"SCILAB\n")
mfprintf (fd,"DIMENSION = %d\n", DIMEN)
mfprintf (fd,"BASE = 2\n")
rng = lowdisc_new("niederreiter-base-2");
rng = lowdisc_configure(rng,"-dimension",DIMEN);
rng = lowdisc_startup (rng);
[rng,computed]=lowdisc_next(rng);
mfprintf ( fd , "====================================================================\n" )
mfprintf (fd,"%8d %14.6f %14.6f %14.6f %14.6f\n", 0 , computed(1) , computed(2) , computed(3) , computed(4) )
// Terms #1 to #100
[rng,computed]=lowdisc_next(rng,100);
for i = 1:100
  mfprintf (fd,"%8d %14.6f %14.6f %14.6f %14.6f\n", i , computed(i,1) , computed(i,2) , computed(i,3) , computed(i,4) )
end
rng = lowdisc_destroy(rng);
mclose(fd);

//
// Load this script into the editor
//
filename = "test_nied2.dim4.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );


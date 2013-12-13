// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.
//

//
// Check the Fast Niederreiter in dimension 4
// Use the default base 2.

mprintf("Check the Fast Niederreiter in dimension 4\n");
mprintf("Use the default base 2.\n");
//
path = get_absolute_file_path("test_niedf.base2.dim4.sce");
filepath = fullfile(TMPDIR,"test_niedf.base2.dim4.txt");
mprintf("Produced Filename: %s\n",filepath);
reffilepath = fullfile(path,"test_nied.base2.dim4.TOMS738.GENIN2.log.txt");
mprintf("Reference Filename: %s\n",reffilepath);
reffilepath = fullfile(path,"test_nied.base2.dim4.TOMS738.GENIN.log.txt");
mprintf("Reference Filename #2: %s\n",reffilepath);
mprintf("Caution: with GENIN, the values are the same\n");
mprintf("but the points (i.e. the rows of the file\n");
mprintf("come in a different order.\n");

//
DIMEN = 4;
[fd,err]=mopen( filepath , "w" );
mfprintf(fd,"SCILAB\n")
mfprintf(fd,"DIMENSION = %d\n", DIMEN)
mfprintf(fd,"BASE = 2\n")
mfprintf(fd,"====================================================================\n")
rng = lowdisc_new("niederreiter");
rng = lowdisc_configure(rng,"-dimension",DIMEN);

[rng,computed]=lowdisc_next(rng);
// Terms #1 to #100
[rng,computed]=lowdisc_next(rng,100);
for i = 1:100
  mfprintf (fd,"%8d %14.6f %14.6f %14.6f %14.6f\n", ..
      i , computed(i,1) , computed(i,2) , computed(i,3) , computed(i,4) )
end
rng = lowdisc_destroy(rng);
mclose(fd);

//
// Load this script into the editor
//
filename = "test_niedf.base2.dim4.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );


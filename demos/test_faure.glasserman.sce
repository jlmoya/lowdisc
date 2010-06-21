// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.
//

//
// Prints the elements of Faure sequence, as presented in the following 
// reference in dimension 3, p. 299.
//   Monte-Carlo methods in Financial Engineering, Paul Glasserman
//
computed = [
0 0 0
1/3 1/3 1/3
2/3 2/3 2/3
1/9 4/9 7/9
4/9 7/9 1/9 
7/9 1/9 4/9 
2/9 8/9 5/9
5/9 2/9 8/9
8/9 5/9 2/9
];
for i = 1:9
  mprintf ("%8d %14.6f %14.6f %14.6f\n", i , computed(i,1) , computed(i,2) , computed(i,3) )
end

//
// Load this script into the editor
//
filename = "test_faure.glasserman.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );


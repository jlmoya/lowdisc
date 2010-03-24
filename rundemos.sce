// ====================================================================
// Copyright INRIA 2008-2009
// Allan CORNET
// Simon LIPP
// Michael Baudin
// This file is released into the public domain
// ====================================================================
c=clock();
mprintf("Demos begining the %d/%d/%d at %d:%d:%d",c(1),c(2),c(3),c(4),c(5),c(6));
toolbox_dir = get_absolute_file_path('rundemos.sce');
exec(toolbox_dir + filesep() + "demos" + filesep() + "bfnbenchmark.sce")
exec(toolbox_dir + filesep() + "demos" + filesep() + "nrbenchmark.sce")
c=clock();
mprintf("Demos ending the %d/%d/%d at %d:%d:%d",c(1),c(2),c(3),c(4),c(5),c(6));


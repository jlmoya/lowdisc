// ====================================================================
// Copyright INRIA 2008-2009
// Allan CORNET
// Simon LIPP
// Michael Baudin
// This file is released into the public domain
// ====================================================================
c=clock();
mprintf("Tests beginning the %d/%d/%d at %d:%d:%d",c(1),c(2),c(3),c(4),c(5),c(6));
current = pwd();
toolbox_dir = get_absolute_file_path('runtests.sce');
parent = toolbox_dir + filesep() + '..';
cd(parent);
test_run("randomnumber",[],["create_ref"]);
cd(current);
c=clock();
mprintf("Tests beginning the %d/%d/%d at %d:%d:%d",c(1),c(2),c(3),c(4),c(5),c(6));


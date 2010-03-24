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
toolbox_dir = get_absolute_file_path('runtests.macros.sce');
parent = toolbox_dir + filesep() + '..';
cd(parent);
tests = [
"halton"
"bary"
"basic"
"binomial"
"faure"
"pascal"
"radicalinv"
"ridigits"
"vdc"
];
test_run("lowdiscrepancy",tests);
cd(current);
c=clock();
mprintf("Tests beginning the %d/%d/%d at %d:%d:%d",c(1),c(2),c(3),c(4),c(5),c(6));


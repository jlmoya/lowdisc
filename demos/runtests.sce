// Copyright (C) 2010 - DIGITEO - Michael Baudin
demopath = get_absolute_file_path("runtests.sce");
cwd = pwd();
cd(demopath+"../..");
test_run("lowdisc");
cd(cwd);


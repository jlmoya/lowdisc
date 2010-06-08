// Copyright (C) 2010 - DIGITEO - Michael Baudin

function test_runfromdemo ( demoscript , modulename )
  // Launch the unit tests of the module from the demonstrations.
  //
  // Parameters
  //   demoscript : the name of the demonstration script
  //   modulename : the name of the module
  // 
  // Description
  //   The unit tests of the module are launched from 
  //   a demonstration script located in the demonstrations directory.
  //   We use the test_run function appropriately, by changing 
  //   the current directory and passing the good input argument
  //   to it.
  //
  // Author
  //   2010 - DIGITEO - Michael Baudin
  
  demopath = get_absolute_file_path(demoscript);
  cwd = pwd();
  mprintf("Running unit tests for module : %s\n",modulename );
  cd(demopath+"../..");
  mprintf("Current directory : %s\n",pwd());
  if ( fileinfo(modulename)<>[] ) then
    test_run(modulename);
  else
    if ( atomsIsLoaded(modulename) ) then
      loaded = atomsGetLoaded();
      imodule = find(loaded(:,1)=="uncprb");
      version = loaded(imodule,2);
      test_run(version);
    else
      errmsg = msprintf(gettext("%s: The %s module is not loaded.") , "test_runfromdemo", modulename) 
      error ( errmsg )
    end
  end
  cd(cwd);
  
endfunction

test_runfromdemo ( "runtests.sce" , "lowdisc" );


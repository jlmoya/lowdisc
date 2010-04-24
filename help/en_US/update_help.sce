// Copyright (C) 2010 - DIGITEO - Michael Baudin

// Updates the .xml files by deleting existing files and 
// creating them again from the .sci with help_from_sci.

function helpupdate ( funarray , helpdir , macrosdir , demosdir )
  // Update the help and the demos from the .sci files.
  //
  // Calling Sequence
  //   updatehelp ( funarray , helpdir , macrosdir , demosdir )
  //
  // Parameters
  //   funarray : column matrix of strings. The list of functions to update
  //   helpdir : the help directory
  //   macrosdir : the macros directory
  //   demosdir : the demonstration directory
  //
  // Description
  //   Update the .xml help files and the demos scripts
  //   from the macros corresponding to the function array
  //   of strings funarray.
  //   The existing .xml files in the help dir which 
  //   correspond to file in the funarray are deleted.
  //
  // Author
  //   2010, Michael Baudin

  if ( fileinfo ( helpdir ) == [] ) then
    error(sprintf(gettext("%s: Wrong help directory: %s does not exist.\n"),"updatehelp",helpdir));
  end
  if ( fileinfo ( macrosdir ) == [] ) then
    error(sprintf(gettext("%s: Wrong macros directory: %s does not exist.\n"),"updatehelp",macrosdir));
  end
  if ( fileinfo ( demosdir ) == [] ) then
    error(sprintf(gettext("%s: Wrong demos directory: %s does not exist.\n"),"updatehelp",demosdir));
  end
  
  //
  // 1. Delete the existing .xml help files in the helpdir
  // which correspond to given function names.
  flist = ls(helpdir)';
  for f = flist
    isxml = regexp(f,"/(.*).xml/");
    kf = find(funarray==basename(f))
    if ( isxml <> [] & kf <> [] ) then
      xmlfile = fullfile ( helpdir , f )
      mprintf("Deleting %s\n",xmlfile);
      r = deletefile(xmlfile);
      if ( ~r ) then
        error(sprintf(gettext("%s: Unable to delete xml file: %s\n"),"updatehelp",xmlfile));
      end
    end
  end
  //
  // 2. Generate each .xml and each .sce from the .sci
  flist = ls(macrosdir)';
  for f = flist
    issci = regexp(f,"/(.*).sci/");
    kf = find(funarray==basename(f))
    if ( issci <> [] & kf <> [] ) then
      scifile = fullfile ( macrosdir , f )
      mprintf("Processing %s\n",scifile);
      funname = funarray(kf)
      [helptxt,demotxt]=help_from_sci(scifile)
      xmlfile = fullfile ( helpdir , funname + ".xml" )
      mprintf("  Writing xml %s\n",xmlfile);
      r = mputl ( helptxt , xmlfile )
      if ( ~r ) then
        error(sprintf(gettext("%s: Unable to write xml file: %s\n"),"updatehelp",xmlfile));
      end
      demofile = fullfile ( demosdir , funname + ".sce" )
      mprintf("  Writing demo %s\n",demofile);
      r = mputl ( demotxt , demofile )
      if ( ~r ) then
        error(sprintf(gettext("%s: Unable to write demo file: %s\n"),"updatehelp",demofile));
      end
    end
  end
endfunction




helpdir = get_absolute_file_path('update_help.sce');
// Build the help from the sources.
//help_from_sci(help_dir+"../../macros",help_dir)
funarray = [
  "lowdisc_cget"
  "lowdisc_configure"
  "lowdisc_destroy"
  "lowdisc_display"
  "lowdisc_new"
  "lowdisc_next"
  "lowdisc_reset"
  "lowdisc_startup"
  "lowdisc_terms"
  ];
macrosdir = help_dir+"../../macros";
demosdir = help_dir+"../../demos";

helpupdate ( funarray , helpdir , macrosdir , demosdir )


// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
// Copyright (C) 2012 - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

// Updates the .xml files by deleting existing files and 
// creating them again from the .sci with help_from_sci.

function lowdisc_updatehelp()

//
cwd = get_absolute_file_path("update_help.sce");
//
// Generate the object-oriented library help
helpdir = cwd;
funmat = [
  "lowdisc_ldgen"
  ];
macrosdir = helpdir +"../../macros";
demosdir = [];
modulename = "lowdisc";
helptbx_helpupdate ( funmat , helpdir , macrosdir , demosdir , modulename , %t );
//
// Generate the object-oriented library help
helpdir = fullfile(cwd,"1Generators");
funmat = [
  "lowdisc_cget"
  "lowdisc_get"
  "lowdisc_configure"
  "lowdisc_destroy"
  "lowdisc_new"
  "lowdisc_next"
  ];
macrosdir = cwd +"../../macros";
demosdir = [];
modulename = "lowdisc";
helptbx_helpupdate ( funmat , helpdir , macrosdir , demosdir , modulename , %t );
//
// Generate the static functions help
helpdir = fullfile(cwd,"staticfunctions");
funmat = [
  "lowdisc_stopall"
  "lowdisc_methods"
  ];
macrosdir = cwd +"../../macros";
demosdir = [];
modulename = "lowdisc";
helptbx_helpupdate ( funmat , helpdir , macrosdir , demosdir , modulename , %t );
//
// Generate the favorable parameters functions help
helpdir = fullfile(cwd,"favpar");
funmat = [
  "lowdisc_haltonsuggest"
  "lowdisc_fauresuggest"
  "lowdisc_sobolsuggest"
  "lowdisc_niedersuggest"
  "lowdisc_niederbase"
  ];
macrosdir = cwd +"../../macros";
demosdir = [];
modulename = "lowdisc";
helptbx_helpupdate ( funmat , helpdir , macrosdir , demosdir , modulename , %t );
//
// Generate the support functions help
helpdir = fullfile(cwd,"supportfunctions");
funmat = [
  "lowdisc_plotelembox"
  "lowdisc_plotbmbox"
  "lowdisc_getpath"
  ];
macrosdir = cwd +"../../macros";
demosdir = [];
modulename = "lowdisc";
helptbx_helpupdate ( funmat , helpdir , macrosdir , demosdir , modulename , %t );


endfunction 
lowdisc_updatehelp();
clear lowdisc_updatehelp


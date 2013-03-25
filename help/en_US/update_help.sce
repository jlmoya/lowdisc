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
helpdir = fullfile(cwd,"0generators");
funmat = [
  "lowdisc_cget"
  "lowdisc_get"
  "lowdisc_configure"
  "lowdisc_destroy"
  "lowdisc_new"
  "lowdisc_next"
  "lowdisc_startup"
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
  "lowdisc_soboltau"
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
  "lowdisc_bitlo0"
  "lowdisc_bithi1"
  "lowdisc_bitxor"
  "lowdisc_dec2bin"
  "lowdisc_bitor"
  "lowdisc_bitand"
  "lowdisc_proj2d"
  "lowdisc_plotelembox"
  "lowdisc_combinesum"
  "lowdisc_plotbmbox"
  "lowdisc_subplotdecompose"
  "lowdisc_getpath"
  ];
macrosdir = cwd +"../../macros";
demosdir = [];
modulename = "lowdisc";
helptbx_helpupdate ( funmat , helpdir , macrosdir , demosdir , modulename , %t );

//
// Generate the macros-based generator help
helpdir = fullfile(cwd,"macrogenerators");
funmat = [
  "lowdisc_vandercorput"
  "lowdisc_haltonnext"
  "lowdisc_sobolstart"
  "lowdisc_sobolskip"
  "lowdisc_sobolnext"
  ];
macrosdir = cwd +"../../macros";
demosdir = [];
modulename = "lowdisc";
helptbx_helpupdate ( funmat , helpdir , macrosdir , demosdir , modulename , %t );

endfunction 
lowdisc_updatehelp();
clear lowdisc_updatehelp

